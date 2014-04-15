class phabricator::install_phabricator (
    $phabricator_path = '/usr/local/src/phabricator',
    $libphutil_path = '/usr/local/src/libphutil',
    $arcanist_path = '/usr/local/src/arcanist',
) {
    include 'git'

    Anchor['phabricator::begin'] ->
    class { 'arcanist':
        libphutil_path => $libphutil_path,
        arcanist_path => $arcanist_path,
    } ->
    Anchor['phabricator::end']

    vcsrepo { $phabricator_path:
        ensure => 'present',
        provider => 'git',
        source => 'git://github.com/facebook/phabricator.git',
    }

    # Create the database for Phabricator.
    $storage_bin = "${phabricator_path}/bin/storage"

    exec { 'install phabricator database':
        command => shellquote($storage_bin, 'upgrade', '-f'),
        unless => shellquote($storage_bin, 'status'),
        subscribe => Vcsrepo[$phabricator_path],
    }
}
