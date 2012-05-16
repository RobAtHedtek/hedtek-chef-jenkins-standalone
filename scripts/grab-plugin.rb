#!/usr/bin/env ruby
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

require 'fileutils'

#%w(dashboard-view git github ircbot email-ext instant-messaging analysis-core ci-game statusmonitor violations xunit release radiatorviewplugin xfpanel build-pipeline-#plugin emma htmlpublisher all-changes).each do |name|
#  `wget "http://updates.jenkins-ci.org/latest/#{name}.hpi"`
#end


%w(ruby rubyMetrics rake dashboard-view git github ircbot email-ext instant-messaging analysis-core ci-game statusmonitor violations xunit release radiatorviewplugin xfpanel build-pipeline-plugin emma htmlpublisher all-changes).each do |name|
 plugin_file_name = "#{name}.hpi"
 `wget --no-check-certificate "http://updates.jenkins-ci.org/latest/#{plugin_file_name}"` unless File.exists? "#{plugin_file_name}"
 plugin_version = nil
 jenkins_version = nil
 hudson_version = nil
 imp_version = nil
 `unzip -c #{plugin_file_name} META-INF/MANIFEST.MF`.each_line do |line| 
   plugin_version = line.split[1] if line.start_with?("Plugin-Version:")
   jenkins_version = line.split[1] if line.start_with?("Jenkins-Version:")
   hudson_version = line.split[1] if line.start_with?("Hudson-Version:")
   imp_version = line.split[1] if line.start_with?("Implementation-Version:")
  end
  version = imp_version ? imp_version : plugin_version
  puts "Plugin #{name}@#{plugin_version}(#{imp_version}) for Jenkins #{jenkins_version} | #{hudson_version}"
  puts "Using version #{version}"
  plugin_dir = "cookbooks/jenkyns/files/default/plugins"
  FileUtils.mkdir(plugin_dir) unless File.exists?(plugin_dir)
  FileUtils.mv(plugin_file_name, "#{plugin_dir}/#{name}-#{version}.hpi")
end



