FROM continuumio/miniconda3:4.10.3

### Install necessary packages and libraries

RUN apt-get update && \
    apt-get install -y \
    unzip \
    make \
    cmake \
    build-essential \
    git \
    vim \
    libblas3 \
    libblas-dev \
    liblapack3 \
    liblapack-dev \
    libatlas3-base \
    libatlas-base-dev \
    gfortran \
    gsl-bin \
    libgsl-dev \
    curl \
    libsm6 \
    libxext6 \
    libgl1-mesa-glx \
    libhwloc5 \
    librdmacm-dev \
    libosmcomp4 \
    libpsm2-2 \
    libfabric1 \
    libxi6 \
    libgconf-2-4 \
    texlive-latex-base \
    dvipng \
    texlive-fonts-recommended \
    texlive-fonts-extra

RUN wget http://ftp.us.debian.org/debian/pool/main/o/opensm/libosmcomp3_3.3.20-1_amd64.deb && \
    dpkg -i libosmcomp3_3.3.20-1_amd64.deb && \
    rm -rf libosmcomp3_3.3.20-1_amd64.deb


RUN wget http://ftp.us.debian.org/debian/pool/main/g/gcc-6/gcc-6-base_6.3.0-18+deb9u1_amd64.deb && \
    dpkg -i gcc-6-base_6.3.0-18+deb9u1_amd64.deb && \
    rm -rf gcc-6-base_6.3.0-18+deb9u1_amd64.deb && \
    wget http://ftp.us.debian.org/debian/pool/main/g/gcc-6/libgfortran3_6.3.0-18+deb9u1_amd64.deb && \
    dpkg -i libgfortran3_6.3.0-18+deb9u1_amd64.deb && \
    rm -rf libgfortran3_6.3.0-18+deb9u1_amd64.deb


### Install openmpi 1.10.6

COPY sugwg-openmpi-1.10.6.tar.gz sugwg-openmpi-1.10.6.tar.gz
RUN tar -C / -zxvf sugwg-openmpi-1.10.6.tar.gz && \
    echo "/usr/lib64/openmpi/lib" > /etc/ld.so.conf.d/sugwg-openmpi.conf && \
    ldconfig -v && \
    ldd /usr/lib64/openmpi/lib/libmpi.so

### Create the conda environment from .yml file 

RUN curl -L https://raw.githubusercontent.com/ThomasEdwardRiley/xpsi/v0.7.5/environment.yml > /tmp/environment.yml && \
    conda env create -f /tmp/environment.yml; exit 0 && \
    rm -f /tmp/environment.yml

SHELL [ "conda", "run", "-n", "xpsi", "/bin/bash", "-c"]
RUN conda list && \
    conda init && \
    echo 'conda activate xpsi' >> ~/.bashrc


### Install mpi4py 3.0.0 

COPY mpi.cfg /mpi.cfg
RUN mv /opt/conda/envs/xpsi/compiler_compat/ld /opt/conda/envs/xpsi/compiler_compat/ld.conda && \
    curl -L https://github.com/mpi4py/mpi4py/releases/download/3.0.0/mpi4py-3.0.0.tar.gz > /tmp/mpi4py-3.0.0.tar.gz && \
    tar -zxvf /tmp/mpi4py-3.0.0.tar.gz && \
    rm -f /mpi4py-3.0.0.tar.gz && \
    mv /mpi.cfg /mpi4py-3.0.0/mpi.cfg && \
    cd /mpi4py-3.0.0 && python setup.py build && \
    cd /mpi4py-3.0.0 && python setup.py install && \
    rm -rf mpi4py-3.0.0


### Install other dependencies for xpsi

RUN pip install GetDist==0.3.1 \
   nestcheck==0.2.0 \
   fgivenx

# RUN pip install pycbc==1.17.0

### Install MultiNest

RUN ldconfig &&\
    git clone https://github.com/farhanferoz/MultiNest.git /opt/multinest-a2b1b5feb5 && \
    cd /opt/multinest-a2b1b5feb5 && \
    git checkout a2b1b5feb5 && \
    cd /opt/multinest-a2b1b5feb5/MultiNest_v3.11_CMake/multinest/ && \
    mkdir build && \
    cd build && \
    CC=gcc FC=/usr/lib64/openmpi/bin/mpif90 CXX=g++ cmake -DCMAKE_{C,CXX}_FLAGS="-O3 -march=native -funroll-loops" -DCMAKE_Fortran_FLAGS="-O3 -march=native -funroll-loops" .. && \
    make
ENV LD_LIBRARY_PATH=/opt/multinest-a2b1b5feb5/MultiNest_v3.11_CMake/multinest/lib:$LD_LIBRARY_PATH

### Install PyMultiNest

RUN git clone https://github.com/JohannesBuchner/PyMultiNest.git &&\
    cd PyMultiNest/ && \
    python setup.py install

### Make xpsi user, switch to that user's directory
RUN useradd xpsi -m
WORKDIR /home/xpsi

RUN echo "export PATH=$PATH:/usr/lib64/openmpi/bin/" >> /home/xpsi/.profile
ENV PATH=/usr/lib64/openmpi/bin/:$PATH


### Clone and install xpsi
RUN git clone https://github.com/ThomasEdwardRiley/xpsi.git && \
    cd /home/xpsi/xpsi && \
    git checkout v0.1 && \
    CC=/usr/bin/gcc python setup.py install
 
### Get the giving file ownership to xpsi user

RUN wget https://zenodo.org/record/5506838/files/A_NICER_VIEW_OF_PSR_J0030p0451.tar.gz && \
    tar -xvf A_NICER_VIEW_OF_PSR_J0030p0451.tar.gz && \
    chmod -R ugo+rx A_NICER_VIEW_OF_PSR_J0030p0451/ && \
    rm -rf A_NICER_VIEW_OF_PSR_J0030p0451.tar.gz

### Install pycbc v1.18.3 for the post-processing and plotting
COPY requirements.txt /home/xpsi/
RUN wget https://github.com/gwastro/pycbc/archive/refs/tags/v1.18.3.tar.gz && \
    tar -xvf v1.18.3.tar.gz && \
    cd pycbc-1.18.3 && \
    pip install lscsoft-glue==1.59.3 && \
    mv /home/xpsi/requirements.txt . && \    
    pip install -r requirements.txt && \
    pip install .

RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> /home/xpsi/.bashrc && echo "conda activate xpsi" >> /home/xpsi/.bashrc && \
    mkdir /var/lib/condor && \
    mkdir -p /.singularity.d/env
COPY .singularity.d/env/00-xpsi.sh /.singularity.d/env/00-xpsi.sh
RUN chmod ugo+rx /.singularity.d /.singularity.d/env && \
    chmod ugo+r /.singularity.d/env/00-xpsi.sh

RUN ldconfig -v

USER xpsi