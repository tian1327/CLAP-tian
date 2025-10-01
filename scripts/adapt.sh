#!/bin/bash

# custom config
DATA=/scratch/user/ltmask/CLAP/data/
TRAINER=ADAPTER

DEVICE=$1
DATASET=$2      # target dataset - i.e. {imagenet, caltech101, oxford_pets, stanford_cars, oxford_flowers, food101,
                #                        fgvc_aircraft, sun397, dtd, eurosat, ucf101}
CFG=$3          # config file - SGD_lr1e-1_B256_ep300
SHOTS=$4        # number of shots (1, 2, 4, 8, 16)
INIT=$5         # Method / Linear Probe init - i.e. {RANDOM, ZS, ClipA, TipA, TipA(f), TR, TRenh}
CONSTRAINT=$6   # apply class-adaptive constraint in Linear Probing (CLAP) - i.e. {none, l2}
BACKBONE=$7     # CLIP backbone to sue - i.e. {RN50, RN101, ViT-B/32, ViT-B/16}

# Remove slashes from BACKBONE variable
BACKBONE_CLEAN=$(echo $BACKBONE | sed 's/\///g')

# make a results directory to store the final accuracy results
if [ ! -d "./results" ]; then
    mkdir ./results
fi

# for SEED in 1
for SEED in 1 2 3
do
    echo "Running seed ${SEED}"
    DIR=output_${BACKBONE_CLEAN}/${DATASET}/${CFG}_${INIT}Init_${CONSTRAINT}Constraint_${SHOTS}shots/seed${SEED}
    if [ -d "$DIR" ]; then
        # echo "Oops! The results exist at ${DIR} (so skip this job)"
        # remove the existing directory and re-run
        # echo "The results exist at ${DIR}, but we remove it and re-run"        
        rm -rf $DIR
    fi
    if [ ! -d "$DIR" ]; then
        mkdir -p $DIR
        CUDA_VISIBLE_DEVICES=${DEVICE} python -W ignore train.py \
        --root ${DATA} \
        --seed ${SEED} \
        --trainer ${TRAINER} \
        --dataset-config-file configs/datasets/${DATASET}.yaml \
        --config-file configs/trainers/${CFG}.yaml \
        --output-dir ${DIR} \
        --backbone ${BACKBONE} \
        DATASET.NUM_SHOTS ${SHOTS} \
        TRAINER.ADAPTER.INIT ${INIT} \
        TRAINER.ADAPTER.CONSTRAINT ${CONSTRAINT}  > temp_output.txt && tail -n 1 temp_output.txt > ./results/CLAP_${DATASET}.txt && rm temp_output.txt
    fi
done