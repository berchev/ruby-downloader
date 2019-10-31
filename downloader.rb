#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'json'
require 'rbconfig'
require 'open-uri'
require 'zip'
require 'dir'
require 'fileutils'

############# Variables definition ###########################
# Product you want to download
product = "terraform"

# Directory where the product will be downloaded
tools_directory = "#{Dir.home}/hashicorp_tools"

# Link to all hashicorp products in JSON format
hashicorp_products_url = "https://releases.hashicorp.com/#{product}/index.json"

bash_profile_path = "#{Dir.home}/.bash_profile"
path_configuration = 'export PATH="$HOME/hashicorp_tools:$PATH"'

################# Modules deffinition ####################
# Determine host OS
module OperatingSystem
  def self.name
    case RbConfig::CONFIG['host_os']

    when /linux/
      'linux'
    when /darwin/
      'darwin'
    else
      "Unknown OS for this script #{RbConfig::CONFIG['host_os']}"
    end
  end
end

# Determine host Architecture
module Architecture
  def self.name
    case RbConfig::CONFIG['host_cpu']

    when /amd64|x86_64/
      'amd64'
    when /i?86|x86|i86pc/
      '386'
    when /^arm/
      'arm'
    else
      "Unknown Architecture for this script #{RbConfig::CONFIG['host_cpu']}"
    end
  end
end

############## Starting main program #########################
# Start the process of filtering versions
uri = URI.parse(hashicorp_products_url)
response = Net::HTTP.get_response(uri)

# body method will extract the whole HTTP output
versions = JSON.parse(response.body)['versions']
all_versions = JSON.parse(response.body)['versions'].keys

# Resulted array of strings in format "x.y.z" 
stable_versions = []
all_versions.each do |element|
  unless element.match("[a-zA-Z]") # Filter the stable versions only!
    stable_versions.push(element)
  end
end

stable_versions

# Find latest version by comparing stable_versions elements
max = Gem::Version.new('0.0.0')

stable_versions.each do |ver|
  current_version = Gem::Version.new(ver)
  if current_version > max
    max = current_version
  end  
end

latest_version = max.to_s

# Array of hashes => [{}, {}, {}]
# {"name"=>"terraform", "version"=>"0.12.10", "os"=>"darwin", "arch"=>"amd64", "filename"=>"terraform_0.12.10_darwin_amd64.zip", "url"=>"https://releases.hashicorp.com/terraform/0.12.10/terraform_0.12.10_darwin_amd64.zip"}
# Iterate through the array of hashes and match your OS type and Architecture, then find the proper download link
target_url = ""
products_by_os = versions[latest_version]['builds']
products_by_os.each do |hash|
  if hash.has_value?(OperatingSystem.name) && hash.has_value?(Architecture.name)
    target_url = hash.fetch("url")
  end
end

# Create download directory if such do not exists
FileUtils.mkdir_p(tools_directory, :mode => 0755) unless Dir.exists?(tools_directory)

# Get download link content
content = open(target_url)

# Download and extract Hashicorp product into tools_directory (product will be overwritten, if already exists) and add executable permissions
Zip::File.open_buffer(content) do |zip|
  zip.each do |file|
    file.extract("#{tools_directory}/#{file.name}") { true }
    FileUtils.chmod("+x", "#{tools_directory}/#{file.name}")
  end
end

# Check whether hashicorp_tools exists into your $PATH and add it, if needed
if !File.read(bash_profile_path).include?(path_configuration)
  File.open(bash_profile_path, 'a') do |file| 
    file.puts
    file.write(path_configuration)
  end
end
