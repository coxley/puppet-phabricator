class phabricator::apache (
    $phabricator_path,
    $timezone,
) {
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

    # Apache, meet Phabricator.
    apache::vhost { 'phabricator':
        port => '80',
        docroot => "${phabricator_path}/webroot",
        rewrites => [ {
            rewrite_rule => [
                '^/rsrc/(.*)     -                       [L,QSA]',
                '^/favicon.ico   -                       [L,QSA]',
                '^(.*)$          /index.php?__path__=$1  [B,L,QSA]',
            ]
        } ],
        php_admin_values => {
            "date.timezone" => "${timezone}",
        },
        php_admin_flags => {
            "apc.stat" => false,
        },
    }
}
