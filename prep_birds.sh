#!/bin/bash

python prepare_data.py --task birds --images-dir raw_images/birds_images_mirrored_1024/all/ --format jpg --ratio 0.7 --shards-num 5 --max-images 156836