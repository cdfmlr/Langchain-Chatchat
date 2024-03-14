# Customizing Guide

## Build

This branch added a Dockerfile that just works.

```sh
docker build -t langchain-chatchat:customize.6 .
```

## Run

Docker compose:

```yaml
version: '3'

services:
  LangchainChatchat:
    image: langchain-chatchat:customize.6
    ports:
      - "127.0.0.1:8501:8501"
      - "127.0.0.1:7861:7861"
      - "127.0.0.1:20000:20000"
    volumes:
      - /var/LangchainChatchat/configs:/app/configs
      - /var/LangchainChatchat/logs:/app/logs
      - /var/LangchainChatchat/knowledge_base:/app/knowledge_base
      - /var/LangchainChatchat/model:/model
    deploy:
      resources:
        reservations:
          devices:
          - driver: nvidia
            device_ids: ['0', '1']
            capabilities: [gpu]
```

## Config

This branch added a `configs/customize_config.py`:

```sh
cp configs/customize_config.py.example configs/customize_config.py

vi configs/customize_config.py
# to customize app name, logos, and model aliases for display.
```

Also notice to import it from `configs/__init__.py`:

```sh
# configs/__init__.py

from .customize_config import *
```

