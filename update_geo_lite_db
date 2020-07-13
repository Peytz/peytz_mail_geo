#!/bin/bash
curl -o geo_ip.tar.gz 'https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country&license_key=y1H0pL9i0zOUoYNW&suffix=tar.gz'

tar -zxvf geo_ip.tar.gz
cp GeoLite2-Country_20200707/GeoLite2-Country.mmdb .

rm geo_ip.tar.gz
rm -r GeoLite2-Country_*
