#!/bin/sh

user=$1
db=$2

if ! setuidgid "$user" psql -U "$user" "$db" "--command=SELECT version();" >/dev/null 2>&1; then
    echo "Creating role $user"
    setuidgid postgres createuser "$user"
    setuidgid postgres createdb "$user"
    setuidgid postgres createdb "$db" -O "$user"
    dbfile="/srv/db_$db.sql.gz"
    if [ -e "$dbfile" ]; then
        echo " .. Creating DB from $dbfile .."
        gunzip -c "$dbfile" | setuidgid "$user" psql -U "$user" "$db" >/dev/null
    else
        echo " .. Creating DB with migrate and setup script .."
        setuidgid "$user" flask db init
        setuidgid "$user" flask db migrate
        setuidgid "$user" flask db upgrade
    fi
else
        setuidgid "$user" flask db migrate
        setuidgid "$user" flask db upgrade
fi