#!/bin/bash

chown www-data:www-data /app -R
chmod -R 777 /app/wp-content

export MYSQL_DB_HOST=${MYSQL_DB_HOST:-${MYSQL_PORT_3306_TCP_ADDR}}
export MYSQL_DB_PORT=${MYSQL_DB_PORT:-${MYSQL_PORT_3306_TCP_PORT}}

echo "=> Using the following MySQL configuration:"
echo "========================================================================"
echo "      Database Host Address:  $MYSQL_DB_HOST"
echo "      Database Port number:   $MYSQL_DB_PORT"
echo "      Database Name:          $MYSQL_INSTANCE_NAME"
echo "      Database Username:      $MYSQL_USERNAME"
echo "      Database Password:      $MYSQL_PASSWORD"
echo "========================================================================"

if [ -f /.mysql_db_created ]; then
        source /etc/apache2/envvars
        exec apache2 -D FOREGROUND
fi

for ((i=0;i<10;i++))
do
    DB_CONNECTABLE=$(mysql -u$MYSQL_USERNAME -p$MYSQL_PASSWORD -h$MYSQL_DB_HOST -P$MYSQL_DB_PORT -e 'status' >/dev/null 2>&1; echo "$?")
    if [[ DB_CONNECTABLE -eq 0 ]]; then
        break
    fi
    sleep 5
done

if [[ $DB_CONNECTABLE -eq 0 ]]; then
    DB_EXISTS=$(mysql -u$MYSQL_USERNAME -p$MYSQL_PASSWORD -h$MYSQL_DB_HOST -P$MYSQL_DB_PORT -e "SHOW DATABASES LIKE '"$MYSQL_INSTANCE_NAME"';" 2>&1 |grep "$MYSQL_INSTANCE_NAME" > /dev/null ; echo "$?")

    if [[ DB_EXISTS -eq 1 ]]; then
        echo "=> Creating database $MYSQL_INSTANCE_NAME"
        RET=$(mysql -u$MYSQL_USERNAME -p$MYSQL_PASSWORD -h$MYSQL_DB_HOST -P$MYSQL_DB_PORT -e "CREATE DATABASE $MYSQL_INSTANCE_NAME")
        if [[ RET -ne 0 ]]; then
            echo "Cannot create database for wordpress"
            exit RET
        fi
        if [ -f /initial_db.sql ]; then
            echo "=> Loading initial database data to $MYSQL_INSTANCE_NAME"
            RET=$(mysql -u$MYSQL_USERNAME -p$MYSQL_PASSWORD -h$MYSQL_DB_HOST -P$MYSQL_DB_PORT $MYSQL_INSTANCE_NAME < /initial_db.sql)
            if [[ RET -ne 0 ]]; then
                echo "Cannot load initial database data for wordpress"
                exit RET
            fi
        fi
        echo "=> Done!"    
    else
        echo "=> Skipped creation of database $MYSQL_INSTANCE_NAME – it already exists."
    fi
else
    echo "Cannot connect to MySQL"
    exit $DB_CONNECTABLE
fi

touch /.mysql_db_created

source /etc/apache2/envvars
exec apache2 -D FOREGROUND
