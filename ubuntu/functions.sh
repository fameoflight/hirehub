log() {
   echo "$(date +%c) $*"
   echo "$(date +%c) $*" >> $LOG_FILE
}

system_update() {
    log "Running System Update"
    apt-get update >> $LOG_FILE
    apt-get -y install aptitude >> $LOG_FILE
    aptitude -y full-upgrade >> $LOG_FILE
    log "System Update Complete"
}

setup_vim_user() {
    if [ ! -n "$1" ]; then
        echo "vim_user() requires the username as first argument"
        return 1;
    fi
    apt-get -y install vim >> $LOG_FILE
    #$1 required username
    cd /tmp >> $LOG_FILE
    git clone https://fameoflight:india123@bitbucket.org/fameoflight/tools-and-utilities.git >>  $LOG_FILE
    cp -f tools-and-utilities/.vimrc /home/$1/.vimrc >>  $LOG_FILE
}


goodstuff() {
    # Installs the REAL vim, wget, less, and enables color root prompt and the "ll" list long alias
    aptitude -y install wget vim less zsh >> $LOG_FILE
    sed -i -e 's/^#PS1=/PS1=/' /root/.bashrc # enable the colorful root bash prompt
    sed -i -e "s/^#alias ll='ls -l'/alias ll='ls -al'/" /root/.bashrc # enable ll list long alias <3
}

git_setup() {
    log "Git Setup"
    apt-get -y install git
    apt-get -y install git-core
    git config --global user.name "$GIT_USERNAME"
    git config --global user.email "$GIT_EMAIL"
}

zsh_setup() {
    # $1 username
    if [ ! -n "$1" ]; then
        echo "zsh_setup() requires the username as first argument"
        return 1;
    fi
    apt-get -y install zsh >> $LOG_FILE

    # Default to ZSH and Configuration
    sudo -u $1 mkdir ~
    sudo -u $1 chsh -s $(which zsh)
    sudo -u $1 cd ~ && git clone https://github.com/fameoflight/zshrc.git
    sudo -u $1 cd ~/zsh && make install
    log "Setting up Zshrc from Github for hemantv"
}

postfix_install_loopback_only() {
    # Installs postfix and configure to listen only on the local interface. Also
    # allows for local mail delivery
    aptitude -y install postfix >> $LOG_FILE
    echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections
    echo "postfix postfix/mailname string localhost" | debconf-set-selections
    echo "postfix postfix/destinations string localhost.localdomain, localhost" | debconf-set-selections
    aptitude -y install postfix >> $LOG_FILE
    /usr/sbin/postconf -e "inet_interfaces = loopback-only"
    /usr/sbin/postconf -e "local_transport = error:local delivery is disabled"
}

system_primary_ip() {
    # returns the primary IP assigned to eth0
    echo $(ifconfig eth0 | awk -F: '/inet addr:/ {print $2}' | awk '{ print $1 }')
}

apache_install() {
    # installs the system default apache2 MPM
    apt-get -y install apache2 thin >> $LOG_FILE

    a2dissite default # disable the interfering default virtualhost

    # clean up, or add the NameVirtualHost line to ports.conf
    sudo sed -i -e 's/^NameVirtualHost \*$/NameVirtualHost *:80/' /etc/apache2/ports.conf
    if ! grep -q NameVirtualHost /etc/apache2/ports.conf; then
        sudo echo 'NameVirtualHost *:80' > /etc/apache2/ports.conf.tmp
        sudo cat /etc/apache2/ports.conf >> /etc/apache2/ports.conf.tmp
        sudo mv -f /etc/apache2/ports.conf.tmp /etc/apache2/ports.conf
    fi

    a2enmod proxy
    a2enmod proxy_balancer
    a2enmod proxy_http
    a2enmod rewrite
}

apache_tune() {
    # Tunes Apache's memory to use the percentage of RAM you specify, defaulting to 40%

    # $1 - the percent of system memory to allocate towards Apache

    if [ ! -n "$1" ];
        then PERCENT=40
        else PERCENT="$1"
    fi

    aptitude -y install apache2-mpm-prefork >> $LOG_FILE
    PERPROCMEM=10 # the amount of memory in MB each apache process is likely to utilize
    MEM=$(grep MemTotal /proc/meminfo | awk '{ print int($2/1024) }') # how much memory in MB this system has
    MAXCLIENTS=$((MEM*PERCENT/100/PERPROCMEM)) # calculate MaxClients
    MAXCLIENTS=${MAXCLIENTS/.*} # cast to an integer
    sudo sed -i -e "s/\(^[ \t]*MaxClients[ \t]*\)[0-9]*/\1$MAXCLIENTS/" /etc/apache2/apache2.conf
}

