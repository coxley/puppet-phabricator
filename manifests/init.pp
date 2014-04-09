class phabricator (
    $phabricator_path = '/usr/local/src/phabricator',
    $libphutil_path = '/usr/local/src/libphutil',
    $arcanist_path = '/usr/local/src/arcanist',
    $timezone = $::timezone,
    $repo_path = '/var/lib/repo',
    $base_uri = undef,
) {

    # Note: install_apache must come before install_deps, because if mod_php
    # isn't intsalled when php-apc is installed, then php5-fpm will be
    # installed to satisfy php-apc's dependency on a virtual package.
    class { 'phabricator::install_apache': } ->
    class { 'phabricator::install_deps': } ->
    class { 'phabricator::install_phabricator': } ->
    class { 'phabricator::configure_apache':
        phabricator_path => $phabricator_path,
        timezone => $timezone,
    } ->
    class { 'phabricator::configure_phabricator':
        repo_path => $repo_path,
        base_uri => $base_uri,
    } ->
    class { 'phabricator::daemons':
        phabricator_path => $phabricator_path,
    }
}
