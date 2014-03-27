define phabricator::config (
    $phabricator_path = '/usr/local/src/phabricator',
    $value,
) {
    exec { "set phabricator config $title":
        command => shellquote("${phabricator_path}/bin/config", "set", $title, $value),
        require => Vcsrepo[$phabricator_path],
    }
}
