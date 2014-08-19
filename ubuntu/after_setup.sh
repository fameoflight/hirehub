cat ~/.ssh/id_rsa.pub | ssh hemantv@192.168.1.3 'rm -rf .ssh && mkdir .ssh && touch .ssh/authorized_keys && cat >> .ssh/authorized_keys'

cat ~/.ssh/id_rsa.pub | ssh root@hirehub.me 'rm -rf .ssh && mkdir .ssh && touch .ssh/authorized_keys && cat >> .ssh/authorized_keys'


GITURL="https://fameoflight@bitbucket.org/fameoflight/hirehub.git"

mkdir -p /home/hemantv/hirehub

git clone $GITURL /home/hemantv/hirehub

sudo mkdir -p /etc/thin/

sudo thin config -C /etc/thin/hirehub.yml -c /home/hemantv/hirehub/  --servers 3 -p 5000 -e production

chown -R hemantv /home/hemantv

cat /etc/thin/hirehub.yml

sudo /etc/init.d/apache2 reload

cd /home/hemantv/hirehub

bundle install

bundle exec rake db:setup --trace RAILS_ENV="production"

bundle exec rake assets:precompile --trace

#bundle exec thin start --servers 3 -p 5000 -e production

sudo service apache2 restart
