FROM nvidia/cuda:10.1-cudnn8-runtime-ubuntu18.04
ENV CMAKE_FILE=cmake-3.15.7-Linux-x86_64.sh \
    CONDA_FILE=Miniconda3-py38_4.10.3-Linux-x86_64.sh \
    PATH=/root/miniconda3/bin:/usr/local/cmake/bin:$PATH
ARG build=/home/wenet/runtime/server/x86/build
RUN rm /bin/sh && ln -s /bin/bash /bin/sh && \
    apt-get update && apt-get install --no-install-recommends -y git cmake wget build-essential vim libmad0-dev sox libsox-dev gdb bzip2 unzip &&\
    cd /root && wget https://repo.anaconda.com/miniconda/$CONDA_FILE && sed -i '59d' $CONDA_FILE && sed -i '59i BATCH=1' $CONDA_FILE && \
    sh $CONDA_FILE && > /root/$CONDA_FILE && rm -rf /root/$CONDA_FILE && \
    echo "export PATH=/root/miniconda3/bin:\$PATH" >> /root/.bashrc  && \
    wget https://cmake.org/files/v3.15/$CMAKE_FILE && mkdir -p /usr/local/cmake && \
    sh  $CMAKE_FILE --prefix=/usr/local/cmake --skip-license && > $CMAKE_FILE && rm -rf $CMAKE_FILE && \
    echo "export PATH=/usr/local/cmake/bin:\$PATH" >> /root/.bashrc && \
    git clone https://github.com/wenet-e2e/wenet.git /home/wenet && \
    cd /home/wenet && pip install -r requirements.txt && conda install pytorch==1.6.0 cudatoolkit=10.1 torchaudio=0.6.0 -c pytorch && conda install -y ipython && \
    mkdir $build && cd $build && cmake .. && cmake --build . && \
    apt-get clean
WORKDIR  /home/
CMD ["/bin/bash"]
