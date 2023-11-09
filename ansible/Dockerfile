##
## Common Base Image
##

FROM python:3.12.0-slim-bookworm AS base

COPY packages-base.txt /
RUN DEBIAN_FRONTEND=noninteractive\
 && apt-get update \
 && apt-get install -y --no-install-recommends \
      $(cat /packages-base.txt | sed "s|^\(.*\)#.*$|\1|g" | xargs) \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm /packages-base.txt

##
## Build Python Packages
##

FROM base AS builder

ARG ANSIBLE_VERSION=8.6.0
ENV ANSIBLE_VERSION ${ANSIBLE_VERSION}

COPY packages-builder.txt /
RUN DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
      $(cat /packages-builder.txt | sed "s|^\(.*\)#.*$|\1|g" | xargs)

COPY requirements.txt /
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /wheels -r /requirements.txt

##
## Final Image
##

FROM base AS final

COPY --from=builder /wheels /wheels
RUN pip install --no-cache /wheels/* \
 && rm -rf /wheels

RUN MITOGEN_PATH=$(python -c "import sysconfig; print(sysconfig.get_path('purelib'))")/ansible_mitogen \
 && sed -i 's|ANSIBLE_VERSION_MAX = (2, 13)|ANSIBLE_VERSION_MAX = (2, 19)|g' ${MITOGEN_PATH}/loaders.py \
 && rm ${MITOGEN_PATH}/__pycache__/loaders*.pyc
