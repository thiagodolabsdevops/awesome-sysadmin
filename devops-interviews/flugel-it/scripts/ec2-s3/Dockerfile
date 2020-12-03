FROM python:3.7.6-alpine3.11

RUN apk add --no-cache --update gcc musl-dev libffi-dev openssl-dev

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY . .