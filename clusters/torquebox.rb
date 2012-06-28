#
# TorqueBox cluster
#
Ironfan.cluster 'torquebox' do
  cloud(:ec2) do
    defaults
    permanent           false
    availability_zones ['us-east-1d']
    flavor              't1.micro'
    backing             'ebs'
    image_name          'oneiric'
    bootstrap_distro    'ubuntu11.10-ironfan'
    chef_client_script  'client.rb'
    mount_ephemerals
  end

  environment           :dev

  role                  :systemwide
  role                  :chef_client
  role                  :ssh

  role                  :volumes
  role                  :package_set,   :last

  role                  :org_base
  role                  :org_users
  role                  :org_final,     :last

  role                  :tuning,        :last

  facet :backend do
    instances           1

    role                :torquebox
  end

  # facet :frontend do
  # end

  cluster_role.override_attributes({
    })

  facet(:backend).facet_role.override_attributes({
      :torquebox => { :bind_ip => ["cloud", "local_ipv4"] }
    })
end
