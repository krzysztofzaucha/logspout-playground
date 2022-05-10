FROM grafana/grafana:master

#ADD etc/grafana/grafana.ini /etc/grafana/grafana.ini
ADD grafana/conf/provisioning/datasources/loki.yaml /etc/grafana/provisioning/datasources/loki.yaml
ADD grafana/conf/defaults.ini /usr/share/grafana/conf/defaults.ini
ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh
