#
# TorqueBox cluster
#
INCREMENTAL_BUILD_NUMBER=1114
Ironfan.cluster 'torquebox_incremental' do
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
    instances           3

    role                :torquebox
  end

  facet :frontend do
    instances           2

    role                :mod_cluster
  end

  cluster_role.override_attributes({
    })

  facet(:backend).facet_role.override_attributes({
    :torquebox => {
      :bind_ip => ["cloud", "local_ipv4"],
      :clustered => true,
      :mod_cluster_mcpm_port => 6666,
      :url => "http://torquebox.org/2x/builds/#{INCREMENTAL_BUILD_NUMBER}/torquebox-dist-bin.zip",
      :checksum => nil,
      :version => "2.x.incremental.#{INCREMENTAL_BUILD_NUMBER}",
      :ha_server_config_template => "standalone-ha-2.0.x-incremental.xml.erb"
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
