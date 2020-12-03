FROM alpine:latest
WORKDIR /
RUN apk add --no-cache --update ansible git

RUN git clone https://github.com/ansible/awx.git
RUN cd awx/ && git clone https://github.com/ansible/awx-logos.git
RUN cd installer/ && ansible-playbook -i inventory install.yml -vv
# COPY . .