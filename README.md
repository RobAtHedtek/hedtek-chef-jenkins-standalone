Chef Cookbook Jenkins (Standalone)
==============================

Continuous integration with a twist: each Jenkins instance is installed as a standalone runnable, 
adding a little flexibility.

Maturity &mdash; `pre-alpha`

Defining Jobs
-------------

The Jenkins jobs are generated using a list of meta-data declared in the `'jobs'` attribute. 

The version of Jenkins installed is control through the `minor` and `major` attribute of `jenkins`. 
For example, to default the jenkins version to 1.464 use

   default['jenkins'] = {
      :major => 1,
      :minor => 464
   } 

Development
-----------
* Development configurations for solo-chef are in `config`
* Some potentially useful helpers are in `scripts`

To run in development mode:

    chef-solo --config config/chef-solo-config.rb --json-attributes config/from-jenkyns-run-default.json
  
which will install into the `tmp` sub-directory.  

Start the server by `tmp/jenkins.sh`.