ARG BASE_IMAGE=debian:11.2@sha256:2906804d2a64e8a13a434a1a127fe3f6a28bf7cf3696be4223b06276f32f1f2d
FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2022-01-25

LABEL Name="senzing/test-layers" \
  Maintainer="support@senzing.com" \
  Version="1.0.0"

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Run as "root" for system installation.

USER root

# Install packages via apt-get.

RUN apt-get update
RUN apt-get -y install software-properties-common
RUN apt-get -y install wget
RUN apt-get -y install python3-pip

# Install packages via PIP.

RUN pip3 install --upgrade pip
RUN pip3 install boto3==1.18.36

# Install Java-11.

RUN mkdir -p /etc/apt/keyrings \
  && wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public > /etc/apt/keyrings/adoptium.asc

RUN echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" >> /etc/apt/sources.list

# Install packages via apt-get.

RUN apt-get update \
  && apt-get install -y temurin-11-jdk \
  && rm -rf /var/lib/apt/lists/*

# Copy files from repository.

COPY ./rootfs /

# Make non-root container.

USER 1001

# Runtime execution.

WORKDIR /app
CMD ["/app/sleep-infinity.sh"]
