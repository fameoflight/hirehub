== Welcome ==

Welcome to HireHub

http://articles.slicehost.com/2009/2/27/ubuntu-intrepid-apache-rails-and-thin

=== Setup Ruby on Rails ===

If you are on Windows the best way to setup is http://railsinstaller.org/ 

If you are on Mac OSX the best way to setup rails is following article.

[Updated with MySQL]
http://thinkvitamin.com/code/ruby-on-rails/installing-ruby-rails-and-mysql-on-os-x-lion/

http://eddorre.com/posts/rails-ultimate-install-guide-on-os-x-lion-using-rvm-homebrew-and-pow

=== Setup MySQL ===

Go ahead and download the setup and get it running on your machine. Note for mac you should install 64bit version of MySQL. 

=== Clone Project === 

Go ahead and clone the project using the below command line. :

```
$ git clone https://github.com/fameoflight/hirehub.git
```

Go to your project directory and run bundle install to have all the gem files. Sometimes you might have to delete the Gemfile.lock or do the bundle update. 



Windows user might run on SSL Error , the temp solution is here 

http://stackoverflow.com/questions/10246023/bundle-install-fails-with-ssl-certificate-verification-error

Other Solutions 

http://railsapps.github.com/openssl-certificate-verify-failed.html
-- You can simply install a new version of open ssl and then do gem update system. Which in probability should fix this.


Window setup have problem with mysql2 to get it running on Windows 7 

Follow instruction here. 

http://stackoverflow.com/questions/5775344/how-to-use-mysql2-gem-in-rails-3-application-on-windows-7/7313694#7313694

=== Setup Database === 

Once you have everything running and correct config in config/database.yml don't checkin your config either make you root password equivalent to given in config. 

```
rake db:setup #will do all the setup for you
```

Have fun!