apache_virtualhost() {
    # Configures a VirtualHost
    # $1 - required - the hostname of the virtualhost to create

    # $2 - required Full Qualifed Domain name

    if [ ! -n "$1" ]; then
        echo "apache_virtualhost() requires the hostname as the first argument"
        return 1;
    fi

    if [ -e "/etc/apache2/sites-available/$1" ]; then
        log /etc/apache2/sites-available/$1 already exists
        return;
    fi

    mkdir -p /home/deploy/$APPLICATION_NAME/ /home/deploy/$APPLICATION_NAME/logs

    echo "<VirtualHost *:80>" > /etc/apache2/sites-available/$1
    echo "  ServerName $1" >> /etc/apache2/sites-available/$1
    echo "  ServerAlias $FQDN_DOMAIN_NAME" >> /etc/apache2/sites-available/$1
    echo "  DocumentRoot /home/deploy/$APPLICATION_NAME" >> /etc/apache2/sites-available/$1

    echo "  RewriteEngine On" >> /etc/apache2/sites-available/$1

    echo "  <Proxy balancer://thinservers>" >> /etc/apache2/sites-available/$1
    echo "    BalancerMember http://127.0.0.1:5000" >> /etc/apache2/sites-available/$1
    echo "    BalancerMember http://127.0.0.1:5001" >> /etc/apache2/sites-available/$1
    echo "    BalancerMember http://127.0.0.1:5002" >> /etc/apache2/sites-available/$1
    echo "  </Proxy>"  >> /etc/apache2/sites-available/$1

    echo "  RewriteCond %{DOCUMENT_ROOT}/%{REQUEST_FILENAME} !-f" >> /etc/apache2/sites-available/$1
    echo "  RewriteRule ^/(.*)$ balancer://thinservers%{REQUEST_URI} [P,QSA,L]" >> /etc/apache2/sites-available/$1

    echo "  ProxyPass / balancer://thinservers/" >> /etc/apache2/sites-available/$1
    echo "  ProxyPassReverse / balancer://thinservers/" >> /etc/apache2/sites-available/$1
    echo "  ProxyPreserveHost on" >> /etc/apache2/sites-available/$1

    echo "  <Proxy *>" >> /etc/apache2/sites-available/$1
    echo "    Order deny,allow" >> /etc/apache2/sites-available/$1
    echo "    Allow from all" >> /etc/apache2/sites-available/$1
    echo "  </Proxy>" >> /etc/apache2/sites-available/$1

    echo "  ErrorLog /home/deploy/$APPLICATION_NAME/logs/error.log" >> /etc/apache2/sites-available/$1
    echo "  CustomLog /home/deploy/$APPLICATION_NAME/logs/access.log combined" >> /etc/apache2/sites-available/$1
    echo "</VirtualHost>" >> /etc/apache2/sites-available/$1

    a2ensite $1 >> $LOG_FILE
}

###########################################################
# mysql-server
###########################################################

mysql_install() {
    # $1 - the mysql root password
    if [ ! -n "$1" ]; then
        echo "mysql_install() requires the root pass as its first argument"
        return 1;
    fi

    echo "mysql-server-5.1 mysql-server/root_password password $1" | debconf-set-selections
    echo "mysql-server-5.1 mysql-server/root_password_again password $1" | debconf-set-selections
    apt-get -y install mysql-server mysql-client >> $LOG_FILE

    log "Sleeping while MySQL starts up for the first time..."
    sleep 5
}

mysql_tune() {
    # Tunes MySQL's memory usage to utilize the percentage of memory you specify, defaulting to 40%

    # $1 - the percent of system memory to allocate towards MySQL

    if [ ! -n "$1" ];
        then PERCENT=40
        else PERCENT="$1"
    fi

    sed -i -e 's/^#skip-innodb/skip-innodb/' /etc/mysql/my.cnf # disable innodb - saves about 100M

    MEM=$(awk '/MemTotal/ {print int($2/1024)}' /proc/meminfo) # how much memory in MB this system has
    MYMEM=$((MEM*PERCENT/100)) # how much memory we'd like to tune mysql with
    MYMEMCHUNKS=$((MYMEM/4)) # how many 4MB chunks we have to play with

    # mysql config options we want to set to the percentages in the second list, respectively
    OPTLIST=(key_buffer sort_buffer_size read_buffer_size read_rnd_buffer_size myisam_sort_buffer_size query_cache_size)
    DISTLIST=(75 1 1 1 5 15)

    for opt in ${OPTLIST[@]}; do
        sudo sed -i -e "/\[mysqld\]/,/\[.*\]/s/^$opt/#$opt/" /etc/mysql/my.cnf
    done

    for i in ${!OPTLIST[*]}; do
        val=$(echo | awk "{print int((${DISTLIST[$i]} * $MYMEMCHUNKS/100))*4}")
        if [ $val -lt 4 ]
            then val=4
        fi
        config="${config}\n${OPTLIST[$i]} = ${val}M"
    done

    sed -i -e "s/\(\[mysqld\]\)/\1\n$config\n/" /etc/mysql/my.cnf
}

