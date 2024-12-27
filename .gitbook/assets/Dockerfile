
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt -y upgrade \
               && apt-get --no-install-recommends install -y wget \
               && apt-get --no-install-recommends install -y libpq5 \
               && apt-get --no-install-recommends install -y redis-server \
               && apt-get --no-install-recommends install -y nginx \
               && apt-get --no-install-recommends install -y vim \
               && apt-get --no-install-recommends install -y sudo \
               && apt-get --no-install-recommends install -y libmagic1 libmagic-dev \
               && apt-get --no-install-recommends install -y pipx \
               && apt-get --no-install-recommends install -y sudo \
               && apt-get --no-install-recommends install -y supervisor \
               && apt-get --no-install-recommends install -y postgresql \
               && apt-get clean \
               && rm -rf /var/lib/apt/lists/*

RUN service postgresql start
RUN redis-server &

RUN pipx ensurepath
RUN pipx install supervisor
RUN sudo service supervisor start

RUN wget https://packaging.ckan.org/python-ckan_2.11-jammy_amd64.deb
RUN dpkg -i python-ckan_2.11-jammy_amd64.deb

RUN sudo mkdir -p /var/lib/ckan/default
RUN sudo chown www-data /var/lib/ckan/default
RUN sudo chmod u+rwx /var/lib/ckan/default

RUN mkdir ckan
COPY ckan.ini /etc/ckan/default/ckan.ini
COPY aliases.sh aliases.sh
COPY startup.sh startup.sh
COPY setup.sh setup.sh
RUN . ./setup.sh

#RUN service postgresql start && \
#    PGPASSWORD="ckan" && \
#    echo $PGPASSWORD && \
#    sudo -u postgres createuser -S -D -R ckan_default && \
#    sudo -u postgres createdb -O ckan_default ckan_default -E utf-8 && \
#    sudo ckan db init && \
#    service postgresql stop

#RUN sudo service nginx restart
#
# do after logging in because not setup to auto-run on boot and not doable in Dockerfile..?!
#
#  startups:
#RUN service postgresql start
#RUN redis-server &
#RUN sudo service supervisor start
#RUN sudo service nginx restart
#  things not doable in Dockerfile:
#RUN sudo -u postgres psql --file=ckan/createuser.sql
#RUN sudo -u postgres createdb -O ckan_default ckan_default -E utf-8
#RUN sudo ckan db init


