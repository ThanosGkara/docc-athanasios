FROM docker.io/library/alpine:3.15

RUN apk --no-progress update && apk --no-progress upgrade --available && sync && \
    apk add python3 && \
    /usr/bin/python3 -m ensurepip --upgrade && \
    /usr/bin/python3 -m pip install --upgrade pip && \
    /usr/bin/pip3 install bottle PyYaml && \
    mkdir -p /opt/transform && \
    adduser -h /opt/transform -D -u 1001 transform && \
    chmod -R u+rwx /opt/transform

COPY config_transformation_2/*.py /opt/transform/

EXPOSE 8000

USER transform

ENTRYPOINT ["/usr/bin/python3", "-u", "/opt/transform/transform_server.py"]