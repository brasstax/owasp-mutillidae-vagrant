#!/bin/sh -eux

THIS_SCRIPT="$0"
THIS_DIR="$(dirname $0)"

install_file() {
  DEST_FILE=$1
  SOURCE_FILE="/vagrant/config/skel/${DEST_FILE}"
  mkdir -p "$(dirname ${DEST_FILE})"
  cp "${SOURCE_FILE}" "${DEST_FILE}"
}

apt_update() {
  apt update
  echo
}

install_git() {
  apt install -y git
}

install_apache() {
  apt install -y apache2 apache2-utils
}

tweak_apache_dir_conf() {
  install_file /etc/apache2/mods-enabled/dir.conf
  service apache2 restart
}

install_mysql() {
  apt install -y mysql-server php-mysql
  echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'mutillidae'; FLUSH PRIVILEGES;" | mysql -u root
  mysql_secure_installation -u root --password="mutillidae" --use-default
}

install_php() {
  sudo apt-get install -y php php-pear php-gd php-curl
}

install_phpinfo() {
  echo '<?php phpinfo(); ?>' > /var/www/html/phpinfo.php
}

test_php() {
  curl http://localhost/phpinfo.php |grep PHP
  if [ $? -ne 0 ]; then
    echo "Problem with phpinfo.php..."
    exit 1
  fi
}

pull_latest_mutillidae() {
  GIT_REPO="https://github.com/webpwnized/mutillidae"

  if [ ! -d "/vagrant/external/mutillidae" ]; then
    cd /vagrant/external
    git clone "${GIT_REPO}" mutillidae
  else
    cd /vagrant/external/mutillidae
    git remote set-url origin "${GIT_REPO}"
    git fetch
    git checkout main
    git reset --hard origin/main
  fi
}

install_mutillidae() {
  rm -rf /var/www/html/mutillidae
  cp -R /vagrant/external/mutillidae/src /var/www/html/mutillidae
}


show_message() {
  echo
  echo "Now browse to http://localhost:8080/mutillidae/set-up-database.php"
}

install_git
install_apache
tweak_apache_dir_conf
install_mysql
install_php
install_phpinfo
test_php
pull_latest_mutillidae
install_mutillidae
show_message
