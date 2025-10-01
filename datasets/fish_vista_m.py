import os
import pickle

from dassl.data.datasets import DATASET_REGISTRY, Datum, DatasetBase
from dassl.utils import mkdir_if_missing

from .oxford_pets import OxfordPets
from .dtd import DescribableTextures as DTD
import json

DATASET_NAME = "fish-vista-m"

def read_split(filepath):

    with open(f'/home/ltmask/post-hoc_correction/data/{DATASET_NAME}/{DATASET_NAME}_labels.json', 'r') as f:
        classname_map = json.load(f)
    # print(f'len(classname_map): {len(classname_map)}')

    items = []

    with open(filepath, "r") as f:
        for line in f:
            line = line.strip()
            entried = line.split(" ")
            impath = f"/home/ltmask/dataset/{DATASET_NAME}/" + entried[0]
            label = entried[1]
            # classname = classname_map[label]["name"]
            classname = classname_map[label]["most_common_name"]

            # print(f'impath: {impath}, label: {label}, classname: {classname}')

            items.append(Datum(impath=impath, label=int(label), classname=classname))

    return items


@DATASET_REGISTRY.register()
class FishVistaM(DatasetBase):

    dataset_dir = f"{DATASET_NAME}"

    def __init__(self, cfg):
        # root = os.path.abspath(os.path.expanduser(cfg.DATASET.ROOT))
        root = '/home/ltmask/post-hoc_correction/data/'

        self.dataset_dir = os.path.join(root, self.dataset_dir)

        # self.split_fewshot_dir = os.path.join(self.dataset_dir, "split_fewshot")
        # mkdir_if_missing(self.split_fewshot_dir)

        num_shots = cfg.DATASET.NUM_SHOTS
        seed = cfg.SEED

        test = read_split(f'{self.dataset_dir}/test.txt')
       
        # preprocessed = os.path.join(self.split_fewshot_dir, f"shot_{num_shots}-seed_{seed}.pkl")
        # if os.path.exists(preprocessed):
        #     print(f"Loading preprocessed few-shot data from {preprocessed}")
        #     with open(preprocessed, "rb") as file:
        #         data = pickle.load(file)
        #         train, val = data["train"], data["val"]
        # else:

        train = read_split(f'{self.dataset_dir}/fewshot{num_shots}_seed{seed}.txt')
        val = read_split(f'{self.dataset_dir}/fewshot{num_shots}_seed{seed}.txt')            

        data = {"train": train, "val": val}
        # print(f"Saving preprocessed few-shot data to {preprocessed}")
        # with open(preprocessed, "wb") as file:
        #     pickle.dump(data, file, protocol=pickle.HIGHEST_PROTOCOL)

        super().__init__(train_x=train, val=val, test=test)