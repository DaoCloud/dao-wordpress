FROM wordpress:4.3.1

ADD adapter.sh /opt/adapter.sh
RUN chmod +x /opt/adapter.sh

ENTRYPOINT ["/opt/adapter.sh", "/entrypoint.sh"]
CMD ["apache2-foreground"]
