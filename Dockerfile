# ベースイメージ
FROM python:3.8.12
# ubuntsu 標準

# メタ情報の追加
LABEL version="1.0" 
LABEL description="Python開発環境"  

# 環境変数の設定
ENV VAR Hello-World 
RUN echo ${VAR}  

# 作業ディレクトリの指定
WORKDIR /usr/src/app
RUN apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    git \
    libgl1-mesa-dev \
    libgl1-mesa-glx \
    libglew-dev \
    libosmesa6-dev \
    software-properties-common \
    net-tools \
    vim \
    virtualenv \
    wget \
    xpra \
    xserver-xorg-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /root/.mujoco \
    && wget https://mujoco.org/download/mujoco210-linux-x86_64.tar.gz -O mujoco.tar.gz \
    && tar -xf mujoco.tar.gz -C /root/.mujoco \
    && rm mujoco.tar.gz

ENV LD_LIBRARY_PATH /root/.mujoco/mujoco210/bin:${LD_LIBRARY_PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib64:${LD_LIBRARY_PATH}


# アプリのインストール
#COPY requirements.txt . 
RUN pip install --upgrade pip
RUN pip install torch==1.9.0
RUN pip install tensorboard==2.6.0
RUN pip install packaging==21.3
#RUN pip install mujoco-py==2.0.2.8
RUN pip install gym
RUN pip install "cython<3"
RUN pip install mujoco
RUN pip install protobuf==3.20.0
RUN pip install numpy==1.21.3


RUN apt-get update && apt-get -y install vim


COPY main.py .
COPY model.py .
COPY play.py .
COPY running_mean_std.py .
COPY test.py .
COPY train.py .
COPY agent.py .
COPY Ant_weights.pth .





