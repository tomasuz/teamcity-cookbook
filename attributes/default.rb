default['teamcity']['version'] = '2018.1.1'
default['teamcity']['service-name'] = 'teamcity-server'
default['teamcity']['service-group'] = 'teamcity'
default['teamcity']['service-username'] = 'teamcity'
default['teamcity']['accept-license'] = true
default['teamcity']['admin-username'] = 'teamcity'
default['teamcity']['admin-password'] = 'teamcity'
default['java']['jdk_version'] = 8
# possible :sysv and :systemd
default['teamcity']['init_style'] = :systemd
default['teamcity']['limitnofile'] = 4096
default['teamcity']['dbms'] = :postgresql
default['teamcity']['jdbcdriver'] = 'postgresql'
default['teamcity']['dbhost'] = 'localhost'
default['teamcity']['database'] = 'teamcity'
default['teamcity']['dbuser'] = 'teamcity'
default['teamcity']['dbpassword'] = 'teamcity'