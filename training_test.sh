#!/bin/bash

# Test training run command (GTX1070 8GB)
python run_network.py --train --gpus 0 --gansformer-default --expname clevr-scratch --dataset clevr --eval-images-num 5000 --batch-size 1 --minibatch-size 1