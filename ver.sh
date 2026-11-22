#!/bin/bash

cat /etc/hosts | while read -r ip nume
do
    if [[ -z "$ip" || "$ip" == \#* ]]; then
        continue
    fi

    if [[ "$ip" == *:* ]]; then
        continue
    fi

    if [[ "$ip" == 127.* ]]; then
        continue
    fi

    for domeniu in $nume
    do
        if [[ "$domeniu" == \#* ]]; then
            break
        fi

        ips=$(nslookup "$domeniu" 8.8.8.8 2>/dev/null | awk '
            /^Name:/ {gasit=1; next}
            gasit && /^Address:/ {print $2}')

        if ! grep -Fxq "$ip" <<< "$ips"; then
            echo "Bogus IP for $domeniu in /etc/hosts!"
        fi
    done
done
