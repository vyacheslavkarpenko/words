## Add puma to you Gemfile: ##
```
gem "puma"
```

## Install Puma Gem ##
```
change to project directory
bundle install
```

## Start your app via puma ##
```
puma -e [environment] -p [port-number] -d

puma -e production -p 9292 -d
This will start the rails app in production environment on port 9292 and daemonize the process
```

## Make sure Apache proxy mods are enabled ##
```
sudo a2enmod proxy
sudo a2enmod proxy_http
```

## Setup Apache Config ##
```
Example /etc/apache2/sites-available/[app_name] .conf file
<virtualHost *:80>
  ServerName www.multisverbis.ddns.net
  ServerAlias multisverbis.ddns.net
  DocumentRoot /var/www/multisverbis/public

  #<location /assets>
  #  ProxyPass !
  #</location>
  <location /system>
    ProxyPass !
  </location>

    ProxyPass / http://127.0.0.1:5000/
    ProxyPassReverse / http://127.0.0.1:5000/
</virtualHost>

```

## Enable site and restart Apache ##
```
sudo a2ensite site-1
apachectl -t
sudo /etc/init.d/apache2 restart
```

## To stop the Puma Daemon ##
// There are better ways to do this, but this is quick and dirty and works for temporary environments

Find Process ID
```
ps aux | grep puma
lsof -wni tcp:[port_number]
```

the process you're looking for should be running on the port of your app

Stop Process
`sudo kill -9 [process ID]`

Start Process
`puma -e [environment] -p [port-number] -d`



## Based off of ##
https://www.learnwithdaniel.com/2015/01/apache-puma-via-reverse-proxy/