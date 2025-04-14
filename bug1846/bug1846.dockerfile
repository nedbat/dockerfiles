FROM nedbat/base

USER root

RUN SUDO_FORCE_REMOVE=yes sudo -E apt-get remove -y sudo

USER me
WORKDIR /home/me

RUN git clone --depth=1 https://github.com/MillionConcepts/pdr
WORKDIR pdr

RUN python3.11 -m pip install pytest-cov
RUN python3.11 -m pip install -e '.[browsify,fits,pvl,tiff]'
