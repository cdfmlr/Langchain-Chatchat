FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

# fix inotify
RUN echo fs.inotify.max_user_watches=524288 >> /etc/sysctl.conf && \
    echo fs.inotify.max_user_instances=8192 >> /etc/sysctl.conf && \
    sysctl -p

# mkdir
RUN mkdir /model /app

# apt-get
RUN apt-get update && apt-get install -y \
    python3.11 \
    python3-pip \
    python3-dev \
    git \
    wget \
    curl \
    vim \
    libglib2.0-0 libgl1-mesa-glx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# requirements
COPY requirements.txt /app/requirements.txt
COPY requirements_api.txt /app/requirements_api.txt
COPY requirements_webui.txt /app/requirements_webui.txt

# pip
RUN pip3 install --upgrade pip && \
    pip3 install -r /app/requirements.txt && \
    pip3 install -r /app/requirements_api.txt && \
    pip3 install -r /app/requirements_webui.txt && \
    pip3 install --upgrade transformers==4.38.2
# upgrade transformers to 4.38.2 to support Qwen2


# src
COPY . /app

# workdir
WORKDIR /app

# ports
# 8501: webui, 7861: api, 20000: openai_api
EXPOSE 8501
EXPOSE 7861
EXPOSE 20000

# volume
VOLUME /model
VOLUME /app/configs
VOLUME /app/logs
VOLUME /app/knowledge_base

# run
CMD ["python3", "startup.py", "-a"]
