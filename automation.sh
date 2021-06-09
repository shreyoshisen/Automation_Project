sudo apt update -y
timestamp=$(date '+%d%m%Y-%H%M%S') 
myname='Shreyoshi'
apache2 -v
s3_bucket='upgrad-shreyoshi'
if  [ $? -eq 0 ]; then
        echo "apache2 is installed"
else
        echo " installing apache2"
        sudo apt install apache2
        service apache2 start
fi
ps -eaf | grep apache2
if [ $? -eq 0 ]; then
        echo "Process is running."
else
        echo "Process is not running."
        service apache2 start
fi

tar -cvf - /var/log/apache2/* > /tmp/$myname-httpd-logs-$timestamp.tar

aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar

if [[ !  /var/www/html/inventory.html  ]];
then
touch /var/www/html/inventory.html
echo "Log Type          Time Created            Type            Size" > /var/www/html/inventory.html
else
echo "httpd-logs                $timestamp              tar             `wc -c /tmp/$myname-httpd-logs-$timestamp.tar |awk '{print $1}'`" >>  /var/www/html/inventory.html
fi
sudo su
crontab -l > /etc/cron.d/automation
#echo new cron into cron file
echo "0 0 * * * root /root/Automation_Project/automation.sh" >> /etc/cron.d/automation
#install new cron file
crontab /etc/cron.d/automation
