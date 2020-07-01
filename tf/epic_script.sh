#!/bin/bash

sudo apt-get update
sudo apt install docker.io
sudo apt install docker-compose
sudo systemctl start docker
sudo systemctl enable docker
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install
sudo aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 224759732597.dkr.ecr.us-east-2.amazonaws.com
sudo echo 'version: '3'
services:
  db:
    image: 224759732597.dkr.ecr.us-east-2.amazonaws.com/db
    command: --default-authentication-plugin=mysql_native_password
    ports:
      - "3306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: toor
      MYSQL_USER: root
      MYSQL_DATABASE: blog
  web-one:
    image: 224759732597.dkr.ecr.us-east-2.amazonaws.com/web
    ports:
      - "3000:3000"
    environment:
      PORT: 3000
      JAEGER_SAMPLER_TYPE: "const"
      JAEGER_SAMPLER_PARAM: 1
      JAEGER_SAMPLER_MANAGER_HOST_PORT: "jaeger:5778"
      JAEGER_REPORTER_LOG_SPANS: "true"
      JAEGER_AGENT_HOST: "jaeger"
      JAEGER_AGENT_PORT: 6831
    depends_on:
      - loadbalancer
      - logservice
    command: -loadbalancer http://loadbalancer:2001 -logservice http://logservice:6000
  cacheservice:
    image: 224759732597.dkr.ecr.us-east-2.amazonaws.com/cache
    ports:
      - "5000:3000"
  dataservice:
    image:  224759732597.dkr.ecr.us-east-2.amazonaws.com/data
    ports:
      - "4000:4000"
    environment:
      LISTEN_PORT: 4000
      JAEGER_SAMPLER_TYPE: "const"
      JAEGER_SAMPLER_PARAM: 1
      JAEGER_SAMPLER_MANAGER_HOST_PORT: "jaeger:5778"
      JAEGER_REPORTER_LOG_SPANS: "true"
      JAEGER_AGENT_HOST: "jaeger"
      JAEGER_AGENT_PORT: 6831
    depends_on:
      - db
  loadbalancer:
    image: 224759732597.dkr.ecr.us-east-2.amazonaws.com/lb
    ports:
      - "2000:2000"
      - "2001:2001"
    environment:
      JAEGER_SAMPLER_TYPE: "const"
      JAEGER_SAMPLER_PARAM: 1
      JAEGER_SAMPLER_MANAGER_HOST_PORT: "jaeger:5778"
      JAEGER_REPORTER_LOG_SPANS: "true"
      JAEGER_AGENT_HOST: "jaeger"
      JAEGER_AGENT_PORT: 6831
    command: -logservice http://logservice:6000
    depends_on:
      - logservice
  logservice:
    image: 224759732597.dkr.ecr.us-east-2.amazonaws.com/ls
    ports:
      - "6000:6000"
  pinger:
    image: 224759732597.dkr.ecr.us-east-2.amazonaws.com/pinger
    ports:
      - "7000:7000"
  jaeger:
    image: jaegertracing/all-in-one:latest
    ports:
      - "5775:5775/udp"
      - "5778:5778"
      - "6831:6831/udp"
      - "16686:16686"
      - "14268:14268"
      - "9411:9411"
    environment:
      COLLECTOR_ZIPKIN_HTTP_PORT: 9411
    restart: on-failure
' > docker-compose.yaml
sudo docker-compose up -d
