FROM python:3.7.2

#APT_GET

RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get -y update && \
    apt-get -y install graphviz libxml2-dev python3-cairosvg parallel
RUN apt-get -y install cmake
#install meshlab and dependencies
RUN apt-get -y install xvfb
# CGAL Dependencies ########################################################
RUN apt-get -y install libboost-all-dev libgmp-dev libmpfr-dev libcgal-dev libboost-wave-dev
############################################################################
RUN apt-get -y install vim
RUN apt-get -y install libassimp-dev
RUN apt-get -y install libspatialindex-dev

#CONDA
WORKDIR /conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-4.6.14-Linux-x86_64.sh --quiet -O miniconda.sh
#RUN echo "faa7cb0b0c8986ac3cacdbbd00fe4168  miniconda.sh" | md5sum --check
RUN bash miniconda.sh -b -up /conda
RUN rm miniconda.sh

# make sure conda bin is in front of PATH so we get correct pip
ENV PATH="/conda/bin:$PATH"

# create a conda env
RUN /conda/bin/conda config --set always_yes yes --set changeps1 no
RUN /conda/bin/conda create -q -n denv python=3.7

# make sure pip/conda is the latest
RUN pip install --upgrade pip
RUN /conda/bin/conda update -n base conda

# add conda-forge as remote channel
RUN /conda/bin/conda config --add channels conda-forge

# scikit-image is used for marching cubes
# pyembree is used for fast ray tests
RUN /conda/bin/conda install scikit-image pyembree

# actually install trimesh and pytest
RUN pip install trimesh[all] pytest pyassimp==4.1.3

# remove archives
RUN /conda/bin/conda clean --all -y

#PIP3
RUN pip install python-igraph xlrd
RUN pip install matplotlib
RUN pip install rtree
RUN pip install shapely
RUN pip install pymeshfix
RUN pip install ipyvolume jupyterlab statsmodels pycircstat nose
RUN pip install MeshParty



