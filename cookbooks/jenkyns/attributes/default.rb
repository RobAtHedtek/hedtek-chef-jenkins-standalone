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
default['jenkins-user'] = Etc.getlogin
default['jenkins-home'] = File.expand_path(File.join(File.dirname(__FILE__), '../../..', "tmp"))

# END Development only

default['jobs'] = [
{
    :name => "dspace-rest", 
    :version => 0.1, 
    :url => 'https://github.com/hedtek/dspace-rest.git', 
    :plugins => [:git]
},
{
    :name => "dspace-rest", 
    :version => 0.2, 
    :url => 'https://github.com/hedtek/dspace-rest.git', 
    :plugins => [:git]
},
{
    :name => "dspace-rest", 
    :version => 0.3, 
    :url => 'https://github.com/hedtek/dspace-rest.git', 
    :plugins => [:git]
},
{
    :name => "dspace-rest", 
    :version => 0.4, 
    :url => 'https://github.com/hedtek/dspace-rest.git', 
    :plugins => [:git]
}
]
default['jenkins'] = {
    :major => 1,
    :minor => 464
}
default['plugin_definitions'] = {
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
default['port']['http'] = 9990
default['port']['ajp'] = node['port']['http'] + 1 