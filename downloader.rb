require 'net/http'
require 'uri'
require 'json'

uri = URI.parse("https://releases.hashicorp.com/terraform/index.json")
response = Net::HTTP.get_response(uri)

# body method will extract the whole HTTP output
versions = JSON.parse(response.body)['versions']
all_versions = JSON.parse(response.body)['versions'].keys
#target_url = "https://releases.hashicorp.com/terraform/0.12.9/terraform_0.12.9_darwin_amd64.zip"

# Resulted array of strings in format "x.y.z" with stabele versions only!
stable_versions = []
all_versions.each do |element|
  unless element.match("[a-zA-Z]")
    stable_versions.push(element)
  end
end

p stable_versions

# Find latest version by comparing stable_versions elements
max = Gem::Version.new('0.0.0')

stable_versions.each do |ver|
  current_version = Gem::Version.new(ver)
  if current_version > max
    max = current_version
  end  
end

latest_version = max.to_s

p latest_version
# Convert stable_versions array into nested array in order to find highest version. 
#nested_versions = []
#stable_versions.each do |string|
#  nested_versions.push(string.split("."))
#end

#p nested_versions

# Find the latest version
# from latest version, find OS architecture
# Array of hashes => [{}, {}, {}]
# {"name"=>"terraform", "version"=>"0.12.10", "os"=>"darwin", "arch"=>"amd64", "filename"=>"terraform_0.12.10_darwin_amd64.zip", "url"=>"https://releases.hashicorp.com/terraform/0.12.10/terraform_0.12.10_darwin_amd64.zip"}

type = versions[latest_version]['builds'][0]
p type

