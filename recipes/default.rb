#
# Cookbook Name:: tc
# Recipe:: default

version = node['version']
src_filename = "TeamCity-#{version}.tar.gz"
src_filepath = "#{Chef::Config[:file_cache_path]}/#{src_filename}" 
extract_path = "/opt/TeamCity-#{version}"

remote_file src_filepath do
    source "http://download-cf.jetbrains.com/teamcity/#{src_filename}"
    not_if { ::File.exists?(extract_path) }
end

bash 'extract_teamcity' do
  cwd ::File.dirname(src_filepath)
  code <<-EOH
    mkdir -p #{extract_path}
    tar xzf #{src_filename} -C #{extract_path} --strip-components 1
    EOH
  not_if { ::File.exists?(extract_path) }
end

