FROM centos

MAINTAINER Vijayendra Hunasgi

RUN mkdir /opt/tomcat/

WORKDIR /opt/tomcat
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-*
RUN dnf update -y
RUN dnf install  java-11 -y
RUN java -version
RUN yum install git -y
RUN yum install -y yum-utils
RUN yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
RUN yum -y install terraform
RUN yum -y install wget
RUN cd /var/tmp; wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.76/bin/apache-tomcat-9.0.76.tar.gz; tar -xvzf apache-tomcat-9.0.76.tar.gz; mv apache-tomcat-9.0.76/* /opt/tomcat
RUN cd /var/tmp
RUN git clone https://github.com/Vijayendrahunasgi/dockerwp.git
RUN chmod +x /var/tmp/dockerwp/terraform_install.sh
RUN chmod +x /var/tmp/dockerwp/azurecli.sh
RUN /var/tmp/dockerwp/terraform_install.sh
RUN /var/tmp/dockerwp/azurecli.sh

WORKDIR /opt/tomcat/webapps
RUN curl -O -L https://updates.jenkins.io/download/war/2.405/jenkins.war

EXPOSE 8080

CMD ["/opt/tomcat/bin/catalina.sh", "run"]
