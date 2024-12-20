FROM nvidia/cuda:12.1.0-runtime-ubuntu22.04

# Install system dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    python3.10 \
    python3.10-dev \
    python3-pip \
    ffmpeg \
    curl \
    git \
    openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    ln -sf /usr/bin/python3 /usr/bin/python

# Install Python dependencies
RUN pip3 install --no-cache-dir \
    torch \
    torchvision \
    torchaudio \
    torchsde \
    einops \
    transformers>=4.28.1 \
    tokenizers>=0.13.3 \
    sentencepiece \
    safetensors>=0.3.0 \
    aiohttp \
    accelerate \
    pyyaml \
    Pillow \
    scipy \
    tqdm \
    psutil \
    spandrel \
    soundfile \
    kornia>=0.7.1 \
    websocket-client==1.6.3 \
    albumentations==1.4.3 \
    numpy>=1.26.4 \
    opencv-python-headless \
    imageio-ffmpeg>=0.5.1 \
    lmdb>=1.4.1 \
    rich>=13.7.1 \
    ultralytics \
    tyro==0.8.5 \
    dill \
    cog \
    runpod

# Install pget
RUN curl -o /usr/local/bin/pget -L "https://github.com/replicate/pget/releases/download/v0.8.1/pget_linux_x86_64" && \
    chmod +x /usr/local/bin/pget

RUN mkdir -p /app
# Copy application code
COPY . /app/

WORKDIR /app

# Install ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git && \
    cd ComfyUI && git checkout 9f4b181
# Install custom nodes
RUN mkdir -p ComfyUI/custom_nodes && \
    cd ComfyUI/custom_nodes && \
    git clone --recursive https://github.com/kyzyx/ComfyUI-AdvancedLivePortrait && \
    cd ComfyUI-AdvancedLivePortrait && \
    git checkout 5a28a77 && \
    git submodule update --init --recursive

# Copy handler
COPY handler.py /rp_handler.py

# Set the entrypoint
CMD ["python3", "-u", "/rp_handler.py"]
