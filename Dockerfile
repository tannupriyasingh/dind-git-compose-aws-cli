from docker:git
From docker:18.06.3-ce-dind


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