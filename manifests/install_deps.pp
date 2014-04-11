class phabricator::install_deps {
    # PHP modules required by Phabricator
    package { [
        'php5-curl',
        'php5-gd',
        'php5-json',
        'php5-mysql',
        'php-apc',
    ]:
        ensure => 'installed',
        notify => Service['httpd'],

        # the PHP packages we are installing have a virtual dependency on "some
        # kind of PHP runtime". By installing php5-cli first, we don't give apt
        # the opportunity to arbitrarilly pick a runtime for us, which in
        # practice works out to php5-fpm, which we don't want.
        require => Package['php5-cli'],
    }

    # The CLI is needed for some of the administration commands.
    package { 'php5-cli':
        ensure => 'installed',
    }

    # Ubuntu disables pcntl_* functions in php.ini, but phabricator's daemons need them.
    exec { "/bin/sed '/^disable_functions = pcntl/d' -i.orig /etc/php5/cli/php.ini":
        creates => '/etc/php5/cli/php.ini.orig',
        require => Package['php5-cli'],
    }

    # I heard Phabricator also needs a database.
    Anchor['phabricator::begin'] ->
    class { '::mysql::server':
        override_options => {
            'mysqld' => {
                'sql-mode' => 'STRICT_ALL_TABLES',
            },
        },
        # it's OK to restart mysql after my.cnf is configured by puppet
        restart => true,
    } ->
    Anchor['phabricator::end']
}
