class phabricator::install_deps (
  $mysql_options = {
    'mysqld' => {
      'sql-mode' => 'STRICT_ALL_TABLES',
    }
  }
){
    # PHP modules required by Phabricator
    package { [
        'php5-gd',
        'php5-mysql',
        'php-apc',
        'php5-ldap',
    ]:
        ensure => 'installed',
        notify => Service['httpd'],

        # the PHP packages we are installing have a virtual dependency on "some
        # kind of PHP runtime". By installing php5-cli first, we don't give apt
        # the opportunity to arbitrarilly pick a runtime for us, which in
        # practice works out to php5-fpm, which we don't want.
        require => Package['php5-cli'],
    }

    # I heard Phabricator also needs a database.
    Anchor['phabricator::begin'] ->
    class { '::mysql::server':
        override_options => $mysql_options,
        # it's OK to restart mysql after my.cnf is configured by puppet
        restart => true,
    } ->
    Anchor['phabricator::end']
}
