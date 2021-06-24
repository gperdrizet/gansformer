#!/bin/bash

# Test training run command (GTX1070 8GB)
python run_network.py --train --gpus 0 --gansformer-default --expname graffiti_all.2 --dataset graffiti_all --eval-images-num 5000 --batch-size 32 --minibatch-size 4 --mirror-augment --g-lr 0.0002 --d-lr 0.0002