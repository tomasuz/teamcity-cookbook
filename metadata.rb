name             'teamcity-cookbook'
maintainer       'uldis sturms'
maintainer_email 'uldis.sturms@gmail.com'
license          'apache license version 2.0'
description      'Installs and configures teamcity'
long_description 'Installs and configures teamcity CI in a completely unattended manner. Test first approach using test kitchen is used to prevent regressions.'
version          '0.1.2'

recipe 'teamcity-cookbook', 'Installs Teamcity server'

supports 'centos', '~> 7.0'

