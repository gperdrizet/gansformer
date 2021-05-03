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
wget https://developer.nvidia.com/cuda-10.0-download-archive?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=1804&target_type=deblocal
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
with CUDA and CuDNN would have been unnec unnecessary.

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