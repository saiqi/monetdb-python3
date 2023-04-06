FROM ubuntu:22.04

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y gnupg ca-certificates locales

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ARG MONETDB_VERSION=11.45.13
ENV MONETDB_VERSION $MONETDB_VERSION

COPY ./apt/monetdb.list /etc/apt/sources.list.d/
COPY ./apt/MonetDB-GPG-KEY.gpg /
RUN apt-key add /MonetDB-GPG-KEY.gpg
RUN apt-get update
RUN apt-get install -y monetdb5-sql="$MONETDB_VERSION" monetdb-client monetdb-python3 python3-pip
RUN pip3 install pandas scikit-learn

COPY scripts/entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 50000

CMD [ "entrypoint.sh" ]

STOPSIGNAL SIGINT
