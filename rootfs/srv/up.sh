#!/usr/bin/with-contenv /bin/sh
set -eu

# Init database

chown -R shepherd.nogroup /srv/shepherd
cd /srv/shepherd
[ -e "/local/venv_shepherd/bin/activate" ] && . /local/venv_shepherd/bin/activate
init-flask-db.sh shepherd apluslms_shepherd
# wait for it to start
while ! setuidgid shepherd psql "--command=SELECT version();" >/dev/null 2>&1; do
    sleep 0.2
done
# Starting secondary services 
start_services shepherd-broker shepherd-celery-worker
# Starting main server
setuidgid shepherd python3 app.py
#setuidgid shepherd gunicorn --worker-class eventlet -b 0.0.0.0:5000 -w 1 app:app --daemon --log-level debug

