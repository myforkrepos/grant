require File.dirname(__FILE__) + '/spec_helper'
require 'grant/config'

describe Grant::Config do
  
  describe 'Configuration' do
    it "should parse actions from a config array" do
      config = Grant::Config.new(:create, 'update')
      config.actions.should_not be_nil
      config.actions.should have(2).items
      config.actions.should =~ [:create, :update]
    end
  end

  describe 'Configuration Validation' do
    it "should raise a Grant::Error if no action is specified" do
      lambda {
        Grant::Config.new
      }.should raise_error(Grant::Error)
    end

    it "should raise a Grant::Error if an invalid action is specified" do
      lambda {
        Grant::Config.new(:create, :view)
      }.should raise_error(Grant::Error)
    end
  end

end
