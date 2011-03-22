require File.dirname(__FILE__) + '/spec_helper'
require 'grant/status'

describe Grant::Status do
  it "should be enabled if set to enabled" do
    obj = Class.new { include Grant::Status }.new
    obj.enable_grant
    obj.should be_grant_enabled
    obj.should_not be_grant_disabled
  end

  it "should be disabled if set to disabled" do
    obj = Class.new { include Grant::Status }.new
    obj.disable_grant
    obj.should_not be_grant_enabled
    obj.should be_grant_disabled
  end
end
