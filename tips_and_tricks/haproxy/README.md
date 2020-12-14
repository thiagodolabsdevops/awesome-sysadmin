# HAProxy

![Proxy mode](haproxy-pmode.png)

## Balanceamento de carga

O balanceamento de carga consiste na agregação de vários componentes para obter uma capacidade de processamento total acima da capacidade individual de cada componente, sem qualquer intervenção do usuário final e de forma escalonável.

Em ambientes da Web, esses componentes são chamados de "balanceador de carga de rede", pois essa atividade é, de longe, o caso de uso mais comum.

## Configuração básica do HAProxy

```bash
# Configurações globais
global
        log         127.0.0.1 local2

        chroot      /var/lib/haproxy
        pidfile     /var/run/haproxy.pid

        # Quantidade máxima de conexões globais
        # O ideal é realizar um teste de carga com o Jmeter para definir este número
        maxconn     4000

        user        haproxy
        group       haproxy
        daemon

        # Habilita estatísticas via socket para o monitoramento
        stats socket /var/run/haproxy/info.sock mode 666 level user

defaults
        mode                    http
        log                     global
        option                  httplog
        option                  dontlognull
        option                  dontlog-normal
        option                  log-separate-errors
        option                  http-ignore-probes

        option                  redispatch
        retries                 3
        timeout http-request    10s
        timeout queue           2m
        timeout connect         10s
        timeout client          10m
        timeout server          10m
        timeout http-keep-alive 20s
        timeout check           10s
        maxconn                 3000

        option forwardfor

# Frontend HTTP redirect
frontend http
        bind *:80
        mode http

        acl is_reverseproxy hdr_sub(host) -i <FQDN>

        redirect scheme https code 301 if !{ ssl_fc } !is_reverseproxy

        use_backend reverseproxy if is_reverseproxy

# Frontend HTTPS
frontend https
        bind *:443 ssl crt /etc/ssl/private/wildcard.pem
        mode http

    acl is_reverseproxy hdr(host) -i <FQDN>

    use_backend reverseproxy if is_reverseproxy

# Defina múltiplos backends a partir daqui
backend reverseproxy
        balance roundrobin
        mode http
        option forwardfor
    http-request set-header X-Forwarded-Port %[dst_port]
        http-request add-header X-Forwarded-Proto https if { ssl_fc }
        # Defina quantos servidores forem necessários
        server HOSTNAME IPADDR:PORT
        server HOSTNAME IPADDR:PORT

# Fornece um ponto de estatísticas do HAProxy
listen haproxy-monitoring
        bind    *:9090
        mode    http
        stats   enable
        stats   show-legends
        stats   hide-version
        stats   show-node
        stats   refresh           10s
        stats   uri               /
        stats   realm             Haproxy\ Statistics
        stats   auth              monitor:monitor
        stats   admin             if TRUE
```
