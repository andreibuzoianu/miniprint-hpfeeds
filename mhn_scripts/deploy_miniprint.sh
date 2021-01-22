set -e
set -x
if [ $# -ne 2 ]
    then
        echo "Wrong number of arguments supplied."
        echo "Usage: $0 <server_url> <deploy_key>."
        exit 1
fi
server_url=$1
deploy_key=$2
wget $server_url/static/registration.txt -O registration.sh
chmod 755 registration.sh
# Note: this will export the HPF_* variables
. ./registration.sh $server_url $deploy_key "miniprint"

cd /opt
git clone https://github.com/andreibuzoianu/miniprint-hpfeeds
cd miniprint-hpfeeds
git checkout master
cat > hpf_conf.py <<EOF
HPF_ENABLED = True
HPF_HOST = '$HPF_HOST'
HPF_PORT = $HPF_PORT
HPF_IDENT = '$HPF_IDENT'
HPF_SECRET = '$HPF_SECRET'
HPF_CHAN = 'miniprint.events'
EOF
pip3 install --user virtualenv
python3 -m virtualenv venv && source ./venv/bin/activate
pip3 install -r requirements.txt

cat > /etc/supervisor/conf.d/miniprint-hpfeeds.conf <<EOF
[program:miniprint-hpfeeds]
command=/opt/miniprint-hpfeeds/venv/bin/python /opt/miniprint-hpfeeds/server.py -b 0.0.0.0
directory=/opt/miniprint-hpfeeds
stdout_logfile=/opt/miniprint-hpfeeds/miniprint-hpfeeds.out
stderr_logfile=/opt/miniprint-hpfeeds/miniprint-hpfeeds.err
autostart=true
autorestart=true
redirect_stderr=true
stopsignal=QUIT
EOF