class phabricator::install_apache {
    # Install apache, without any default configuration (we will do that).
    class { '::apache':
        mpm_module => 'prefork',  # mod_php needs mpm_prefork
        default_vhost => false,
        default_mods => false,
        default_confd_files => false,
    }

    # Apache modules required by Phabricator
    class { '::apache::mod::php': }
    class { '::apache::mod::rewrite': }
    class { '::apache::mod::ssl': }
}
