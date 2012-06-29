name        'systemwide'
description 'top level attributes, applies to all nodes'

run_list *%w[
  build-essential
  motd
  zsh
  emacs
  ntp
  ]

default_attributes({
  :java        => { # use openjdk
    :install_flavor => 'openjdk',
    :jdk_version => 6
  },
})
