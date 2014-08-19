# Proper Way to Setup Using Apache Thin
# http://articles.slicehost.com/2009/2/27/ubuntu-intrepid-apache-rails-and-thin

#Prerequiste
    # 1. Setup DNS

source functions.sh

NOW=$(date +"%b-%d-%y")
LOG_FILE="/tmp/ubuntu-server-setup-$NOW.log"

DB_PASSWORD='india123'
APPLICATION_NAME='hirehub'
DOMAIN_NAME='hirehub.me'
FQDN_DOMAN_NAME='www.hirehub.me'
GIT_USERNAME="HireHub Server"
GIT_EMAIL='admin@hirehub.me'

RAILS_ENV="production"

log "Setup Script Starting"

system_update
goodstuff && misc_install

git_setup

add_user "hemantv" 786 "Hemant Verma"
add_user "deploy" 1024 "Deploy User"

zsh_setup "hemantv"
zsh_setup "deploy"
zsh_setup "root"

#Installing Web Server Components
apache_install && apache_tune
postfix_install_loopback_only
apache_virtualhost DOMAIN_NAME
echo "hirehub" > /etc/hostname
hostname -F /etc/hostname
apache2ctl graceful

#Install MySQL
mysql_install "$DB_PASSWORD" && mysql_tune 40
mysql_create_user "$DB_PASSWORD" "deploy" "$DB_PASSWORD"

#Ruby and Rails Setup
ruby_rails_setup


export RAILS_ENV
sudo -u deploy export RAILS_ENV
sudo -u hemantv export RAILS_ENV

restart_services() {
    # restarts services that have a file in /tmp/useds-restart/
    for service in $(ls /tmp/restart-* | cut -d- -f2-10); do
        sudo /etc/init.d/$service restart
        sudo rm -f /tmp/restart-$service
    done
}

languages_install

# pit & polish
system_update
log "Restarting Services"
restart_services

