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
# BEGIN Development only 
require 'etc'
home = File.expand_path(File.join(File.dirname(__FILE__), '../../..', "tmp"))
user = Etc.getlogin
log("Welcome to Jenkyns. Working in #{home} as #{user}") { level :info }
directory home do
  owner user
  action :create
end
# END Development only

require 'erb'

#
# Distributes Jenkins, ready to run as a war.
#
jenkins_version = "1_457"
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


plugin_definitions = {
# statusmonitor-1.3.hpi has 
#  name statusmonitor and version 1.3
:statusmonitor => {:name => 'statusmonitor', :version => '1.3'},
# ircbot-2.18.hpi has 
#  name ircbot and version 2.18
:ircbot => {:name => 'ircbot', :version => '2.18'},
# github-1.2.hpi has 
#  name github and version 1.2
:github => {:name => 'github', :version => '1.2'},
# analysis-core-1.38.hpi has 
#  name analysis-core and version 1.38
:analysis_core => {:name => 'analysis-core', :version => '1.38'},
# rake-1.7.7.hpi has 
#  name rake and version 1.7.7
:rake => {:name => 'rake', :version => '1.7.7'},
# radiatorviewplugin-1.13.hpi has 
#  name radiatorviewplugin and version 1.13
:radiatorviewplugin => {:name => 'radiatorviewplugin', :version => '1.13'},
# htmlpublisher-0.7.hpi has 
#  name htmlpublisher and version 0.7
:htmlpublisher => {:name => 'htmlpublisher', :version => '0.7'},
# ci-game-1.18.hpi has 
#  name ci-game and version 1.18
:ci_game => {:name => 'ci-game', :version => '1.18'},
# xfpanel-1.0.11.hpi has 
#  name xfpanel and version 1.0.11
:xfpanel => {:name => 'xfpanel', :version => '1.0.11'},
# rubyMetrics-1.5.0.hpi has 
#  name rubyMetrics and version 1.5.0
:rubyMetrics => {:name => 'rubyMetrics', :version => '1.5.0'},
# email-ext-2.19.hpi has 
#  name email-ext and version 2.19
:email_ext => {:name => 'email-ext', :version => '2.19'},
# ruby-1.2.hpi has 
#  name ruby and version 1.2
:ruby => {:name => 'ruby', :version => '1.2'},
# all-changes-1.3.hpi has 
#  name all-changes and version 1.3
:all_changes => {:name => 'all-changes', :version => '1.3'},
# instant-messaging-1.21.hpi has 
#  name instant-messaging and version 1.21
:instant_messaging => {:name => 'instant-messaging', :version => '1.21'},
# emma-1.26.hpi has 
#  name emma and version 1.26
:emma => {:name => 'emma', :version => '1.26'},
# build-pipeline-plugin-1.2.3.hpi has 
#  name build-pipeline-plugin and version 1.2.3
:build_pipeline_plugin => {:name => 'build-pipeline-plugin', :version => '1.2.3'},
# dashboard-view-2.2.hpi has 
#  name dashboard-view and version 2.2
:dashboard_view => {:name => 'dashboard-view', :version => '2.2'},
# xunit-1.43.hpi has 
#  name xunit and version 1.43
:xunit => {:name => 'xunit', :version => '1.43'},
# release-2.2.hpi has 
#  name release and version 2.2
:release => {:name => 'release', :version => '2.2'},
# violations-0.7.10.hpi has 
#  name violations and version 0.7.10
:violations => {:name => 'violations', :version => '0.7.10'},
# git-1.1.16.hpi has 
#  name git and version 1.1.16
:git => {:name => 'git', :version => '1.1.16'}
}

task_config =<<-EOF
<?xml version='1.0' encoding='UTF-8'?>
<maven2-moduleset>
  <actions/>
  <description></description>
  <keepDependencies>false</keepDependencies>
  <properties/>
  <scm class="hudson.plugins.git.GitSCM">
    <configVersion>2</configVersion>
    <userRemoteConfigs>
      <hudson.plugins.git.UserRemoteConfig>
        <name></name>
        <refspec></refspec>
        <url>https://github.com/hedtek/dspace-rest.git</url>
      </hudson.plugins.git.UserRemoteConfig>
    </userRemoteConfigs>
    <branches>
      <hudson.plugins.git.BranchSpec>
        <name>**</name>
      </hudson.plugins.git.BranchSpec>
    </branches>
    <disableSubmodules>false</disableSubmodules>
    <recursiveSubmodules>false</recursiveSubmodules>
    <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
    <authorOrCommitter>false</authorOrCommitter>
    <clean>false</clean>
    <wipeOutWorkspace>false</wipeOutWorkspace>
    <pruneBranches>false</pruneBranches>
    <remotePoll>false</remotePoll>
    <buildChooser class="hudson.plugins.git.util.DefaultBuildChooser"/>
    <gitTool>Default</gitTool>
    <submoduleCfg class="list"/>
    <relativeTargetDir></relativeTargetDir>
    <reference></reference>
    <excludedRegions></excludedRegions>
    <excludedUsers></excludedUsers>
    <gitConfigName></gitConfigName>
    <gitConfigEmail></gitConfigEmail>
    <skipTag>false</skipTag>
    <includedRegions></includedRegions>
    <scmName></scmName>
  </scm>
  <canRoam>true</canRoam>
  <disabled>false</disabled>
  <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
  <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
  <triggers class="vector"/>
  <concurrentBuild>false</concurrentBuild>
  <aggregatorStyleBuild>true</aggregatorStyleBuild>
  <incrementalBuild>false</incrementalBuild>
  <perModuleEmail>true</perModuleEmail>
  <ignoreUpstremChanges>false</ignoreUpstremChanges>
  <archivingDisabled>false</archivingDisabled>
  <resolveDependencies>false</resolveDependencies>
  <processPlugins>false</processPlugins>
  <mavenValidationLevel>-1</mavenValidationLevel>
  <runHeadless>false</runHeadless>
  <settingConfigId></settingConfigId>
  <globalSettingConfigId></globalSettingConfigId>
  <reporters/>
  <publishers/>
  <buildWrappers/>
  <prebuilders/>
  <postbuilders/>
  <runPostStepsIfResult>
    <name>FAILURE</name>
    <ordinal>2</ordinal>
    <color>RED</color>
  </runPostStepsIfResult>
</maven2-moduleset>
EOF

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


plugins = [plugin_definitions[:git], plugin_definitions[:ruby]]
# are versions are good idea?
# may be better to include within name
[
{:name => "dspace-rest", :version => 0.1, :config => task_config, :plugins => [:git]},
{:name => "dspace-rest", :version => 0.2, :config => task_config, :plugins => [:git]},
{:name => "dspace-rest", :version => 0.3, :config => task_config, :plugins => [:git]}].each do |job|
  #TODO: remember uniqueness check for job names
  job_name = "#{job[:name]}-#{job[:version]}"
  job_dir = File.join(jobs_install_dir, job_name)

  log("Configuring job #{job_name} in #{job_dir}") { level :info }  
  directory job_dir do
    owner user
    action :create
  end   
  file File.join(job_dir, "config.xml") do
    owner user
    content ERB.new(job[:config]).result(binding)
    action :create
  end
#
# The idea is to preserve history but copy over configuration.
# The jenkins jobs directory will be destroyed and then recreated.
# Links are then added to the jobs required.
  log("Switching #{job_name} on") { level :info }
  link File.join(jenkins_jobs_dir, job_name) do
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