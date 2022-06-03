#!/bin/sh
rm -rf /etc/xray/config.json
cat << EOF > /etc/xray/config.json
{
  "inbounds": [
    {
      "port": $PORT,
      "protocol": "vless",
      "settings": {
        "decryption": "none",
        "clients": [
          {
            "id": "$UUID"
          }
        ]
      },
      "streamSettings": {
        "network": "ws"
      },
      "sniffing": {
                "enabled": true,
                "destOverride": [
                     "http",
                     "tls"
                ]
            }
},
    {
      "port": $PORT,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "$UUID"
          }
        ] 
      },
      "streamSettings": {
        "network": "ws"
      },
      "sniffing": {
                "enabled": true,
                "destOverride": [
                     "http",
                     "tls"
                ]
            }
},
    {
      "port": $PORT,
      "protocol": "trojan",
      "settings": {
        "clients": [
          {
            "password": "$UUID"
          }
        ]
      },
      "streamSettings": {
        "network": "ws"
      },
      "sniffing": {
                "enabled": true,
                "destOverride": [
                     "http",
                     "tls"
                ]
            }
    }
  ],
  "routing": {
        "domainStrategy": "IPIfNonMatch",
        "domainMatcher": "mph",
        "rules": [
           {
              "type": "field",
              "protocol": [
                 "bittorrent"
              ],
              "domains": [
                  "geosite:cn",
                  "geosite:category-ads-all"
              ],
              "outboundTag": "blocked"
           }
        ]
    },
    "outbounds": [
        {
            "protocol": "freedom",
            "settings": {
               "domainStrategy": "UseIPv4",
               "userLevel": 0
            }
        },
        {
            "protocol": "blackhole",
            "tag": "blocked"
        }
    ],
    "dns": {
        "servers": [
            {
                "address": "https+local://dns.google/dns-query",
                "address": "https+local://cloudflare-dns.com/dns-query",
                "skipFallback": true
            }
        ],
        "queryStrategy": "UseIPv4",
        "disableCache": true,
        "disableFallbackIfMatch": true
    }
}
EOF
xray -c /etc/xray/config.json
