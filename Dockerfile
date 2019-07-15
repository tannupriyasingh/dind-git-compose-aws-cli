from docker:git
from docker:18.06.3-ce-dind
FROM alpine:3.8 as build

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
   
   
RUN apk add --update --no-cache ca-certificates git
ENV VERSION=v2.12.2
ENV FILENAME=helm-${VERSION}-linux-amd64.tar.gz
ENV SHA256SUM=edad6d5e594408b996b8d758a04948f89dab15fa6c6ea6daee3709f8c099df6d
WORKDIR /
RUN apk add --update -t deps curl tar gzip
RUN curl -L http://storage.googleapis.com/kubernetes-helm/${FILENAME} > ${FILENAME} && \
    echo "${SHA256SUM}  ${FILENAME}" > helm_${VERSION}_SHA256SUMS && \
    sha256sum -cs helm_${VERSION}_SHA256SUMS && \
    tar zxv -C /tmp -f ${FILENAME} && \
    rm -f ${FILENAME}
        
FROM alpine:3.8
RUN apk add --update --no-cache git ca-certificates
COPY --from=build /tmp/linux-amd64/helm /bin/helm
ENTRYPOINT ["/bin/helm"]

