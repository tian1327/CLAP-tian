1. download the OpenCLIP model checkpoint weights from [repo](https://github.com/mlfoundations/open_clip/releases/tag/v0.2-weights)
```bash
# vit-b/32
wget https://github.com/mlfoundations/open_clip/releases/download/v0.2-weights/vit_b_32-quickgelu-laion400m_e32-46683a32.pt

# vit-b/16
wget https://github.com/mlfoundations/open_clip/releases/download/v0.2-weights/vit_b_16-laion400m_e32-55e67d44.pt
```

2. create soft links to the datasets
```bash
ln -s /scratch/group/real-fs/dataset/eurosat/ eurosat
ln -s /scratch/group/real-fs/dataset/dtd/dtd/ dtd/
ln -s /scratch/group/real-fs/dataset/fgvc-aircraft/fgvc-aircraft-2013b/data fgvc_aircraft
ln -s /scratch/group/real-fs/dataset/flowers102 oxford_flowers
ln -s /scratch/group/real-fs/dataset/semi-aves semi-aves
```

3. run CLAP
```bash
# reproduce the original code
bash scripts/adapt.sh 0 eurosat SGD_lr1e-1_B256_ep300 16 ZS l2 RN50

# the modified code will replace the weights using downloaded OpenCLIP weights
bash scripts/adapt.sh 0 eurosat SGD_lr1e-1_B256_ep300 4 ZS l2 ViT-B/32

bash scripts/adapt.sh 0 oxford_flowers SGD_lr1e-1_B256_ep300 8 ZS l2 ViT-B/32

bash scripts/adapt.sh 0 oxford_flowers SGD_lr1e-1_B256_ep300 8 ZS l2 ViT-B/16

bash scripts/adapt.sh 0 semi-aves SGD_lr1e-1_B256_ep300 8 ZS l2 ViT-B/16
```
