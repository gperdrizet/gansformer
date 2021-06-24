#!/bin/bash

python prepare_data.py --task graffiti_all --images-dir ~/arkk/rpm/image_scaler/images/graffiti/scaled_images_all/ --format jpg --ratio 1 --shards-num 5 --max-images 88741
