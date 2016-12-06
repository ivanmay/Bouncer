FROM postgres:latest

ENV POSTGRES_USER praetorian
ENV POSTGRES_PASSWORD praetorian
ENV POSTGRES_DB praetorian

ADD "sql/ddl.sql" "/docker-entrypoint-initdb.d/"
