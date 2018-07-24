#!/bin/sh

rm -rf /etc/nginx/conf.d/*.conf

for line in $(cat /config | sed '/^#.*$/d' | tr -s '\n')
do
    project_name=`echo -n "$line" | awk -F ',' '{printf $1}'`
    project_dir=`echo -n "$line" | awk -F ',' '{printf $2}'`
    php_version=`echo -n "$line" | awk -F ',' '{printf $3}'`

    cp /etc/nginx/conf.d/site.template /etc/nginx/conf.d/$project_name.conf
    sed -i 's/<{project_domain}>/'$PROJECT_DOMAIN'/g' /etc/nginx/conf.d/$project_name.conf
    sed -i 's/<{project_name}>/'$project_name'/g' /etc/nginx/conf.d/$project_name.conf
    sed -i 's/<{php_version}>/'$php_version'/g' /etc/nginx/conf.d/$project_name.conf

    if [ -d "/www/$project_dir/public" ]; then
        sed -i 's/<{project_dir}>/'$project_dir'\/public/g' /etc/nginx/conf.d/$project_name.conf
    else
        sed -i 's/<{project_dir}>/'$project_dir'/g' /etc/nginx/conf.d/$project_name.conf
    fi
done

exec "$@"