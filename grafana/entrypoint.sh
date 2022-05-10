#!/bin/sh -e

until mysql -h "${HOST}" -u"${USERNAME}" -p"${PASSWORD}" -P"${PORT}" "${NAME}"; do
  >&2 echo "waiting for MariaDB to be ready..."
  sleep 1
done

/run.sh
