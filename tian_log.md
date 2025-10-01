1. download the OpenCLIP model checkpoint weights from [repo](https://github.com/mlfoundations/open_clip/releases/tag/v0.2-weights), and then save into `CLAP-tian/openclip_ckpts/`.

```bash
cd openclip_ckpts/

# vit-b/32
wget https://github.com/mlfoundations/open_clip/releases/download/v0.2-weights/vit_b_32-quickgelu-laion400m_e32-46683a32.pt

# vit-b/16
wget https://github.com/mlfoundations/open_clip/releases/download/v0.2-weights/vit_b_16-laion400m_e32-55e67d44.pt

mv vit_b_32-quickgelu-laion400m_e32-46683a32.pt openclip_ckpts/
```

2. create soft links to the datasets
```bash
mkdir data/
cd data/
ln -s /scratch/group/real-fs/dataset/eurosat/ eurosat
ln -s /scratch/group/real-fs/dataset/dtd/dtd/ dtd/
ln -s /scratch/group/real-fs/dataset/fgvc-aircraft/fgvc-aircraft-2013b/data fgvc_aircraft
ln -s /scratch/group/real-fs/dataset/flowers102 oxford_flowers
ln -s /scratch/group/real-fs/dataset/semi-aves semi-aves
ln -s /scratch/group/real-fs/dataset/oxford_pets oxford_pets
ln -s /scratch/group/real-fs/dataset/food101 food101
ln -s /scratch/group/real-fs/dataset/stanford_cars stanford_cars
```

3. run CLAP
```bash
# enter the env
conda activate clap

# reproduce the original code
bash scripts/adapt.sh 0 eurosat SGD_lr1e-1_B256_ep300 16 ZS l2 RN50


# run the bash script !!!
bash run_clap_tian.sh

# the modified code will replace the weights using downloaded OpenCLIP weights
bash scripts/adapt.sh 0 eurosat SGD_lr1e-1_B256_ep300 4 ZS l2 ViT-B/32

bash scripts/adapt.sh 0 oxford_pets SGD_lr1e-1_B256_ep300 4 ZS l2 ViT-B/32
bash scripts/adapt.sh 0 oxford_pets SGD_lr1e-1_B256_ep300 8 ZS l2 ViT-B/32
bash scripts/adapt.sh 0 oxford_pets SGD_lr1e-1_B256_ep300 16 ZS l2 ViT-B/32

bash scripts/adapt.sh 0 stanford_cars SGD_lr1e-1_B256_ep300 4 ZS l2 ViT-B/32
bash scripts/adapt.sh 0 stanford_cars SGD_lr1e-1_B256_ep300 8 ZS l2 ViT-B/32
bash scripts/adapt.sh 0 stanford_cars SGD_lr1e-1_B256_ep300 16 ZS l2 ViT-B/32


bash scripts/adapt.sh 0 oxford_flowers SGD_lr1e-1_B256_ep300 8 ZS l2 ViT-B/32
bash scripts/adapt.sh 0 oxford_flowers SGD_lr1e-1_B256_ep300 8 ZS l2 ViT-B/16

bash scripts/adapt.sh 0 semi-aves SGD_lr1e-1_B256_ep300 8 ZS l2 ViT-B/16

```


----
## POC

```bash

# create soft links to the datasets
mkdir data/
cd data/
ln -s /home/ltmask/dataset/semi-aves/ semi-aves
ln -s /home/ltmask/dataset/species196_insecta/ species196_insecta
ln -s /home/ltmask/dataset/species196_weeds/ species196_weeds
ln -s /home/ltmask/dataset/species196_mollusca/ species196_mollusca
ln -s /home/ltmask/dataset/fungitastic-m/ fungitastic-m
ln -s /home/ltmask/dataset/fish-vista-m/ fish-vista-m

# add the *.py files in datasets/
cd datasets/
cp semi_aves.py species196_insecta.py
cp species196_insecta.py species196_weeds.py
cp species196_insecta.py species196_mollusca.py
cp species196_insecta.py fungitastic-m.py
cp species196_insecta.py fish-vista-m.py
cd ..

# add the configs in configs/datasets/
cd configs/datasets/
cp semi_aves.yaml species196_insecta.yaml
cp species196_insecta.yaml species196_weeds.yaml
cp species196_insecta.yaml species196_mollusca.yaml
cp species196_insecta.yaml fungitastic-m.yaml
cp species196_insecta.yaml fish-vista-m.yaml
cd ../../

# run the bash script !!!
bash run_clap_tian.sh

```