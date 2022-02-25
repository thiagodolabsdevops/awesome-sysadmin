# Zabbix

O Zabbix é uma solução de monitoramento e fornece suporte responsivo e confiável para problemas relacionados ao seu ambiente operacional, executando o monitoramento de redes e aplicativos.

O Zabbix é um dos softwares de código aberto de monitoramento mais populares mundo. Ele é escalável, robusto, além de ser fácil de usar e ter custos operacionais extremamente baixos.

## Implantação do Zabbix Appliance em containers

O Zabbix Appliance consiste na aplicação + banco de dados numa única solução. Nesta implantação, considera-se que já existe um host Docker no ambiente.

```docker run --name Zabbix-Appliance -d -p 80:80 -p 10051:10051 -d zabbix/zabbix-appliance:alpine-trunk```

Depois de rodar o comando acima, basta esperar alguns minutos e abrir o Zabbix no navegador: ```http://<server>:80```

- **User**: admin
- **Pass**: zabbix

**OBS**: Substitua ```<server>``` pelo IP ou hostname do host Docker aonde você fez o deploy do Zabbix.

## Instalação do serviço de monitoramento do Zabbix em máquinas Linux

Para instalar o serviço de monitoramento do Zabbix em máquinas Windows, basta executar os comandos abaixo:

```yum -y install zabbix-agent```

```systemctl start zabbix-agent```

## Instalação do serviço de monitoramento do Zabbix em máquinas Windows

Para instalar o serviço de monitoramento do Zabbix em máquinas Windows, basta executar a linha abaixo (considerando que você instalou os binários do Zabbix no diretório C:\Zabbix):

```C:\Zabbix\4.2\bin\zabbix_agentd.exe --config C:\Zabbix\4.2\conf\zabbix_agentd.win.conf --install```

```net start "Zabbix Agent"```
