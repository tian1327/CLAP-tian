import pickle

preprocessed = "/scratch/group/real-fs/dataset/eurosat/split_fewshot/shot_1-seed_1.pkl"
print(f"Loading preprocessed few-shot data from {preprocessed}")
with open(preprocessed, "rb") as file:
    data = pickle.load(file)

print(type(data))
print('len(data): ', len(data))
train, val = data["train"], data["val"]
print('len(train): ', len(train))
print('len(val): ', len(val))

print('train[0]: ', train[0])