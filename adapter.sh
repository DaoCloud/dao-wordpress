#!/bin/bash

if [ -n "$MYSQL_INSTANCE_NAME" ]
then
    echo "info: Deploy at DaoCloud."
    export WORDPRESS_DB_HOST=$MYSQL_PORT_3306_TCP_ADDR":"$MYSQL_PORT_3306_TCP_PORT
    export WORDPRESS_DB_USER=$MYSQL_USERNAME
    export WORDPRESS_DB_PASSWORD=$MYSQL_PASSWORD
    export WORDPRESS_DB_NAME=$MYSQL_INSTANCE_NAME
    echo "========================================================================"
    echo "Using these environment variables:"
    echo ""
    echo "  \$WORDPRESS_DB_HOST = ${WORDPRESS_DB_HOST}"
    echo "  \$WORDPRESS_DB_USER = ${WORDPRESS_DB_USER}"
    echo "  \$WORDPRESS_DB_PASSWORD = ${WORDPRESS_DB_PASSWORD}"
    echo "  \$WORDPRESS_DB_NAME = ${WORDPRESS_DB_NAME}"
    echo ""
    echo "========================================================================"
fi

exec "$@"