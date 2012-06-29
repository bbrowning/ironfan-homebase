name        'mod_cluster'
description 'mod_cluster server'

run_list *%w[
  apache2
  mod_cluster::server
]
