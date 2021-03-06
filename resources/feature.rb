#
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Cookbook:: windows
# Resource:: feature
#
# Copyright:: 2011-2016, Chef Software, Inc.
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

include Windows::Helper

actions :install, :remove, :delete
default_action :install

attribute :feature_name, kind_of: [Array, String], name_attribute: true
attribute :source, kind_of: String
attribute :all, kind_of: [TrueClass, FalseClass], default: false

def initialize(name, run_context = nil)
  super
  @provider = lookup_provider_constant(locate_default_provider)
end

private

def locate_default_provider
  if node['windows'].attribute?(:feature_provider)
    Chef::Log.warn('Specifying the windows_feature provider to use by attribute has been deprecated. Please specify the provider in your resource instead. See the readme for examples. This feature will be removed on 4/2017 after the release of Chef 13.')
    "windows_feature_#{node['windows']['feature_provider']}"
  elsif ::File.exist?(locate_sysnative_cmd('dism.exe'))
    :windows_feature_dism
  elsif ::File.exist?(locate_sysnative_cmd('servermanagercmd.exe'))
    :windows_feature_servermanagercmd
  else
    :windows_feature_powershell
  end
end
