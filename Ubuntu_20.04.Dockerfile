FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu20.04 AS base_image

# setup bashrc
RUN cp /etc/skel/.bashrc ~/

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update
RUN apt-get install -y \
  lsb-release \
  sudo \
  gnupg2 \
  wget \
  curl \
  git \
  vim

# setup timezone
RUN echo 'Etc/UTC' > /etc/timezone && \
  ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

RUN apt-get install -y \
  python3.9 \
  python3-distutils \
  python3.9-dev \
  libgl1 \
  libglib2.0-0

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1

RUN curl -s https://bootstrap.pypa.io/get-pip.py | python

RUN pip install jupyterlab numpy==1.23.5 matplotlib openmim

RUN pip install torch==1.9.0+cu111 torchvision==0.10.0+cu111 torchaudio==0.9.0 -f https://download.pytorch.org/whl/torch_stable.html

RUN pip install flash-attn==0.2.2

RUN mim install mmcv-full==1.6.0 mmdet==2.28.2 mmdet3d==1.0.0rc6 mmsegmentation==0.30.0

RUN pip install -U networkx>=2.5

RUN apt-get clean autoclean
RUN apt-get autoremove --yes
RUN rm -rf /var/lib/{apt,dpkg,cache,log}/
RUN rm -Rf /root/.cache/pip

CMD ["bash"]
