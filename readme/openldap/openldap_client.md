# OpenLDAP client

We will install few packages in the client machine to make authentication function correctly with an OpenLDAP server.

```bash
# apt install ldap-auth-client nscd
```

You will be asked a series of questions similar to what was asked during server configuration.

- LDAP server Uniform Resource Identifier: <ldap://ldap.meudominio.com>
- Distinguished name of the search base: <dc=meudominio,dc=com>
- LDAP version: <3>
- Make local root Database admin: Yes
- Does the LDAP database require login? No
- LDAP account for root: <cn=admin,dc=meudominio,dc=com>
- LDAP root account password: <P@ssw0rd>

You can always change the configuration by executing the following command in the terminal.

```bash
#  sudo dpkg-reconfigure ldap-auth-config
```

## Configuration

We need to edit the file /etc/nsswitch.conf to inform the authentication files about the presence of a OpenLDAP server. Edit /etc/nsswitch.conf file and modify the lines that starts with passwd, group, shadow to look like the below.

```bash
# vim /etc/nsswitch.conf
passwd:         ldap compat
group:          ldap compat
shadow:         ldap compat
```

Edit  /etc/pam.d/common-session and the following line at the end of the file.

```bash
# vim /etc/pam.d/common-session
....................
....................

session required        pam_mkhomedir.so skel=/etc/skel umask=0022
```

Setup nss using auth-client-config with ldap

```bash
# auth-client-config -t nss -p lac_ldap
# cd /usr/share/pam-configs/
# vi mkhomedir

Name: Create home directory on login for meudominio
Default: yes
Priority: 0
Session-Type: Additional
Session-Interactive-Only: yes
Session:
required                        pam_mkhomedir.so umask=0022 skel=/etc/skel
```

The last line of the above file will create a home directory on the client machine when an LDAP user logs in and does not have a home directory. Now update the pam authentication.

```bash
# pam-auth-update
```

Enable the line that says "Create home directory on login......" and select 'Ok'. Restart nscd.

```bash
# /etc/init.d/nscd restart
[ ok ] Restarting nscd (via systemctl): nscd.service.
```

List the entry of password file using getent. The list will include the LDAP user 'mike' which we have created earlier in the server.

```bash
# getent passwd
mike:x:4000:4000:mike:/home/mike:/bin/bash
```

If you have not installed SSH earlier then install it using SSH.

```bash
# apt install ssh
```

Make sure you have set the the following to yes in /etc/ssh/sshd_config

```bash
PermitRootLogin yes
UsePAM yes
```

Connect to the LDAP server using SSH

```bash
# ssh tmagalhaes@10.10.10.10
```

Another way to get the shell of tmagalhaes is by using sudo in the client machine.

```bash
# su - tmagalhaes
tmagalhaes@ip-10-10-10-10:~$
```

Ao configurar o servidor OpenLDAP, criamos o administrador LDAP com nome distinto ```cn=admin,dc=meudominio,dc=com```. Este valor admin corresponde ao grupo de administradores que existe no Ubuntu por padrão. Os usuários LDAP que criamos para o grupo admin terão acesso ao comando sudo, pois existe uma entrada no arquivo ```/etc/sudoers```, como abaixo:

```bash
%admin ALL=(ALL) ALL
```

Para revogar o acesso ao sudo para o grupo de administradores, basta comentar a linha acima colocando um hash (#) no início da linha. Você também pode conceder acesso ao sudo a um usuário específico adicionando ```%user ALL=(ALL) ALL``` ao arquivo ```/etc/sudoers```.
