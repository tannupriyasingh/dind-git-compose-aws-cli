from docker:git
from docker:18.06.3-ce-dind
fROM linkyard/docker-helm:2.11.0

RUN apk --no-cache add bash
RUN apk --no-cache add --update curl wget ca-certificates
RUN apk --no-cache add jq
ENV SPRUCE_VERSION 1.18.2
RUN wget https://github.com/geofffranks/spruce/releases/download/v${SPRUCE_VERSION}/spruce-linux-amd64 \
  && chmod a+x spruce-linux-amd64 \
  && mv spruce-linux-amd64 /usr/local/bin/spruce

RUN apk add --no-cache python py2-pip git
RUN pip install --no-cache-dir docker-compose==1.16.0
RUN echo "Install AWS" && \
    apk add --no-cache bash build-base ca-certificates curl gettext git libffi-dev linux-headers make musl-dev openldap-dev openssh-client python3 py-pip python3-dev rsync tzdata && \
    pip3 install --upgrade pip && \
    pip3 install awscli boto3 'PyYAML<=3.13,>=3.10' aws-sam-cli docker-compose --upgrade && \
    echo "Done install AWS" && \
    echo "Cleaning files!" && \
    rm -rf /tmp/* /var/cache/apk/* && \
    docker --version && \
    docker-compose --version && \
    aws --version && \
    sam --version && \
    echo "Done!"
   
