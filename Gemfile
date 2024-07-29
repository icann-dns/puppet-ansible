# -*- ruby_mode -*-

source ENV['GEM_SOURCE'] || "https://rubygems.org"

group :test do
  gem 'puppetlabs_spec_helper',                :require => false
  gem 'r10k',                                  :require => false
  gem 'ra10ke',                                :require => false
  gem 'concurrent-ruby', '~> 1.1.0',           :require => false
  gem 'rubocop-performance',                   :require => false
  gem 'voxpupuli-test',                        :require => false
  gem 'rspec-puppet', '~> 3.0.0'
end

group :release do
  gem 'voxpupuli-release',             :require => false
end

group :release do
  gem 'voxpupuli-acceptance', '~> 3.0',            :require => false
end
group :system_tests do
  gem 'rake',                          :require => false
  gem 'beaker',                        :require => false
  gem 'beaker-rspec',                  :require => false
  gem 'serverspec',                    :require => false
  gem 'beaker-pe',                     :require => false
  gem 'beaker-vagrant',                :require => false
end



if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion.to_s, :require => false, :groups => [:test]
else
  gem 'facter', :require => false, :groups => [:test]
end

ENV['PUPPET_VERSION'].nil? ? puppetversion = '~> 6.28.0' : puppetversion = ENV['PUPPET_VERSION'].to_s
gem 'puppet', puppetversion, :require => false, :groups => [:test]

# vim: syntax=ruby
