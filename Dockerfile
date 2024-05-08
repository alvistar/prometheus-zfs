FROM ubuntu:noble

WORKDIR /usr/src

RUN apt-get update && \
    apt-get install --yes --no-install-recommends build-essential git python3 python3-dev libzfslinux-dev python3.12-venv

RUN python3 -m venv /tmp/venv

RUN /tmp/venv/bin/pip install setuptools prometheus_client cython==0.29.37

RUN git clone --branch TS-24.04.0 https://github.com/truenas/py-libzfs.git /tmp/py-libzfs

ENV PATH="/tmp/venv/bin:$PATH"

RUN cd /tmp/py-libzfs && \
    ./configure --prefix=/usr && \
    make build && \
    python3 setup.py install

RUN apt-get remove --yes build-essential git python3-dev python3-pip libzfslinux-dev && rm -rf /var/lib/apt/lists/*

ADD zfsprom.py .

EXPOSE 9901
ENTRYPOINT "python3 zfsprom.py"
