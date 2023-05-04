FROM  ubuntu:22.04

ENV TZ Pacific/Auckland

RUN apt-get update
RUN apt-get install -y tzdata
RUN echo "Pacific/Auckland" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

RUN apt-get -y update &&\
    apt-get -y install \
    python3

RUN apt-get update && apt-get -y install python3-pip --upgrade

# Install GDAL
RUN apt-get update && \
		apt-get install -y gdal-bin libgdal-dev && \
    apt upgrade --yes && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR pycrown

ADD . ./

RUN pip install -r requirements.txt

RUN python3 setup.py install

RUN pip3 install Cython --upgrade --force-reinstall