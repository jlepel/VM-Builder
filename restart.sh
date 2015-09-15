sudo rm /var/log/apache2/error.log
sudo /etc/init.d/apache2 stop
sudo /etc/init.d/apache2 start
touch tmp/restart.txt

