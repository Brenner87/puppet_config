FROM centos:7
ARG puppet_conf=/etc/puppetlabs/puppet
ARG keys_path=./
ENV PUPPET_BIN=/opt/puppetlabs/puppet/bin
#RUN yum -y update && \
RUN yum -y install git && \
    rpm -Uvh https://yum.puppetlabs.com/puppet5/puppet5-release-el-7.noarch.rpm && \
    yum -y install puppetserver && \
    yum clean all
WORKDIR $puppet_conf
COPY . $puppet_conf
COPY $keys_path $puppet_conf/keys
COPY logback.xml ../puppetserver/
COPY request-logging.xml ../puppetserver/
RUN mv ./puppetserver /etc/sysconfig/puppetserver && \
    $PUPPET_BIN/puppet cert list -a && \
    mkdir  /etc/puppetlabs/r10k && \
    $PUPPET_BIN/gem install --no-rdoc --no-ri r10k && \
    mv ./r10k.yaml /etc/puppetlabs/r10k/r10k.yaml && \
    rm -rf /etc/puppetlabs/code/environments/* && \
    chown puppet:puppet /etc/puppetlabs/puppet/keys/* && \
    chown puppet:puppet ./master-entrypoint.sh && \
    chmod 711 ./master-entrypoint.sh
EXPOSE 8140
ENTRYPOINT ["./master-entrypoint.sh", "foreground"]
