# Samba 4 como membro do domínio

## Sobre o Samba 4

Um membro do domínio é uma máquina Linux associada a um domínio que executa o Samba 4 e não fornece serviços de controlador de domínio, tanto como controlador de domínio primário (PDC) ou secundário (BDC) NT4 ou como controlador de domínio do Active Directory (AD).

Em um membro do domínio Samba, você pode:

- Usar usuários e grupos de domínio em ACLs locais em arquivos e diretórios
- Configurar compartilhamentos para atuar como um servidor de arquivos
- Configurar impressoras compartilhadas para atuar como um servidor de impressão
- Configurar o PAM para permitir que os usuários do domínio façam logon localmente ou se autentiquem nos serviços locais instalados

## Instalação do Samba 4 como membro do domínio

1. Instale o Samba 4

    ```yum install realmd oddjob-mkhomedir oddjob samba-winbind-clients samba-winbind samba-common-tools samba samba-winbind-krb5-locator```

2. Configure o /etc/resolv.conf
3. Valide a resolução de nomes
4. Configure a sincronização de tempo
5. Instale o Samba 4
6. Adicione o servidor ao domínio

    ```realm join --client-software=winbind Samba4AD1.seudominio.corp```

## Configurar um servidor de arquivos

O Samba 4 já deve estar instalado e o servidor já deve estar adicionado ao domínio para que os demais passos abaixo possam ser seguidos.

Após realizar a configuração do servidor, as pemissões podem ser dadas através do MMC de Gerenciamento do Computador através de uma estação de trabalho Windows.

1. Conceda privilégio ao grupo Admins. Do Domínio

    ```net rpc rights grant "SEUDOMINIO\Domain Admins" SeDiskOperatorPrivilege -U "SEUDOMINIO\administrator"```

2. Crie o diretório raíz para seu File Server:

    ```sudo mkdir -p /srv/samba/FileServer/```

    ```chown root:"Domain Admins" /srv/samba/FileServer/```

    ```chmod 0770 /srv/samba/FileServer/```

3. Adicione o compartilhamento [FileServer] ao seu arquivo ```smb.conf```

    ```
    [FileServer]
        path = /srv/samba/FileServer/
        read only = no
    ```

4. Recarregue as configurações do Samba 4

    ```smbcontrol all reload-config```

## Implantação do Samba 4 como servidor de impressão

O Samba 4 já deve estar instalado e o servidor já deve estar adicionado ao domínio para que os demais passos abaixo possam ser seguidos.

Após realizar a configuração do servidor, as pemissões podem ser dadas através do MMC de Gerenciamento de Impressoras através de uma estação de trabalho Windows.

1. Instale o CUPS

    ```yum -y install cups```

2. Conceda privilégio ao grupo Admins. Do Domínio

    ```net rpc rights grant "SEUDOMINIO\Domain Admins" SePrintOperatorPrivilege -U "SEUDOMINIO\administrator"```

3. Crie os diretórios necessários para o funcionamento do CUPS:

    ```mkdir -p /var/spool/samba/```

    ```chmod 1777 /var/spool/samba/```

    ```mkdir -p /srv/samba/printer_drivers/```

    ```chgrp -R "SAMDOM\Domain Admins" /srv/samba/printer_drivers/```

    ```chmod -R 2775 /srv/samba/printer_drivers/```

    ```chmod 755 /usr/local/bin/Pdfprint.sh```

4. Habilite o serviço ```spoolssd``` editando a sessão [global] no arquivo ```smb.conf```

    ```
    rpc_server:spoolss = external
    rpc_daemon:spoolssd = fork
    spoolss: architecture = Windows x64
    printing = CUPS
    ```

5. Edite a sessão [printers] no seu arquivo ```smb.conf```

    ```
    [printers]
        path = /var/spool/samba/
        printable = yes

    [PDFprinter]
            comment = Samba Virtual PDF Printer
            path = /var/spool/samba
            printable = Yes
            lpq command =
            lprm command =
            print command = /usr/local/bin/Pdfprint.sh -s /var/spool/samba/%s -d /home/%U -o %U -m 600

    [print$]
        path = /srv/samba/printer_drivers/
        read only = no
    ```

6. Recarregue as configurações do Samba 4

    ```smbcontrol all reload-config```

**OBS**: Para adicionar novas impressoras, abra a interface web do CUPS pelo seu navegador. Exemplo: <https://SambaPrintSrv:631/admin>
