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

    if [ -d "/ace/code/iqgapi/app/logs" ]
    then
      unlink /ace/code/iqgapi/app/logs
      rm -rf /ace/code/iqgapi/app/logs
      ln -s /ace/log/iqg /ace/code/iqgapi/app/logs
    fi
    touch ${initFile}
fi

\cp /ace/conf/nginx.conf /etc/nginx/nginx.conf
\cp /ace/conf/wqy-microhei.ttc /ace/data/fonts/wqy-microhei.ttc
\cp /ace/conf/authorized_keys /root/.ssh/authorized_keys

chown -R work:work /ace
chown -R work:work /var/log/nginx
chown -R work:work /var/lib/nginx

su work -l -c"SYMFONY_ENV=prod /ace/code/iqgapi/app/console cache:clear"

/usr/sbin/nginx 
su work -c -l "/usr/sbin/php-fpm -D"

su work -l -c"\cp /ace/conf/authorized_keys /home/work/.ssh/authorized_keys"
su work -l -c"logrotate /etc/logrotate.d/nginx_log_rotate -s /ace/log/logrotate.status.tmp"
su work -l -c"logrotate /etc/logrotate.d/php-fpm_log_rotate -s /ace/log/logrotate.status.tmp"
#su work -l -c"nginx"
#su work -l -c"service php-fpm start"

echo success



