import sys
from pathlib import Path
from PIL import Image

input_image_path = './images/avopix/'
output_image_path = './images/avopix_mirrored_1024/'
image_dim = 1024

image_list = Path(input_image_path).rglob('*.jpg')

# Force all images to 1024x1024 and created mirrored version
image_count = 0

for image in image_list:
    # try:
    # open
    img = Image.open(image).convert('RGB')

    # scale
    img = img.resize((image_dim, image_dim))

    # save
    destination = f'{output_image_path}/{image_count:06}.jpg'
    img.save(destination)
    image_count += 1
    print(f'Image: {image_count}')

    # flip
    img = img.transpose(Image.FLIP_LEFT_RIGHT)
    
    # save
    destination = f'{output_image_path}/{image_count:06}.jpg'
    img.save(destination)
    image_count += 1
    print(f'Image: {image_count}')

    # except KeyboardInterrupt:
    #     # quit
    #     sys.exit()

    # except:
    #     print('Could not process image.')