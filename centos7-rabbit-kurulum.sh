#!/bin/bash

echo "Verify key'ler ayarlanıyor.."

rpm --import https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc

rpm --import https://packagecloud.io/rabbitmq/erlang/gpgkey

rpm --import https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey

echo "Repo oluşturuluyor.."

echo "[rabbitmq_erlang]
name=rabbitmq_erlang
baseurl=https://packagecloud.io/rabbitmq/erlang/el/7/\$basearch
repo_gpgcheck=1
gpgcheck=1
enabled=1

gpgkey=https://packagecloud.io/rabbitmq/erlang/gpgkey
       https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300

[rabbitmq_erlang-source]
name=rabbitmq_erlang-source
baseurl=https://packagecloud.io/rabbitmq/erlang/el/7/SRPMS
repo_gpgcheck=1
gpgcheck=0
enabled=1
gpgkey=https://packagecloud.io/rabbitmq/erlang/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300

[rabbitmq_server]
name=rabbitmq_server
baseurl=https://packagecloud.io/rabbitmq/rabbitmq-server/el/7/\$basearch
repo_gpgcheck=1
gpgcheck=1
enabled=1

gpgkey=https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey
       https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300

[rabbitmq_server-source]
name=rabbitmq_server-source
baseurl=https://packagecloud.io/rabbitmq/rabbitmq-server/el/7/SRPMS
repo_gpgcheck=1
gpgcheck=0
enabled=1
gpgkey=https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300" > /etc/yum.repos.d/rabbitmq.repo

echo "Gerekli paketler indiriliyor.."

yum update -y

yum install socat logrotate -y

yum install erlang rabbitmq-server -y

echo "Servis çalıştırmak için gerekli araçlar indiriliyor.."

yum -y install initscripts

echo "Servis başlangıçta çalıştırılmak için ayarlanıyor.."

chkconfig rabbitmq-server on

echo "Servis başlatılıyor.."

/sbin/service rabbitmq-server start

echo "Kullanıcı ekleniyor.."

rabbitmqctl add_user test test
wait

rabbitmqctl set_user_tags test administrator
wait

rabbitmqctl set_permissions -p / test ".*" ".*" ".*"
wait

echo "Default kullanıcı siliniyor.."

rabbitmqctl delete_user guest
wait

echo "Managemen UI plugini devreye sokuluyor.."

rabbitmq-plugins enable rabbitmq_management
wait