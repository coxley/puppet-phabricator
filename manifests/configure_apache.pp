class phabricator::configure_apache (
    $phabricator_path,
    $timezone,
    $port = 80,
) {
    # Apache, meet Phabricator.
    apache::vhost { 'phabricator':
        port => $port,
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
