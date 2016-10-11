require 'spec_helper'
require 'shared_contexts'

describe 'ansible' do
  # by default the hiera integration uses hiera data from the shared_contexts.rb file
  # but basically to mock hiera you first need to add a key/value pair
  # to the specific context in the spec/shared_contexts.rb file
  # Note: you can only use a single hiera context per describe/context block
  # rspec-puppet does not allow you to swap out hiera data on a per test block
  # include_context :hiera
  let(:node) { 'ansible.example.com' }

  # below is the facts hash that gives you the ability to mock
  # facts on a per describe/context block.  If you use a fact in your
  # manifest you should mock the facts below.
  let(:facts) do
    {}
  end

  # below is a list of the resource parameters that you can override.
  # By default all non-required parameters are commented out,
  # while all required parameters will require you to add a value
  let(:params) do
    {
      #:scripts => undef
      #:modules => undef
      #:hosts_script => undef
      #:config_dir => "$::ansible::params::config_dir",
      #:module_dir => "/usr/share/ansible",

    }
  end
  # add these two lines in a single test block to enable puppet and hiera debug mode
  # Puppet::Util::Log.level = :debug
  # Puppet::Util::Log.newdestination(:console)
  # This will need to get moved
  # it { pp catalogue.resources }
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      case facts[:operatingsystem]
      when 'Ubuntu'
        let(:config_dir) { '/etc/ansible' }
      else
        let(:config_dir) { '/usr/local/etc/ansible' }
      end
      describe 'check default config' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('ansible::params') }
        it { is_expected.to contain_package('ansible') }
        it { is_expected.not_to contain_file('/usr/share/ansible') }
        it { is_expected.not_to contain_file("#{config_dir}/scripts") }
        it { is_expected.not_to contain_file("#{config_dir}/hosts") }
      end

      describe 'Change Defaults' do
        context 'scripts' do
          before { params.merge!(scripts: 'puppet:///modules/foo/bar') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_file("#{config_dir}/scripts").with(
              ensure: 'directory',
              source: 'puppet:///modules/foo/bar',
              recurse: 'remote'
            )
          end
        end
        context 'modules' do
          before { params.merge!(modules: 'puppet:///modules/foo/bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file('/usr/share/ansible').with(
              ensure: 'directory',
              source: 'puppet:///modules/foo/bar',
              recurse: 'remote'
            )
          end
        end
        context 'hosts_script' do
          before { params.merge!(hosts_script: 'puppet:///modules/foo/bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file("#{config_dir}/hosts").with(
              ensure: 'file',
              source: 'puppet:///modules/foo/bar'
            )
          end
        end
        context 'config_dir' do
          before do
            params.merge!(hosts_script: 'puppet:///modules/foo/bar',
                          scripts: 'puppet:///modules/foo/bar',
                          config_dir: '/tmp')
          end
          it { is_expected.to compile }
          it do
            is_expected.to contain_file('/tmp/scripts').with_ensure('directory')
          end
          it { is_expected.to contain_file('/tmp/hosts').with_ensure('file') }
        end
        context 'module_dir' do
          before do
            params.merge!(modules: 'puppet:///modules/foo/bar',
                          module_dir: '/tmp')
          end
          it { is_expected.to compile }
          it { is_expected.to contain_file('/tmp').with_ensure('directory') }
        end
      end
      describe 'scheck bad type' do
        context 'scripts' do
          before { params.merge!(scripts: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'modules' do
          before { params.merge!(modules: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'hosts_script' do
          before { params.merge!(hosts_script: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'config_dir' do
          before { params.merge!(config_dir: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'module_dir' do
          before { params.merge!(module_dir: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
      end
    end
  end
end
