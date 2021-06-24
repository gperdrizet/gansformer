## Setup notes
1. Fresh conda env with python 3.7:
```
conda create --name GAT python=3.7
conda activate GAT
```
2. Install packages from requirements.txt
```
pip install -r requirements.txt
```

3. Install CUDA 10.0:
```
wget https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64
sudo dpkg -i cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64.deb
sudo apt-key add /var/cuda-repo-10-0-local-10.0.130-410.48/7fa2af80.pub
sudo apt update
sudo apt install cuda-10-0
```

4. Use CUDA 10.0 if other versions present (**note**: stick this in a text file somewhere 
and source it for easy switching between versions if needed):
```
export PATH=$PATH:/usr/local/cuda-10.0/bin
export CUDADIR=/usr/local/cuda-10.0
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-10.0/lib64
```

5. Get and install CuDNN 7.5 for CUDA 10.0 from NVIDIA developer site (code samples optional):
```
wget https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v7.5.0.56/prod/10.0_20190219/Ubuntu18_04-x64/libcudnn7_7.5.0.56-1%2Bcuda10.0_amd64.deb
wget https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v7.5.0.56/prod/10.0_20190219/Ubuntu18_04-x64/libcudnn7-dev_7.5.0.56-1%2Bcuda10.0_amd64.deb
wget https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v7.5.0.56/prod/10.0_20190219/Ubuntu18_04-x64/libcudnn7-doc_7.5.0.56-1%2Bcuda10.0_amd64.deb
```
```
sudo dpkg -i libcudnn7_7.5.0.56-1+cuda10.0_amd64.deb
sudo dpkg -i libcudnn7-dev_7.5.0.56–1+cuda10.0_amd64.deb
sudo dpkg -i libcudnn7-doc_7.5.0.56-1+cuda10.0_amd64.deb
```
Actualy, NVM - importing tensorflow gives Illegal Instruction. Can't be completely sure the problem
was not just order of operations - maybe we just should have dealt with CUDA and CuDNN before
making the conda env. Or maybe if we had used conda to install tensorflow the mucking around
with CUDA and CuDNN would have been unnecessary. Either way seems to have worked...

1. Remade conda env installing tensorflow-gpu ver 1.14.0 via conda:
```
conda create --name GAT tensorflow-gpu=1.14.0
conda activate GAT
```
2. Removed tensorflow from requierments.txt and install the rest of the packages:

```
pip install -r requirements.txt
```

3. Additonaly need scikit-image:
```
conda install scikit-image
```

4. Test with generate.py:
```
python generate.py --gpus 0 --model gdrive:bedrooms-snapshot.pkl --output-dir images --images-num 32
```
## Works!

# Revisit (2021-06-4)
Above instructions no longer working/dident work on another machine. Ended up doing a full purge of CUDA, CuDNN and my Nvidia driver for a full reinstall. Target config is Nvidia driver 410, CUDA 10.0 and CuDNN 7.5. See support matrix on Nvidia's website [here](https://docs.nvidia.com/deeplearning/cudnn/support-matrix/index.html).

This approach appeared to lead into dependency hell. Going to try with a totaly vanella install via the Ubuntu package manager and see if that works. If not, I will try to add CUDA 10 and CuDNN 7.5 on top of it, one at a time.


1. Install Nvidia drivers. Let's see what Ubuntu recognizes and reccomends:

