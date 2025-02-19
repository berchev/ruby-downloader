# ruby-downloader

## What this script do?
- create directory **hashicorp_tools** into your user's HOME directory
- download latest version of any HashiCorp product (except vagrant) into your **$HOME/hashicorp_tools** directory
- add execute permissions
- add **$HOME/hashicorp_tools** into your **$PATH**, editing your **$HOME/.bash_profile**

## Supported platforms
- MAC OS
- All Linux platforms any Architecture

## Requirements
- setup of [rbenv](https://github.com/rbenv/rbenv) or [RVM](https://rvm.io/rvm/install) is recommended if you do not want to mess your system's gems. (I am using rbenv)
- ruby > 2.4.x
- install required gems (http, json, rubyzip, dir, fileutils). I believe that most of them would be already installed. In case some gem is not installed: 
  ```
  gem install <gem_name>
  ```
## How to use it?
- open **downloader.rb** file with your favourite editor
- edit the variable **product**, into **Variables definition** section of the script, with the name of the product you would like to download:
  ```
  # Product you want to download
  product = "terraform"
  ```
- execute following command:
  ```
  ruby downloader.rb
  ```
- Changes of your **$PATH** will take effect after typing of following command:
  ```
  source ~/.bash_profile
  ```
## TODO
- [ ] Interractive version of this script (user will be prompted to choose what to install using arrow keys)

## DONE
- [x] Add links with description of rbenv and RVM
- [x] Typo fixed
- [x] Comment at line 70 has been added
