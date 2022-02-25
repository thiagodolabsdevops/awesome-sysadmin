# Samba + FreeRADIUS

Pré-requisitos:

- hostnames configurados (não poderá ser trocado posteriormente)
- sufixo DNS configurado (não poderá ser trocado posteriormente - será utilizado como nome do domínio)
- resolução de nome corretamente configurada para resolver o nome do domínio do Samba AD DC

Configuração do ambiente:

- Sistema Operacional: Ubuntu 18.04+
- Domain: CORP
- Kerberos Realm: CORP.LOCAL
- Kerberos servers: addc1.corp.local

**OBS**: todos os comandos demonstrados neste documento foram executados com privilégios elevados (sudo)

1. Instale os pacotes necessários

    ```bash
    # apt -y install samba krb5-config winbind smbclient
    ```

2. Configure o Samba AD DC

    ```bash
    # mv /etc/samba/smb.conf /etc/samba/smb.conf.orig
    # samba-tool domain provision
    Realm:  CORP.LOCAL
    Domain [CORP]:  
    Server Role (dc, member, standalone) [dc]:  
    DNS backend (SAMBA_INTERNAL, BIND9_FLATFILE, BIND9_DLZ, NONE) [SAMBA_INTERNAL]:  
    DNS forwarder IP address (write 'none' to disable forwarding) [127.0.0.53]:  
    Administrator password: 
    Retype password: 
    ```

    Siga o assistente e complete a configuração do Samba.

3. Copie as configurações do Kerberos geradas pelo assistente para /etc

    ```cp -rf /var/lib/samba/private/krb5.conf /etc```

4. Configure o serviço do Samba AD DC

    ```bash
    systemctl stop smbd nmbd winbind systemd-resolved
    systemctl disable smbd nmbd winbind systemd-resolved
    systemctl unmask samba-ad-dc
    systemctl start samba-ad-dc
    systemctl enable samba-ad-dc
    ```

5. Reinicie o servidor Samba AD DC

6. Após o reboot, seu Samba AD DC está pronto para uso e pode ser administrado através de uma estação Windows com o RSAT instalado.

---

## FreeRADIUS

1. Instale os pacotes necessários para adicionar o servidor FreeRADIUS ao domínio

    ```bash
    # apt -y install winbind libpam-winbind libnss-winbind krb5-config
    ```

2. Inclua o servidor no domínio Samba AD DC

    ```bash
    net ads join -U Administrator%P@ssw0rd
    systemctl restart winbind
    ```

3. Confira se o servidor FreeRADIUS consegue realizar consultas ao domínio através do winbind através do comando ```wbinfo -a```

4. Instale os pacotes do FreeRADIUS

    ```bash
    # apt -y install freeradius freeradius-ldap
    ```
