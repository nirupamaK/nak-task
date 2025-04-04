FROM nvidia/cuda:11.7.1-base-ubuntu20.04

ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
    libsndfile1 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    unzip \
    && apt-get clean

RUN python3 -m pip install --upgrade pip

RUN pip3 install torch==1.13.1+cu117 torchvision==0.14.1+cu117 torchaudio==0.13.1+cu117 -f https://download.pytorch.org/whl/torch_stable.html

RUN pip3 install transformers datasets accelerate

RUN pip3 install numpy pandas scikit-learn

WORKDIR /app

COPY train.py /app

RUN pip3 install --upgrade pip && \
    pip3 install notebook

EXPOSE 8900

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8900", "--no-browser", "--allow-root"]