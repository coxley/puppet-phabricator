# phabricator

## What is it?

A [Puppet][1] module to install and manage [Phabricator][2].

## How do I use it?

### Make a development VM

Install [Vagrant][5]. Then,

    vagrant up

Now visit [http://127.0.0.1:8080/][4].

### Provision a machine with Puppet

Include this in your manifest:

    class { 'phabricator': }

This module will download and install the [latest Phabricator from GitHub][3].
Most things will be installed and configured, including PHP, MySQL, and Apache.
There are a couple options to configure things that are mostly
self-explanatory, but you will have to read the source to figure out what they
are. Sorry.

Phabricator configuration items can be incanted as such:

    phabricator::config { 'phabricator.some_setting':
        value => "value",
    }

## Supported platforms

  - Ubuntu 12.04 LTS (Precise Pangolin)
  - Ubuntu 13.10 (Saucy Salamander)

## To-do

Testing could be greatly improved.

The options available to class `phabricator` could be documented.

`phabricator::config` will log an action on each puppet run. The underlying
commands it executes are idempotent, so this isn't a problem per se, but the
noise is distracting.

## Patches, bug reports, etc.

Please submit through GitHub.


  [1]: http://puppetlabs.com/
  [2]: http://phabricator.org/
  [3]: https://github.com/facebook/phabricator
  [4]: http://127.0.0.1:8080/
  [5]: http://www.vagrantup.com/
