# Class: datadog_agent::integrations::docker
#
# This class will install the necessary configuration for the docker integration
#
# Parameters:
#   $tags
#       Optional array of tags
#
# Sample Usage:
#
#   class { 'datadog_agent::integrations::docker' :
#   }
#
class datadog_agent::integrations::docker(
  $docker_root             = '/',
  $socket_timeout          = 5,
  $url                     = "unix://var/run/docker.sock",
  $new_tag_names           = true,
  $tag_by_command          = false,
  $tags                    = [],
  $include                 = [],
  $exclude                 = [],
  $collect_events          = true,
  $collect_container_size  = false,
  $collect_all_metrics     = false
) inherits datadog_agent::params {

  validate_string($docker_root)
  validate_re('^\d+$', $socket_timeout)
  validate_string($url)
  validate_bool($new_tag_names)
  validata_bool($tag_by_command)
  validate_array($tags)
  validate_array($include)
  validate_array($exclude)
  validate_bool($collect_events)
  validate_bool($collect_container_size)
  validate_bool($collect_all_metrics)
  
  file { "${datadog_agent::params::conf_dir}/docker.yaml":
    ensure  => file,
    owner   => $datadog_agent::params::dd_user,
    group   => $datadog_agent::params::dd_group,
    mode    => '0644',
    content => template('datadog_agent/agent-conf.d/docker.yaml.erb'),
    require => Package[$datadog_agent::params::package_name],
    notify  => Service[$datadog_agent::params::service_name]
  }
}
