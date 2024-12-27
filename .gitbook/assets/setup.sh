# start up stuff
service postgresql start
redis-server &
sudo service supervisor start
sudo service nginx restart

# this isn't how you'd do it outside a demo/trial
PGPASSWORD="ckan"
sudo -u postgres createuser -S -D -R ckan_default
sudo -u postgres createdb -O ckan_default ckan_default -E utf-8
sudo -u postgres psql -c "ALTER USER ckan_default WITH PASSWORD 'ckan';"
sudo ckan db init


