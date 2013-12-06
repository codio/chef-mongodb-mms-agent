MongoDB Monitoring Service Agent
================================

Chef cookbook for the [MongoDB Monitoring System (MMS)](http://www.10gen.com/mongodb-monitoring-service)
agent. MMS is a hosted monitoring service, provided by 10gen, Inc. Once the small python agent
program is installed on the MongoDB host, it automatically collects the metrics and uploads them to
the MMS server. The graphs of these metrics are shown on the web page. It helps a lot for tackling
MongoDB related problems, so MMS is the baseline for all production MongoDB deployments.

NOTE: This cookbook only installs the MMS agent program, not MongoDB itself. Using this cookbook
together with edelight's great [MongoDB cookbook](https://github.com/edelight/chef-cookbooks) is
recommended.

This cookbook is based on [treasure-data/chef-mongodb-mms-agent](https://github.com/treasure-data/chef-mongodb-mms-agent).


## Recipes

### default

Installs and configures the MMS monitoring agent.

#### Attributes

API Key, and the Secret Key are required. Please get them at your [MMS Settings page](https://mms.10gen.com/settings).

- `node[:mms_agent][:api_key]` - Your MMS-Agent API key (required)
- `node[:mms_agent][:secret_key`] - Your MMS-Agent secret key (required)
- `node[:mms_agent][:user]` - The user to run MMS-agent as (default: `mmsagent`)
- `node[:mms_agent][:group]` - The group to run MMS-agent as (default: `mmsagent`)

If the encrypted data bag `keys/mms_agent` exists, then the `api_key` and `secret_key` will be used
from that.


### backup

Installs and configures the MMS backup agent v20131118.0.

#### Attributes

API Key is required. Please get it at your [MMS Settings page](https://mms.10gen.com/settings).

- `node[:mms_agent][:api_key]` - Your MMS-Agent API key (required)
- `node[:mms_agent][:user]` - The user to run MMS-agent as (default: `mmsagent`)
- `node[:mms_agent][:group]` - The group to run MMS-agent as (default: `mmsagent`)

If the encrypted data bag `keys/mms_agent` exists, then the `api_key` and `secret_key` will be used
from that.


### role

The mongodb-mms-agent role recipe which includes `monitor::master`, `mongodb-mms-agent::default`,
`mongodb-mms-agent::backup` and `base::default` recipes.


### Development

Cookbooks are strictly versioned, and the Chef server will lock and freeze each cookbook you upload.
This means that unless you bump the version number of the cookbook, the Chef server will not update
it when you upload.

All Codio servers belong to a Chef role and environment, and each environment *MUST* specify the
version which that environment will use. This protects that environment against new cookbooks
that may not yet be ready. Once they are ready, a simple edit of the environment will suffice.

In order to develop and test new cookbook versions, you will need to bump the version of the
cookbook just the once, and then upload that. Because the production environment uses specific
cookbook versions, you are safe to upload new version(s) and test these before eventually promoting
your new version to production.

Wherever possible, cookbooks should first be tested locally using Vagrant, and development should
take place in a branch. The cookbook minor version number should be incremented to ensure safe usage
of the Cookbook.


## Testing

Make sure you've installed the bundle with:

```bash
$ bundle install
```

Then start up `guard`, which will run both foodcritic to lint your code, and test-kitchen to run
your integration tests.

```bash
$ bundle exec guard
```

### With Vagrant

Install the Chef Zero Vagrant plugin and run Vagrant:

```bash
$ vagrant plugin install vagrant-chef-zero
$ vagrant up
```