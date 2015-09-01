# Chef SSH

## Description

Provides 3 LWRPs to manage system-wide and per-user `ssh_config` and `known_host` files.

## Setup

Include the `ssh` cookbook via Berkshelf or Librarian.

    cookbook "ssh"

Or add the following line to your cookbook's `metadata.rb`.

    depends "ssh"

## Usage

When using SSH with Chef deployments, it's crucial to not get any prompts for input. Adding entries to `known_hosts` files and better managing your per-connection configuration can help with this.

An important thing to note is that if you create a user during a chef run, be sure to reload OHAI data so that the new user will be in the node data. For instance:

    ohai "reload_passwd" do
        plugin "passwd"
    end

The ssh cookbook bypasses this need somewhat by using ohai classes directly to discover your users' ssh paths.  However
some of your cookbooks may not be as generous.

## Resources and Providers

### known_hosts

#### Actions

<table>
  <thead>
    <tr>
      <th>Action</th><th>Description</th><th>Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>add</td>
      <td>Adds an entry for the given host to a `known_hosts` file</td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>remove</td>
      <td>Removes entries for a host from a `known_hosts` file</td>
      <td>&nbsp;</td>
  </tbody>
</table>

#### Attributes

<table>
  <thead>
    <tr>
      <th>Attribute</th><th>Description</th><th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>host</td>
      <td>
        <b>Name attribute:</b> the FQDN for a host to add to a `known_hosts` file
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>hashed</td>
      <td>A Boolean indicating if SSH is configured to use a hashed `known_hosts` file.
      </td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td>key</td>
      <td>A full line to add to the file, instead of performing a lookup for the host.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>user</td>
      <td>A username to add the `known_hosts` entry for. If unspecified, the known_host will be added system-wide. <b>Note:</b> if specified, the user
        must already exist.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>path</td>
      <td>A full path to a known_hosts file. If used with the `user` attribute, this will take precedence over the path to a user's file, but the file will be created (if necessary) as that user.
      </td>
      <td><code>nil</code></td>
    </tr>
  </tbody>
</table>

#### Example

    ssh_known_hosts "github.com" do
      hashed true
      user 'webapp'
    end


### config

#### Actions

<table>
  <thead>
    <tr>
      <th>Action</th><th>Description</th><th>Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>add</td>
      <td>Adds an entry for the given host to a `ssh_config` file</td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>remove</td>
      <td>Removes entries for a host from a `ssh_config` file</td>
      <td>&nbsp;</td>
  </tbody>
</table>

#### Attributes

<table>
  <thead>
    <tr>
      <th>Attribute</th><th>Description</th><th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>host</td>
      <td>
        <b>Name attribute:</b> the string to match when connecting to a host. This can be an IP, FQDN (github.com), or contain wildcards (*.prod.corp)
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>options</td>
      <td>A hash containing the key-values to write for the host in
      </td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td>user</td>
      <td>A username to add the `ssh_config` entry for. If unspecified, the entry will be added system-wide. <b>Note:</b> if specified, the user
        must already exist.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>path</td>
      <td>A full path to a ssh config file. If used with the `user` attribute, this will take precedence over the path to a user's file, but the file will be created (if necessary) as that user.
      </td>
      <td><code>nil</code></td>
    </tr>
  </tbody>
</table>

#### Example

    ssh_config "github.com" do
      options 'User' => 'git', 'IdentityFile' => '/var/apps/github_deploy_key'
      user 'webapp'
    end

### authorized_keys
The authorized_keys LWRP is considered _Beta_ due to the lack of tests for this resource.  Use at your own risk,
and feel free to submit a PR for adding more tests.

Also of important note, typically when SSH keys are generated, the resulting file will have the type, key, and a comment.
The typical comment is just the `username@host`.  This is __NOT__ part of the key.  When setting your attributes,
please be sure to set only the key in the `key` field.  See the example if you are still uncertain.

#### Actions

<table>
  <thead>
    <tr>
      <th>Action</th><th>Description</th><th>Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>add</td>
      <td>Adds an entry to the given user's authorized_keys file</td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>remove</td>
      <td>Removes an entry from the given user's authorized_keys file</td>
      <td>&nbsp;</td>
    <\tr>
    <tr>
      <td>modify</td>
      <td>Updates an existing entry to the user's authorized_keys file, but only if the indicated `key` is present</td>
      <td>&nbsp;</td>
    <\tr>
  </tbody>
</table>

__* please note that there is no `name` attribute for this resource.  The name you assign is not used in the provider__

#### Attributes

<table>
  <thead>
    <tr>
      <th>Attribute</th><th>Description</th><th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>type</td>
      <td>
        A string representing the type of key.  Options include `id-rsa, ssh-dss, ssh-ed25519` and others
      </td>
      <td><code>id-rsa</code></td>
    </tr>
    <tr>
      <td>options</td>
      <td>
        A hash containing the key-value pairs for options.  Binary options such as `no-port-forwarding` should have a value of `nil`
      </td>
      <td><code>{}</code></td>
    </tr>
    <tr>
      <td>user</td>
      <td>
        The user for which this key should be added
      </td>
      <td>none - __REQUIRED__</td>
    </tr>
     <tr>
      <td>comment</td>
      <td>
        a comment to add to this entry (generally the `useranme@host` is added as a comment, but this is not required)
      </td>
      <td><code>''</code></td>
    </tr>
    <tr>
      <td>key</td>
      <td>
        the actual key
      </td>
      <td>none - __REQUIRED__</td>
    </tr>
  </tbody>
</table>

#### Example

<syntaxhightlight lang="ruby">
ssh_authorized_key "for remote access" do
  options { 'cert-authority' => nil, :command => '/usr/bin/startup' }
  user 'admin'
  key 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDzB76TOkrDRaevO3I1qzosRXliAuYdjcMejHwwL5v2hRqTrBePlMW6nqz8/JgLTzHn/KxzkrKLb0GlpPDrJ1KByWGYZsfydUfv7n1+5ogoA7UW7dUc4DoQtGPuy4Xe0enr88VfALlT11aWKAw8K/I39zWiPvJNX3Mks0f3/3smjLaQEnDWWWiawp5YgzJmyzsqZFZrrFCUgv7AP1EjZofWUcRvYEEjMhKsK+G2H2VCN7MpH0cJ97E0bKNQjHBrwGyMLQZUOndGakCuOuTLpikOXSpUUz5LwqCiRIj6iUtWevwk+AYLZwxPYQpCxFceVFDhPDaJQ85vweSq+HEg7hRujq9jO7vM9LIgjqg7fwQ2Ql6zO9NjXv2UalzBi0H2AbKT1V/PpNufPgolyb/dK7Jqpqu7Ytggctl2fGyLe8yVaC9gD+/BBeCl82LZI142kdXmf4WYcZgOgcRgGJrbSZjeMzX6zZpiD1AG3T7xyEn2twmC/TqptmQEAG2BBzGum+S6pU0rnOt2UJngRnviK2vptAWtRlSlsopySOXv+VbqUXhRjHRT/+2nq5Q4BWcjsZaaoo1uWh2glATRnGK995A1zJ3gWrBA+IaC6stKzjSG0KPwLjzHfPKbWjDX76D/qdo0qBN5hBiHDRfmiNqpNYS9NHACDZNVPBS5N1d5BUkyKw=='
  type 'id-rsa'
  comment 'gdidy@coolman.com'
end
</syntaxhighlight>
