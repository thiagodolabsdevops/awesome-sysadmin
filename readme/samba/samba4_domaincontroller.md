# Samba 4 como controlador de domínio

## Sobre o Samba 4

O Samba é um conjunto Software que fornece serviços de arquivo e impressão para clientes SMB/CIFS, incluindo sistemas operacionais Microsoft Windows. O Samba está disponível gratuitamente sob a Licença Pública Geral GNU.

O Samba é um componente importante para integrar servidores e desktops Linux/Unix em ambientes do Active Directory. Pode funcionar como um controlador de domínio ou como um servidor membro do domínio.

Em um ambiente de produção, é recomendável executar dois ou mais controladores de domínio para obter alta disponibilidade.

## Planejamento da instalação

1. Selecione um nome de host para seu AD DC. Não use termos NT4 como nome do host (como PDC ou BDC). Esses modos não existem no Active Directory e podem causar confusão.
2. Selecione um domínio DNS para sua floresta do AD. O nome também será usado como o domínio Kerberos do AD. Este domínio DNS não poderá ser alterado posteriormente. Não use domínios DNS com TLD .local, pois este TLD é usado pelo daemon do Avahi.
3. Defina um endereço IP estático no DC.
4. Desabilite ferramentas que atualizem automaticamente seu /etc/resolv.conf. DCs e membros do domínio devem apontar para servidor DNS capazes de resolver as zonas DNS do AD.

## Instalação do Samba 4 como controlador de domínio

1. Configure o repositório EPEL

    RHEL/CentOS 6:

    ```yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm```

    RHEL/CentOS7:

    ```yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm```

    ```subscription-manager repos --enable "rhel-*-optional-rpms" --enable "rhel-*-extras-rpms"  --enable "rhel-ha-for-rhel-*-server-rpms"```

2. Instale os pré-requisitos

    ```yum -y install attr bind-utils docbook-style-xsl gcc gdb krb5-workstation libsemanage-python libxslt perl perl-ExtUtils-MakeMaker perl-Parse-Yapp perl-Test-Base pkgconfig policycoreutils-python python2-crypto gnutls-devel libattr-devel keyutils-libs-devel libacl-devel libaio-devel libblkid-devel libxml2-devel openldap-devel pam-devel popt-devel python-devel readline-devel zlib-devel systemd-devel lmdb-devel jansson-devel gpgme-devel pygpgme libarchive-devel```

3. Instale o Samba 4

    ```yum -y install samba```

4. Provisione o domínio do AD

    ```samba-tool domain provision --server-role=dc --use-rfc2307 --dns-backend=SAMBA_INTERNAL --realm=seudominio.corp --domain=SEUDOMINIO --adminpass=P@ssw0rd```

5. Configure o arquivo ```/etc/resolv.conf```

    ```bash
    search seudominio.corp # substituir pelo nome DNS do seu dominio
    nameserver 192.168.0.10 # substituir pelo IP do seu servidor Samba 4 AD
    ```

6. Crie uma zona DNS de pesquisa reversa

    ```samba-tool dns zonecreate 192.168.0.10 0.168.192.in-addr.arpa```

    **OBS**: Novamente, substitua o IP 192.168.0.10 pelo IP do seu Samba 4 AD, e 0.168.192.in-addr.arpa pela faixa de rede utilizada na sua infraestrutura.

7. Inicialize seu controlador de domínio Samba 4

    ```samba```

8. Configure a sincronização de hora com uma fonte externa

    Instale o chrony:

    ```yum -y install chrony```

9. Configure o arquivo ```/etc/chrony/chrony.conf```

    ```bash
    echo "keyfile /etc/chrony/chrony.keys
    driftfile /var/lib/chrony/chrony.drift
    logdir /var/log/chrony
    maxupdateskew 100.0
    hwclockfile /etc/adjtime
    rtcsync
    makestep 1 3
    bindcmdaddress 192.168.0.10 # IP do Samba 4 AD
    server br.pool.ntp.org     iburst
    allow 192.168.0.0/24 # dns netmask
    ntpsigndsocket  /usr/local/samba/var/lib/ntp_signd" > /etc/chrony/ chrony.conf
    ```

 10. Configure o chrony para inicializar junto do sistema e reinicie o serviço:

    ```systemctl enable chronyd && systemctl restart chronyd```

## Validando a implantação

1. Liste os compartilhamentos ```netlogon``` e ```sysvol```

    ```smbclient -L localhost -U%```

2. Verifique a autenticação conectando ao compartilhamento ```netlogon```

    ```smbclient //localhost/netlogon -U Administrator -c 'ls'```

3. Verifique a resolução de nomes DNS

    ```host -t SRV _ldap._tcp.seudominio.corp.```

    ```host -t SRV _kerberos._tcp.seudominio.corp.```

    ```host -t A Samba4DC1.seudominio.corp.```

    **OBS**: Substitua seudominio.corp pelo nome DNS do seu domínio e Samba4DC1 pelo hostname do seu controlador de domínio Samba 4.

4. Verifique o funcionamento do Kerberos solicitando um ticket e listando os tickets em cache

    ```kinit administrator && klist```
