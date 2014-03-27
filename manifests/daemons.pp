class phabricator::daemons (
    $phabricator_path,
) {
    # Run Phabricator daemons
    file { '/etc/init.d/phabricator':
        ensure => 'symlink',
        target => "${phabricator_path}/bin/phd",
        owner => 'root',
        group => 'root',
        mode => '0755',
        before => Service['phabricator'],
    }

    service { 'phabricator':
        ensure => 'running',
        enable => true,
        hasstatus => 'true',
        hasrestart => 'true',
    }
}
