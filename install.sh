apt-get update && apt-get upgrade -y

tee -a /etc/apt/sources.list.d/pritunl.list << EOF
deb http://repo.pritunl.com/stable/apt stretch main
EOF

apt-get install dirmngr
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
apt-get update
apt-get --assume-yes install pritunl mongodb-server
systemctl start mongodb pritunl
systemctl enable mongodb pritunl

sh -c 'echo "* hard nofile 64000" >> /etc/security/limits.conf'
sh -c 'echo "* soft nofile 64000" >> /etc/security/limits.conf'
sh -c 'echo "root hard nofile 64000" >> /etc/security/limits.conf'
sh -c 'echo "root soft nofile 64000" >> /etc/security/limits.conf'

cd /dev
mkdir net
cd net
mknod tun c 10 200
chmod 666 tun

pritunl setup-key
