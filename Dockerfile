FROM httpd:2.4

ENV DEBIAN_FRONTEND noninteractive
ENV FQDN localhost
ENV USER_NAME smtp
ENV USER_ID 10001
ENV USER_PASSWORD PcdO6g4gV662A
ENV APACHE_RUN_USER smtp
ENV APACHE_RUN_GROUP smtp

RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

# filthy hack, see https://bugs.launchpad.net/ubuntu/+source/courier/+bug/1781243
RUN mkdir -p /usr/share/man/man1 \
    /usr/share/man/man5 \
    /usr/share/man/man7 \
    /usr/share/man/man8 && \
    touch /usr/share/man/man1/lockmail.1.gz \
    /usr/share/man/man1/maildirmake.courier.1.gz \
    /usr/share/man/man1/maildirmake.maildrop.1.gz \
    /usr/share/man/man1/makedat.courier.1.gz \
    /usr/share/man/man5/maildir.courier.5.gz \
    /usr/share/man/man5/maildir.maildrop.5.gz \
    /usr/share/man/man7/maildirquota.courier.7.gz \
    /usr/share/man/man7/maildirquota.maildrop.7.gz \
    /usr/share/man/man8/deliverquota.courier.8.gz \
    /usr/share/man/man8/deliverquota.maildrop.8.gz

RUN apt-get update && \
    apt-get install -y --no-install-recommends maildrop && \
    apt-get install -y --no-install-recommends postfix courier-base sqwebmail courier-imap && \
    apt-get autoremove -y && \
    rm -fr /var/lib/apt/lists/*

RUN useradd -ms /bin/bash -p $USER_PASSWORD -u $USER_ID -g 0 $USER_NAME

# enable cgi scripts
RUN a2enmod cgi && \
    a2enmod ssl

# configure redirection on apache
ADD 000-default.conf /etc/apache2/sites-enabled/
RUN mv /var/www/sqwebmail /var/www/html/sqwebmail

# Expose the ports
EXPOSE 8080
EXPOSE 8025
EXPOSE 8143
EXPOSE 4443

WORKDIR /home/smtp
RUN echo "Listen 8080" | tee /etc/apache2/ports.conf && \
    echo "Listen 4443" | tee -a /etc/apache2/ports.conf

ADD generate-certs.sh /home/smtp/
ADD imap-start.sh /home/smtp/
ADD webmail-start.sh /home/smtp/
ADD start.sh /home/smtp/

RUN chown -R 0 / 2>/dev/null || true
RUN chmod -R 777 / 2>/dev/null || true
USER $USER_ID

CMD ["./start.sh"]
