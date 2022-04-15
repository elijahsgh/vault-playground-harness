cluster_addr = "http://localhost:8200"
api_addr = "http://localhost:8201"
disable_mlock = true
ui = true

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = true
}

storage "raft" {
  path    = "./"
  node_id = "node1"
}

log_level = "trace"
