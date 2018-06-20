FROM httpd:2.2

ENV DEBIAN_FRONTEND noninterative
ENV FQDN localhost

RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

RUN apt-get update && \
    apt-get install -y --no-install-recommends net-tools vim postfix courier-base sqwebmail courier-imap sudo && \
	rm -fr /var/lib/apt/lists/*

RUN useradd -ms /bin/bash -p PcdO6g4gV662A -u 1001 smtp
RUN adduser smtp sudo
RUN  echo  "%sudo    ALL=NOPASSWD: ALL" | sudo tee -a /etc/sudoers

USER smtp
# enable cgi scripts
RUN sudo a2enmod cgi
RUN sudo a2enmod ssl

# configure redirection on apache
ADD 000-default.conf /etc/apache2/sites-enabled/
RUN sudo mv /var/www/sqwebmail /var/www/html/sqwebmail
# Generate script to run at startup

# Expose the ports
EXPOSE 8080
EXPOSE 8025
EXPOSE 8143
EXPOSE 4443

WORKDIR /home/smtp
RUN maildirmake Maildir
RUN echo "Listen 8080" | sudo tee /etc/apache2/ports.conf
RUN echo "Listen 4443" | sudo tee -a /etc/apache2/ports.conf

ADD generate-certs.sh /home/smtp/
ADD imap-start.sh /home/smtp/
ADD webmail-start.sh /home/smtp/
ADD start.sh /home/smtp/
ADD ssl/example.crt /etc/apache2/ssl/
ADD ssl/example.csr /etc/apache2/ssl/
ADD ssl/example.key /etc/apache2/ssl/

USER root
RUN chmod +x /home/smtp/generate-certs.sh
RUN chmod +x /home/smtp/imap-start.sh
RUN chmod +x /home/smtp/webmail-start.sh
RUN chmod +x /home/smtp/start.sh
RUN chmod -R 777 /var/run/courier/authdaemon
RUN chmod -R 777 /var/run/courier
RUN chmod -R 777 /var/run/apache2
RUN chmod -R 777 /var/log/apache2
RUN chmod -R 777 /var/lock/apache2
RUN chmod 777 /usr/sbin/authdaemond
RUN chmod 777 /etc/courier/authdaemonrc
RUN chmod 777 /usr/sbin/smtp-sink
RUN chown -R smtp:smtp /usr/lib/courier
RUN chown -R smtp:smtp /usr/lib/cgi-bin
USER smtp

CMD ["./start.sh"]
