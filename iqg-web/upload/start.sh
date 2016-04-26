#!/bin/bash
acePath="/ace/"
initFile="${acePath}/run/imageInited"

if [ -e ${initFile} ]
then
    cd /ace/code/satellite  
    rm -rf /ace/code/satellite/app/logs
    ln -s /ace/log/iqg /ace/code/satellite/app/logs
    mkdir -p /ace/code/satellite/web/uploads/branches
    mkdir /ace/code/satellite/web/uploads/brands
    mkdir /ace/code/satellite/web/uploads/images
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

    if [ -d "/ace/code/satellite/app/logs" ]
    then
      unlink /ace/code/satellite/app/logs
      rm -rf /ace/code/satellite/app/logs
      ln -s /ace/log/iqg /ace/code/satellite/app/logs
    fi
    touch ${initFile}
fi

\cp /ace/upload_conf/nginx.conf /etc/nginx/nginx.conf
\cp /ace/upload_conf/wqy-microhei.ttc /ace/data/fonts/wqy-microhei.ttc
\cp /ace/upload_conf/authorized_keys /root/.ssh/authorized_keys

chown -R work:work /ace
chown -R work:work /var/log/nginx
chown -R work:work /var/lib/nginx

su work -l -c"SYMFONY_ENV=prod /ace/code/satellite/app/console cache:clear"

/usr/sbin/nginx 
su work -c -l "/usr/sbin/php-fpm -D"

su work -l -c"\cp /ace/upload_conf/authorized_keys /home/work/.ssh/authorized_keys"
su work -l -c"logrotate /etc/logrotate.d/nginx_log_rotate -s /ace/log/logrotate.status.tmp"
su work -l -c"logrotate /etc/logrotate.d/php-fpm_log_rotate -s /ace/log/logrotate.status.tmp"

echo success



