require 'serverspec'
set :backend, :exec

describe service('teamcity-server') do
    it { should be_enabled }
    it { should be_running }
end

describe port(8111) do 
    it { should be_listening }
end
