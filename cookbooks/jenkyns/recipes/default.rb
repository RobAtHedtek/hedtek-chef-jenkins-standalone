#
# Copyright 2012 hedtek.com
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
user = node['jenkins-user']
home = node['jenkins-home']
   
log("Welcome to Jenkyns. Working in #{home} as #{user}") { level :info }
directory home do
  owner user
  action :create
end

#
# Distributes Jenkins, ready to run as a war.
#
jenkins_version = "#{node['jenkins']['major']}_#{node['jenkins']['minor']}"
jenkins_source = "jenkins-#{jenkins_version}.war"
jenkins_dest = File.join(home, "jenkins.war")

cookbook_file jenkins_dest do
  owner user
  source "#{jenkins_source}"
end
  
# Outline directory structure
jenkins_plugins = File.join(home, "plugins")
directory jenkins_plugins do
  owner user
  action :create
end
jenkins_home = File.join(home, "home")
directory jenkins_home do
  owner user
  action :create
end

template File.join(home, "jenkins.sh") do
  owner user
  mode 0700
  source "jenkins.sh.erb"
  variables(
   :war => jenkins_dest,
   :home => jenkins_home,
   :http_port => 9090,
   :ajp_port => 9091
  )
end

template File.join(jenkins_home, "hudson.tasks.Maven.xml") do
  owner user
  source "hudson.tasks.Maven.xml.erb"
  variables(
   :name => "MavenInstallByChefCookbook",
   :versions => [ "3.0.4", "2.2.1" ]
  )
end



#
# Jenkins runs every job found in this directory
jenkins_jobs_dir = File.join(jenkins_home, "jobs")
jobs_install_dir = File.join(home, "jobs")
log("Installing jobs into #{jobs_install_dir}") { level :info }
#
# Jenkins is fully provisioned.
# The jenkins job directory is clean every time.
# The master job references are stored above JENKINS_HOME.
# When a job is switched on, a symoblic link is made.
directory jenkins_jobs_dir do
  owner user
  action :delete
  recursive true
end

directory jenkins_jobs_dir do
  owner user
  action :create
end

directory jobs_install_dir do
  owner user
  action :create
end


plugins = [node['plugin_definitions'][:git], node['plugin_definitions'][:ruby]]
# are versions are good idea?
# may be better to include within name
node['jobs'].each do |job|
  #TODO: remember uniqueness check for job names
  job_name = "#{job[:name]}-#{job[:version]}"
  job_dir = File.join(jobs_install_dir, job_name)

  log("Configuring job #{job_name} in #{job_dir}") { level :info }  
  directory job_dir do
    owner user
    action :create
  end   
  
  template File.join(job_dir, "config.xml") do
    owner user
    source "task.config.xml.erb"
    variables( :url => job[:url])
  end


#
# The idea is to preserve history but copy over configuration.
# The jenkins jobs directory will be destroyed and then recreated.
# Links are then added to the jobs required.
  target = File.join(jenkins_jobs_dir, job_name)
  log("Switching #{job_name} on, linked #{job_name} to #{target}") { level :info }
  link target do
    to job_dir
    link_type :symbolic
    owner user
  end
end

#
#TODO: reduce duplicated clean actions
#TODO: the Chef way to do this seems to be by creating a new provider for directory
#TODO: seems like it might be a lot of work for little gain
#TODO: then the question is whether it should be pushed upstream 
# 
# Clear old plugins
plugins_on_dir = File.join(jenkins_home, "plugins")
directory plugins_on_dir do
  owner user
  action :delete
  recursive true
end

directory plugins_on_dir do
  owner user
  action :create
end

#
# Ensure each plugin is available
# and switched on.
#
# Using symbolic links to switch plugins on and off
# is arguable over-engineering. It saves a little
# bit of time. 
plugins.each do |plugin| 

  plugin_name = "#{plugin[:name]}-#{plugin[:version]}.hpi"
  log("Making #{plugin_name} available") { level :info }
  plugin_install_dest = File.join(jenkins_plugins, plugin_name)
  cookbook_file plugin_install_dest do
    owner user
    source File.join("plugins", plugin_name)
  end
  plugin[:package].each {|package| log("Package #{package} is needed") { level :info }} if plugin[:package]
  
  log("Switching #{plugin_name} on") { level :info }
  link File.join(plugins_on_dir, plugin_name) do
    to plugin_install_dest
    link_type :symbolic
    owner user
  end
end
