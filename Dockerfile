ARG BASE_IMAGE=debian:11.2@sha256:2906804d2a64e8a13a434a1a127fe3f6a28bf7cf3696be4223b06276f32f1f2d
FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2022-01-25

LABEL Name="senzing/test-layers" \
      Maintainer="support@senzing.com" \
      Version="1.0.0"

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Run as "root" for system installation.

USER root

# Install packages via apt.

RUN apt update
RUN apt -y install software-properties-common
RUN apt -y install wget
RUN apt -y install python3-pip

# Install packages via PIP.

RUN pip3 install --upgrade pip
RUN pip3 install boto3==1.18.36

# Install Java.

RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
RUN add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
RUN apt update
RUN apt install -y adoptopenjdk-11-hotspot

# Install packages via apt.

# Copy files from repository.

COPY ./rootfs /

# Make non-root container.

USER 1001

# Runtime execution.

WORKDIR /app
CMD ["/app/sleep-infinity.sh"]
