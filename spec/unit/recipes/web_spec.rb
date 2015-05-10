#
# Cookbook Name:: s2stories
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 's2stories::web' do

  context 'When all attributes are default, on an unspecified platform' do

    before do
      configure_chef
      stub_command('git --version >/dev/null').and_return(false)
      stub_command('which nginx').and_return(false)      
    end

    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new do |node,server|
        setup_data_bags(server)
      end
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end

  end
end
