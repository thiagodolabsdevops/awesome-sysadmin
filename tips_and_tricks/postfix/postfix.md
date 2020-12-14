# Postfix + SpamAssassin + OpenDKIM

- RHEL: ```sudo yum -y install postfix spamassassin opendkim```
- Ubuntu: ```sudo apt -y install postfix spamassassin opendkim```

## Configurar o OpenDKIM

```bash
sudo cat <<EOF > /etc/opendkim.conf
PidFile             /var/run/opendkim/opendkim.pid
Mode                sv
Syslog              yes
SyslogSuccess       yes
LogWhy              yes
UserID              opendkim:opendkim
Socket              inet:8891@localhost
Umask               002
Canonicalization    relaxed/relaxed
Selector            default
MinimumKeyBits      1024
KeyTable            refile:/etc/opendkim/KeyTable
SigningTable        refile:/etc/opendkim/SigningTable
ExternalIgnoreList  refile:/etc/opendkim/TrustedHosts
InternalHosts       refile:/etc/opendkim/TrustedHosts
EOF

sudo cat <<EOF > /etc/opendkim/TrustedHosts
127.0.0.1
::1
mail.seudominio.com
EOF

sudo echo "default._domainkey.seudominio.com seudominio.com:default:/etc/opendkim/keys/seudominio.com.private" > /etc/opendkim/KeyTable

sudo echo "*@seudominio.com default._domainkey.seudominio.com" > /etc/opendkim/SigningTable

sudo opendkim-genkey -D /etc/opendkim/keys/ -d seudominio.com -s seudominio.com

sudo cat <<EOF >> /etc/postfix/main.cf
echo milter_default_action = accept
smtpd_milters = inet:127.0.0.1:8891
EOF
```

## Reiniciar os serviços do Postfix

```bash
sudo systemctl restart spamassassin && sudo systemctl restart opendkim && sudo systemctl restart postfix
```

## Teste de envio de e-mail com cURL

```bash
curl --mail-from user1@domain.local --mail-rcpt user2@domain.local smtp://mail.domain.local
```

Uma vez que o comando acima foi inserido, ele irá aguardar a entrada do usuário para envio do e-mail. Uma vez que a mensagem for concluída, digite "." (sem aspas) na última linha e tecle Enter para que o e-mail seja enviado imediatamente.

```bash
Subject: Teste
Este é um e-mail de teste.
.
```

## Teste de envio de e-mail com Telnet

```bash
telnet mail.domain.local 25
EHLO mpes.mp.br
mail from:user1@domain.local
rcpt to:user2@domain.local
DATA
Subject:Teste
Este é um e-mail de teste.
.
```
