class phabricator::install_apache {
    Anchor['phabricator::begin'] ->
    # Install apache, without any default configuration (we will do that).
    class { '::apache':
        mpm_module => 'prefork',  # mod_php needs mpm_prefork
        default_vhost => false,
        default_mods => false,
        default_confd_files => false,
    } ->
    Anchor['phabricator::end']

    # Apache modules required by Phabricator
    $modules = [
        '::apache::mod::php',
        '::apache::mod::rewrite',
        '::apache::mod::ssl',
    ]

    Anchor['phabricator::begin'] ->
    class { $modules: } ->
    Anchor['phabricator::end']
}
