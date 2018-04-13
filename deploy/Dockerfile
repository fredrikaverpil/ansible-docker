# Based on https://github.com/ansible/ansible-docker-base/blob/master/stable-centos7/Dockerfile

FROM centos:7

LABEL Toshio Kuratomi <tkuratomi@ansible.com>
RUN yum clean all && \
    yum -y install epel-release && \
    yum -y install PyYAML python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools git python-pip && \
    yum -y install net-tools openssh-server ssh openssh-clients sshpass vim nano

RUN mkdir /etc/ansible/

RUN pip install --upgrade pip && \
    pip install ansible

# For Windows support
RUN pip install "pywinrm>=0.2.2"

# Add keys
ADD .ssh/id_rsa /root/.ssh/id_rsa
ADD .ssh/id_rsa.pub /root/.ssh/id_rsa.pub
RUN chmod 700 /root/.ssh/id_rsa
