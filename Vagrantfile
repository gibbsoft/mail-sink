# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.network "forwarded_port", guest: 8443, host: 8443, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 8025, host: 8025, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 443, host: 4443, host_ip: "127.0.0.1"
  config.vm.provider "virtualbox" do |vb|
    vb.linked_clone = true
    vb.cpus = 2
    vb.memory = "8192"
  end
  config.vm.provision "shell", inline: <<-SHELL
    export PATH=$PATH:/usr/local/bin
    cp /vagrant/oc /usr/local/bin/
    yum install -y docker
    echo '{ "insecure-registries": [ "172.30.0.0/16" ] }' >/etc/docker/daemon.json
    systemctl enable docker
    systemctl start docker
    oc cluster up
    oc login -u system:admin
    oc adm policy add-cluster-role-to-user cluster-admin developer
    oc new-project mail-sink
    cd /vagrant
    ./deploy.sh
  SHELL
end
