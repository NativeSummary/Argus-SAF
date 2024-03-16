ARG UBUNTU_MIRROR=mirrors.tuna.tsinghua.edu.cn

FROM ubuntu:18.04
ARG UBUNTU_MIRROR

SHELL ["/bin/bash", "-c"]

RUN sed -i "s/archive.ubuntu.com/${UBUNTU_MIRROR}/g" /etc/apt/sources.list \
 && sed -i "s/security.ubuntu.com/${UBUNTU_MIRROR}/g" /etc/apt/sources.list \
 && apt update && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends curl time git wget sudo unzip software-properties-common nano openjdk-17-jdk-headless python2.7 protobuf-compiler \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ["timeout.sh", "/root/Argus-SAF/"]
COPY ["runTool.sh", "/root/Argus-SAF/"]
COPY ["nativedroid", "/root/Argus-SAF/nativedroid"]
COPY ["tools", "/root/Argus-SAF/tools"]
# build before create image
COPY ["target/scala-2.12/argus-saf-3.2.1-SNAPSHOT-assembly.jar", "/root/Argus-SAF/"]
COPY [".amandroid_stash", "/root/.amandroid_stash"]

WORKDIR /root
SHELL ["/bin/bash", "-c"]
# Python env
RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py \
 && python2.7 get-pip.py \
 && python2.7 -m pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple \
 && python2.7 -m pip install virtualenvwrapper \
 && echo export VIRTUALENVWRAPPER_PYTHON=python2.7 >> /root/.bashrc \
 && echo export WORKON_HOME=~/.py2venvs >> /root/.bashrc \
 && echo source /usr/local/bin/virtualenvwrapper.sh >> /root/.bashrc \
 && export VIRTUALENVWRAPPER_PYTHON=python2.7 \
 && export WORKON_HOME=~/.py2venvs \
 && source /usr/local/bin/virtualenvwrapper.sh \
 && mkvirtualenv --system-site-packages nativedroid \
 && python -m pip install -r ./Argus-SAF/nativedroid/requirements.txt \
 && cd Argus-SAF/ \
 && tools/scripts/install.sh nativedroid \
 && rm -rf /tmp/* /var/tmp/*

WORKDIR /root/Argus-SAF

ENTRYPOINT ["/bin/bash", "/root/Argus-SAF/timeout.sh"]
CMD ["/root/apps/app.apk"]
