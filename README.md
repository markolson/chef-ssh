# Chef SSH

## Description

Provides 2 LWRPs to manage system-wide and per-user `ssh_config` and `known_host` files.

## Usage

When using SSH with Chef deployments, it's crucial to not get any prompts for input. Adding entries to `known_hosts` files and better managing your per-connection configuration can help with this.

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
      <td>A username to add the `ssh_config` entry for. If unspecified, the known_host will be added system-wide. <b>Note:</b> if specified, the user
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

    ssh_config "github.com" do
      options 'User' => 'git', 'IdentityFile' => '/var/apps/github_deploy_key'
      user 'webapp'
    end
