FROM centos:7
MAINTAINER networktocode
ENV LIBPATH /etc/ntc/ansible/library

RUN yum --enablerepo=extras install -y epel-release && \
    yum install -y epel-release && \
    yum install -y python-devel python-pip openssl-devel @Development tools libxslt-devel vim libffi-devel python-setuptools curl-devel expat-devel gettext-devel zlib-devel gcc perl-ExtUtils-MakeMaker wget && \
    mkdir -p /etc/ntc/ansible/filter_plugins/ &&\
    mkdir -p /etc/ntc/ansible/library/ && \
    mkdir -p /etc/ntc/playbook/ && \
    pip install ansible==2.4.2

COPY files/requirements /etc/ansible/requirements
COPY files/ansible.cfg /etc/ansible/ansible.cfg

RUN pip install -r /etc/ansible/requirements && \
    git clone --branch master --single-branch --depth 1 https://github.com/networktocode/ntc-ansible $LIBPATH/ntc-ansible --recursive && \
    git clone --branch master --single-branch --depth 1 https://github.com/napalm-automation/napalm-ansible $LIBPATH/napalm-ansible

#ADD http://date.jsontest.com/ /tmp/bustcache


CMD ["/usr/sbin/sshd", "-D"]


