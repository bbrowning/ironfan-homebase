#
# TorqueBox cluster
#
Ironfan.cluster 'torquebox' do
  cloud(:ec2) do
    defaults
    permanent           false
    availability_zones ['us-east-1d']
    flavor              'm1.large'
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
    instances           2

    role                :torquebox
  end

  facet :frontend do
    instances           1

    role                :mod_cluster
  end

  cluster_role.override_attributes({
    })

  facet(:backend).facet_role.override_attributes({
    :torquebox => {
      :bind_ip => ["cloud", "local_ipv4"],
      :clustered => true,
      :mod_cluster_mcpm_port => 6666
      }
    })

    facet(:frontend).facet_role.override_attributes({
    :mod_cluster => {
      :mcpm_bind_ip => ["cloud", "local_ipv4"],
      :mcpm_port => 6666,
      :clustered => true
      }
    })
end
