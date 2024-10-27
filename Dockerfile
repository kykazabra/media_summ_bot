FROM ubuntu:latest as build

RUN apt-get update && apt-get install -y \
    unzip \
    wget

RUN cd /usr/local/bin/ && \
    wget -O telegram-bot-api.zip https://alexell.ru/download/1663/?tmstv=1729867741 && \
    unzip telegram-bot-api.zip

FROM tverous/pytorch-notebook

ARG source="/usr/local/bin/telegram-bot-api/Ubuntu 22.04 (x86-64)/telegram-bot-api"
ARG target="/usr/local/bin/telegram-bot-api"

COPY --from=build ${source} ${target}

RUN chmod 777 ${target}

RUN apt-get update && apt-get install -y  \
    ffmpeg \
    libssl-dev \
    libc++-14-dev

RUN pip install \
    transformers \
    ffmpeg \
    pytelegrambotapi \
    langchain \
    langchain-openai \
    pydub \
    protobuf \
    langchain-huggingface \
    ipywidgets

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--no-browser"]

CMD ["/usr/local/bin/telegram-bot-api", "--local"]