mysql_create_database() {
    # $1 - the mysql root password
    # $2 - the db name to create

    if [ ! -n "$1" ]; then
        log "mysql_create_database() requires the root pass as its first argument"
        return 1;
    fi
    if [ ! -n "$2" ]; then
        log "mysql_create_database() requires the name of the database as the second argument"
        return 1;
    fi

    echo "CREATE DATABASE $2;" | mysql -u root -p$1
}

mysql_create_user() {
    # $1 - the mysql root password
    # $2 - the user to create
    # $3 - their password

    if [ ! -n "$1" ]; then
        log "mysql_create_user() requires the root pass as its first argument"
        return 1;
    fi
    if [ ! -n "$2" ]; then
        log "mysql_create_user() requires username as the second argument"
        return 1;
    fi
    if [ ! -n "$3" ]; then
        log "mysql_create_user() requires a password as the third argument"
        return 1;
    fi

    echo "CREATE USER '$2'@'localhost' IDENTIFIED BY '$3';" | mysql -u root -p$1
}

mysql_grant_user() {
    # $1 - the mysql root password
    # $2 - the user to bestow privileges
    # $3 - the database

    if [ ! -n "$1" ]; then
        log "mysql_create_user() requires the root pass as its first argument"
        return 1;
    fi
    if [ ! -n "$2" ]; then
        log "mysql_create_user() requires username as the second argument"
        return 1;
    fi
    if [ ! -n "$3" ]; then
        log "mysql_create_user() requires a database as the third argument"
        return 1;
    fi

    echo "GRANT ALL PRIVILEGES ON $3.* TO '$2'@'localhost';" | mysql -u root -p$1
    echo "FLUSH PRIVILEGES;" | mysql -u root -p$1

}

misc_install() {
    log "Installing Misc"
    apt-get -y install build-essential >> $LOG_FILE
    apt-get -y install libssl-dev zlib1g-dev libyaml-dev libxslt-dev >> $LOG_FILE
    apt-get -y install memcached libcurl4-openssl-dev >> $LOG_FILE
    apt-get -y install sshfs lynx adacontrol libxml2-dev >> $LOG_FILE
    apt-get -y install libapr1-dev libaprutil1-dev libffi-dev >> $LOG_FILE
    apt-get -y install zlib1g-dev libssl-dev openssh-server >> $LOG_FILE
}

add_user() {
    apt-get -y install zsh >> $LOG_FILE
    if [ ! -n "$1" ]; then
        echo "add_user() requires the username as its first argument"
        return 1;
    fi
    if [ ! -n "$2" ]; then
        echo "add_user() requires the userid (numeric) as its second argument"
        return 1;
    fi
    if [ ! -n "$3" ]; then
        echo "add_user() requires the user full name as its third argument"
        return 1;
    fi

    echo "$1:$1:$2:$2:$3:/home/$1:/bin/zsh" | newusers
    cp -a /etc/skel/.[a-z]* /home/$1/
    chown -R $1 /home/$1
    # Add to sudoers(?)
    echo "$1 ALL=(ALL) ALL" >> /etc/sudoers
    log "Added New User $1"
}

ruby_rails_setup() {
    export REALLY_GEM_UPDATE_SYSTEM=1

    log "Installing Ruby and Rails"
    #Installing Ruby
    apt-get -y install ruby1.9.3 >> $LOG_FILE

    # Install rails
    gem install rails --no-ri --no-rdoc >> $LOG_FILE

    # Install sqlite gem
    apt-get -y install sqlite3 libsqlite3-dev >> $LOG_FILE
    gem install sqlite3-ruby --no-ri --no-rdoc >> $LOG_FILE
    log "Installing Sqlite3 and Ruby Support "

    # Install mysql gem
    apt-get -y install libmysql-ruby libmysqlclient-dev >> $LOG_FILE
    gem install mysql2 --no-ri --no-rdoc >> $LOG_FILE

    # Install thin gem
    gem install thin --no-ri -no-rdoc >> $LOG_FILE
}


languages_install() {
    apt-get -y install gcc g++ >> $LOG_FILE
    apt-get -y install mono-devel mono-dmcs mono-gmcs >> $LOG_FILE
    apt-get -y install python2.7 >> $LOG_FILE
    apt-get -y install openjdk-7-jdk >> $LOG_FILE
    apt-get -y install scala >> $LOG_FILE
}





