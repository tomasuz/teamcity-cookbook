#
# Cookbook Name:: teamcity
# Recipe:: default

version = node['teamcity']['version']
service_name = node['teamcity']['service-name']
service_username = node['teamcity']['service-username']
service_group = node['teamcity']['service-group']

src_filename = "TeamCity-#{version}.tar.gz"
src_filepath = "#{Chef::Config[:file_cache_path]}/#{src_filename}" 
extract_path = "/opt/TeamCity-#{version}"
data_path = "#{extract_path}/.BuildServer"



cookbook_file 'sudoers' do
    path '/etc/sudoers'
end

package 'java-1.7.0-openjdk'
package 'net-tools'

group service_group 

user service_username do
    gid service_group
    shell '/bin/bash'
end

remote_file src_filepath do
    source "http://download-cf.jetbrains.com/teamcity/#{src_filename}"
    not_if { ::File.exists?(extract_path) }
end

bash 'extract' do
    cwd ::File.dirname(src_filepath)
    code <<-EOH
        mkdir -p #{extract_path}
        tar xzf #{src_filename} -C #{extract_path} --strip-components 1
        chown -R #{service_username}.#{service_group}  #{extract_path}
    EOH
    not_if { ::File.exists?(extract_path) }
end

directory data_path do
    owner service_username
    group service_group
    mode 0755
end

directory "#{data_path}/config" do
    owner service_username
    group service_group
    mode 0755
end

cookbook_file 'database.properties' do
    path "#{data_path}/config/database.properties"
    owner service_username
    group service_group
    mode 0755
end

template "/etc/init.d/#{service_name}" do
    source 'init.erb'
    mode 0755
    owner 'root'
    group 'root'
    variables(
        service_name: service_name,
        service_path: extract_path,
        service_username: service_username
    )
    notifies :restart, "service[#{service_name}]", :delayed
end

service service_name do
    supports start: true, stop: true, restart: true, status: true
    action [:enable, :start]
end

bash 'accept license' do
    cwd extract_path
    code <<-EOH
        until curl -v 'http://localhost:8111' 2>&1 | grep -ic 'showAgreement'
        do
            sleep 1
            echo 'waiting for teamcity license agreement to load'
        done
        curl 'http://localhost:8111/showAgreement.html' -H 'Content-Type: application/x-www-form-urlencoded' --data 'accept=true'
        touch license-accepted
    EOH
    not_if { ::File.exists?("#{extract_path}/license-accepted") }
    only_if { node['teamcity']['accept-license'] }
end

bash 'create teamcity admin user' do
    cwd extract_path
    code <<-EOH
        pattern='Super user authentication token: "(.*)"'
        file='logs/teamcity-server.log'
        until grep -iEc "$pattern" "$file"
        do
            sleep 1
            echo "waiting for superuser auth token to be written to $file"
        done
        token=$(grep -ioE "$pattern" "$file" | grep -oE '[0-9]*' | tail -1)
        curl "http://localhost:8111/httpAuth/app/rest/users" --basic -u ":$token" -H "Content-Type: application/json" -d '{"username": "#{node['teamcity']['admin-username']}", "password": "#{node['teamcity']['admin-password']}"}'
        curl "http://localhost:8111/httpAuth/app/rest/users/username:#{node['teamcity']['admin-username']}/roles/SYSTEM_ADMIN/g/" -X PUT --basic -u ":$token" 
        touch admin-user-created
    EOH
    not_if { ::File.exists?("#{extract_path}/admin-user-created") }
end

