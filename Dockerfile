FROM wordpress:4.7.3

ADD adapter.sh /opt/adapter.sh
RUN chmod +x /opt/adapter.sh

ENTRYPOINT ["/opt/adapter.sh", "docker-entrypoint.sh"]
CMD ["apache2-foreground"]
