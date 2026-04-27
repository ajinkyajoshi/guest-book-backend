FROM mysql:8.0
COPY init.sql /docker-entrypoint-initdb.d/
ENV MYSQL_ROOT_PASSWORD=rootpass
ENV MYSQL_DATABASE=guestbook
ENV MYSQL_USER=guestuser
ENV MYSQL_PASSWORD=guestpass
EXPOSE 3306
