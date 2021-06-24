#!/bin/bash

# Test training run command (GTX1070 8GB)
python run_network.py --train --gpus 0 --gansformer-default --expname avopix --dataset avopix --eval-images-num 50000 --batch-size 1 --minibatch-size 1