require 'spec_helper'

describe 'jmxtrans', :type => :class do

  context "package and service" do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    it {
      should contain_package('jmxtrans').with( { 'name' => 'jmxtrans' } )
      should contain_service('jmxtrans').with( { 'name' => 'jmxtrans' } )
    }
  end

end
