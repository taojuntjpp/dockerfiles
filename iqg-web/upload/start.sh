#!/bin/bash
acePath="/ace/"
initFile="${acePath}/run/imageInited"

if [ -e ${initFile} ]
then
    cd /ace/code/iqgapi  
    rm -rf /ace/code/iqgapi/app/logs
    ln -s /ace/log/iqg /ace/code/iqgapi/app/logs
    mkdir -p /ace/code/iqgapi/web/uploads/branches
    mkdir /ace/code/iqgapi/web/uploads/brands
    mkdir /ace/code/iqgapi/web/uploads/images
else
    mkdir -p  ${acePath}log/php  \
              ${acePath}log/nginx \
              ${acePath}log/php-fpm \
              ${acePath}run \
              ${acePath}data/fonts -p \
              ${acePath}data/cronjobs -p \
              ${acePath}data/nginx/client_body -p
    if [ ! -d "/ace/log/iqg" ]
    then
      mkdir -p /ace/log/iqg
    fi
    touch ${initFile}
fi 



\cp /ace/upload_conf/nginx.conf       /etc/nginx/nginx.conf
\cp /ace/upload_conf/wqy-microhei.ttc /ace/data/fonts/wqy-microhei.ttc
\cp /ace/upload_conf/authorized_keys  /root/.ssh/authorized_keys

chown -R work:work /ace
chown -R work:work /var/log/nginx
chown -R work:work /var/lib/nginx

su work -l -c"SYMFONY_ENV=prod /ace/code/iqgapi/app/console cache:clear"
/usr/sbin/nginx
/usr/sbin/crond
su work -l -c"\cp /ace/upload_conf/authorized_keys /home/work/.ssh/authorized_keys"

echo success