```
sudo ubuntu-drivers devices
```
```
WARNING:root:_pkg_get_support nvidia-driver-390: package has invalid Support Legacyheader, cannot determine support level
== /sys/devices/pci0000:00/0000:00:02.0/0000:03:00.0/0000:04:10.0/0000:06:00.0 ==
modalias : pci:v000010DEd0000102Dsv000010DEsd0000106Cbc03sc02i00
vendor   : NVIDIA Corporation
model    : GK210GL [Tesla K80]
driver   : nvidia-driver-418-server - distro non-free
driver   : nvidia-driver-450-server - distro non-free
driver   : nvidia-driver-460-server - distro non-free
driver   : nvidia-driver-390 - distro non-free
driver   : nvidia-driver-450 - third-party non-free
driver   : nvidia-driver-418 - third-party non-free
driver   : nvidia-driver-455 - third-party non-free
driver   : nvidia-driver-465 - third-party non-free recommended
driver   : nvidia-driver-460 - third-party non-free
driver   : xserver-xorg-video-nouveau - distro free builtin
```

Looks like the GPUs are correctly recognized, though that warning
is a bit sus - let's ignore it for now. We are not interested in the 
390 driver anyways. Let's go with the defaults:
```
sudo ubuntu-drivers autoinstall
```

2. Remade conda env installing tensorflow-gpu ver 1.14.0 via conda:
```
conda create --name GAT tensorflow-gpu=1.14.0
conda activate GAT
```
3. Removed tensorflow from requierments.txt and install the rest of the packages:

```
pip install -r requirements.txt
```

4. Additonaly need scikit-image:
```
conda install scikit-image
```

5. Test with generate.py:
```
python generate.py --gpus '0,1' --model gdrive:bedrooms-snapshot.pkl --output-dir images --images-num 32
```

Still no luck. This time going to try installing the 418-server driver via apt after having fixed some issues left over from earlier failed instalations.

Note: 418-server comes down with CUDA 10.1 attached.

Rebuilt conda env after driver install and tested with:
```
python generate.py --gpus '0,1' --model gdrive:bedrooms-snapshot.pkl --output-dir images --images-num 32
```

Still fails with:
```
Internal: cudaErrorNoKernelImageForDevice
```
No big surprise there, next let't install and use CUDA 10.0
```
wget https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64
sudo dpkg -i cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64.deb
sudo apt-key add /var/cuda-repo-10-0-local-10.0.130-410.48/7fa2af80.pub
sudo apt update
sudo apt install cuda-10-0
```

Still no, fails due to unmet dependencies. After following the chain backwards a few packages, it looks like we need driver 410 like I orignaly thought.

New plan wipe clean -> install 410 via pacage manager.

Nope - still unsatisfiable dependencies and or a missmatched gcc version. Going back to the orignal plan... install the driver via ubuntu-drivers devices and put the rest of the stuff on top of it.

Fails as well, ubuntu drivers chooses 460 and then CUDA 10 will not install. Agh.

So the working setup on Kakistocrat is a GTX1070, 465.27 driver, CUDA 11.3 as reported by nvidia-smi and CUDA compilation tools, release 9.1, V9.1.85 as reported by nvcc --version.

Let's try and replicate that.

1. Purge
```
sudo apt remove --purge nvidia*
sudo apt remove --purge cuda*
sudo apt remove --purge *cuda*
sudo apt autoremove
sudo reboot
```
Then check /etc/apt/sources.list for any wayward repos (nvidia developer or local etc). Then:
```
sudo apt update
sudo apt upgrade
sudo apt install nvidia-driver-465
sudo apt reboot
```
Check results with 'nvidia-smi', reports driver 465.27 & CUDA 11.3. 'nvcc --version' gives command not found. The README says the original repo was compiled with version 7.5 CUDA compilation tools but Kakistocrat is running on version 9.1. Let's install it with apt and see which version we get.
```
sudo apt install nvidia-cuda-toolkit
```
Fails due to unmet dependencies - problem with cublas version. And test fails. Tried installing CuDNN as before:
```
```
sudo dpkg -i libcudnn7_7.5.0.56-1+cuda10.0_amd64.deb
sudo dpkg -i libcudnn7-dev_7.5.0.56–1+cuda10.0_amd64.deb
sudo dpkg -i libcudnn7-doc_7.5.0.56-1+cuda10.0_amd64.deb
sudo apt update
sudo apt upgrade
```