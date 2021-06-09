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
