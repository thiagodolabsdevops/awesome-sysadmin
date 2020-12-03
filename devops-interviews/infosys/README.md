# Teste DevOps / Cloud

## Infraestrutura como código

A infraestrutura deve ser provisionada na AWS utilizando Terraform. O código deverá contemplar os seguintes recursos:

- 2 x instâncias EC2 (um frontend e um backend)
- 2 x Security Group’s:
  - Um dos security group deve conter uma liberação para HTTP e HTTPS e ser atachado no frontend
  - O outro security group deve ter apenas uma liberação SSH vindo do frontend e ser atachado no backend

## Docker

Visando a evolução da aplicação para microserviço, monte um Dockerfile funcional de uma aplicação web usando Nginx como demonstração e importando um index.html contendo o HTML abaixo:

```<h1>TESTE DEVOPS</h1>```

## CI/CD

Implemente um fluxo de CI/CD no Github Actions visando a entrega de uma imagem Docker utilizando o seu conhecimento sobre o processo.

## O que será avaliado na solução

Seu código será observado por uma equipe de desenvolvedores que avaliarão a implementação do código, simplicidade e clareza da solução, nível de automação e documentação.

## Dicas

- Use ferramentas e bibliotecas open source
- Documente as decisões e porquês;
- Automatize o máximo possível
