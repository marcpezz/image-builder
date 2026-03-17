FROM quay.io/uninuvola/base:main

# DO NOT EDIT USER VALUE
USER root

## -- ADD YOUR CODE HERE !! -- ##
## 1. -- UniNuvola conda
ENV PATH="/opt/conda/bin:${PATH}"
ENV JUPYTER_PATH="/usr/local/share/jupyter/kernels"

RUN echo "/opt/conda/bin/conda init > /dev/null " >> /etc/profile.d/conda.sh && \
    echo "exec /bin/bash" >> /etc/profile

## 2. -- Pytorch GPU 

# install CuDA-toolkit
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb && \
    dpkg -i cuda-keyring_1.1-1_all.deb && apt update && apt install -y cuda-toolkit

RUN conda create -n pytorchgpu pytorch torchvision torchaudio pytorch-cuda=12.4 python=3.11.5 -c pytorch -c nvidia && \
    conda init && \
    /opt/conda/bin/conda shell.bash activate pytorchgpu && \
    /opt/conda/envs/pytorchgpu/bin/pip install ipykernel pandas scikit-learn scipy seaborn matplotlib && \
    /opt/conda/envs/pytorchgpu/bin/pip install gymnasium pygame && \
    /opt/conda/envs/pytorchgpu/bin/python -m ipykernel install --name  pytorchgpu --display-name pytorchgpu && \
    /opt/conda/bin/conda shell.bash deactivate


WORKDIR /app
RUN apt update && apt install -y fuse libfuse2 && \
    wget https://github.com/Syllo/nvtop/releases/download/3.1.0/nvtop-x86_64.AppImage && \
    chmod u+x  nvtop-x86_64.AppImage  && ./nvtop-x86_64.AppImage --appimage-extract && \
    ln  /app/squashfs-root/usr/bin/nvtop /usr/local/bin/. &&\
    cp  /app/squashfs-root/usr/lib/*  /usr/local/lib/. &&\
    chmod 755 /usr/local/bin/nvtop

RUN echo "/opt/conda/bin/conda init > /dev/null " >> /etc/profile.d/conda.sh && \
    echo "export PATH=\"$PATH:/usr/local/cuda-13.0/bin\" " >> /etc/profile.d/cudatoolkit.sh && \
    echo "exec /bin/bash" >> /etc/profile

#WORKDIR /home/jovyan
## -- TODO: update the image 

## --------------------------- ##

# DO NOT EDIT USER VALUE
USER jovyan
