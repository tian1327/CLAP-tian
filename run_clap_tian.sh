#!/bin/bash

datasets=(
    "semi-aves" \
    "species196_insecta"
    "species196_weeds"
    "species196_mollusca"
    "fungitastic-m"
    "fish-vista-m"
    # "oxford_flowers" \
    # "fgvc_aircraft" \
    # "eurosat" \
    # "dtd" \
    # "oxford_pets" \
    # "food101" \
    # "stanford_cars" \
    # "imagenet"
    )

shots=(16 8 4)

model_cfg="ViT-B/32"
# model_cfg="ViT-B/16"

for dataset in "${datasets[@]}"; do
    for shot in "${shots[@]}"; do
        echo "$dataset, shot $shot, model $model_cfg"
        bash scripts/adapt.sh 3 $dataset SGD_lr1e-1_B256_ep300 $shot ZS l2 $model_cfg
        echo ""        
    done
done