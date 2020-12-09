# Define base of the build
FROM ubuntu:latest

# Removes query requirements during package installs
ENV DEBIAN_FRONTEND noninteractive

# Add git to pull things from github
RUN apt-get -y update && apt-get install -y git

# Add wget requirements 
RUN apt-get -y update && apt-get install -y wget

# Add pip installer
RUN apt-get install -y software-properties-common
RUN apt-add-repository -y universe
RUN apt-get -yqq update
RUN apt-get install -yqq python3.4
RUN apt-get install -yqq python3-pip

# Add requirements
RUN python3 -m pip install -U pip setuptools
RUN python3 -m pip install -Iv scikit-learn
RUN python3 -m pip install -Iv six
RUN python3 -m pip install -Iv pybedtools
RUN python3 -m pip install -Iv numpy
RUN python3 -m pip install -Iv scipy
RUN python3 -m pip install -Iv pysam
RUN python3 -m pip install -Iv HTSeq

# Add minimap2
RUN apt-get install python3-pkg-resources
RUN apt-get install build-essential
RUN apt-get install zlib1g-dev

WORKDIR /usr/bin 
RUN git clone https://github.com/lh3/minimap2 
WORKDIR /usr/bin/minimap2 
RUN pwd
RUN git checkout v2.3
RUN make && chmod 755 minimap2 
ENV PATH $PATH:/usr/bin/minimap2

# Add NanoSim
WORKDIR /usr/bin
RUN git clone https://github.com/kennethbowden/nanosim.git
WORKDIR /usr/bin/nanosim
RUN chmod 770 -R /usr/bin/nanosim
ENV PATH $PATH:/usr/bin/nanosim

# Simulate python to python3
RUN ln -s /usr/bin/python3 /usr/bin/python
