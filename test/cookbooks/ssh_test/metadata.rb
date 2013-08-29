name             'ssh_test'
maintainer       'Mark Olson'
maintainer_email 'theothermarkolson@gmail.com'
license          'All rights reserved'
description      'Runs some tests for Chef-SSH'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'


depends 'ssh'
depends 'ohai'