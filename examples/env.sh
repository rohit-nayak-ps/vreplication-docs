hostname=$(hostname -f)
vtctld_web_port=25000
export VTDATAROOT="/home/rohit/vtdataroot2/"
export VT_MYSQL_ROOT="/home/rohit/opt/mysql/8.0.21"
function fail() {
  echo "ERROR: $1"
  exit 1
}

if [[ $EUID -eq 0 ]]; then
  fail "This script refuses to be run as root. Please switch to a regular user."
fi

# mysqld might be in /usr/sbin which will not be in the default PATH
PATH="/usr/sbin:$PATH"
for binary in mysqld etcd etcdctl curl vtctlclient vttablet vtgate vtctld mysqlctl; do
  command -v "$binary" > /dev/null || fail "${binary} is not installed in PATH. See https://vitess.io/docs/get-started/local/ for install instructions."
done;

export ETCD_SERVER="localhost:12379"
export TOPOLOGY_FLAGS="--topo_implementation etcd2 --topo_global_server_address $ETCD_SERVER --topo_global_root /vitess/global"

mkdir -p "${VTDATAROOT}/etcd2"

mkdir -p "${VTDATAROOT}/tmp"

alias mysql="command mysql -h 127.0.0.1 -P 25306"
alias vtctlclient="command vtctlclient --server localhost:25999 --log_dir ${VTDATAROOT}/tmp"

# Make sure aliases are expanded in non-interactive shell
shopt -s expand_aliases

export MYSQL="command mysql -h 127.0.0.1 -P 25306"
export LVTCTL="command vtctlclient --server localhost:25999 --log_dir ${VTDATAROOT}/tmp"
