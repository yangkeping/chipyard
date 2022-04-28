### This is a full chipyard setup

# BUILD BASE FOR CI

FROM continuumio/miniconda3 as base
ARG CHIPYARD_HASH

MAINTAINER https://groups.google.com/forum/#!forum/chipyard

WORKDIR /root

# Install Chipyard and run ubuntu-req.sh to install necessary dependencies
RUN git clone https://github.com/ucb-bar/chipyard.git && \
        cd chipyard && \
        git checkout $CHIPYARD_HASH

# Update PATH for RISCV toolchain (note: hardcoded for CircleCI)
ENV RISCV="/root/riscv-tools-install"
ENV LD_LIBRARY_PATH="$RISCV/lib"
ENV PATH="$RISCV/bin:$PATH"

# BUILD IMAGE WITH TOOLCHAINS

# Use above build as base
FROM base as base-with-tools

RUN conda env create -f ./chipyard/scripts/conda-requirements.yaml

SHELL ["conda", "run", "-n", "env", "/bin/bash", "-c"]

# Init submodules
RUN cd chipyard && \
        export MAKEFLAGS=-"j $(nproc)" && \
        ./scripts/init-submodules-no-riscv-tools.sh 1>/dev/null

# Install riscv-tools
RUN cd chipyard && \
        export MAKEFLAGS=-"j $(nproc)" && \
        ./scripts/build-toolchains.sh riscv-tools 1>/dev/null

# Install esp-tools
RUN cd chipyard && \
        export MAKEFLAGS=-"j $(nproc)" && \
        ./scripts/build-toolchains.sh esp-tools 1>/dev/null


# Set up FireMarshal. Building and cleaning br-base.json builds the underlying
# buildroot image (which takes a long time) but doesn't keep all the br-base
# stuff around (since that's faster to rebuild).
RUN cd chipyard && \
        source env.sh && \
        cd software/firemarshal && \
        ./init-submodules.sh && \
        pip3 install -r python-requirements.txt && \
        marshal build br-base.json && \
        marshal clean br-base.json

# Run script to set environment variables on entry
ENTRYPOINT ["chipyard/scripts/entrypoint.sh"]

# END IMAGE CUSTOMIZATIONS

CMD ["/bin/sh"]
