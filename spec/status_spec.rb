require File.dirname(__FILE__) + '/spec_helper'
require 'grant/status'

describe Grant::Status do
  it "should be enabled if set to enabled" do
    obj = Class.new do
      include Grant::Status
      def enable; enable_grant; end
    end.new

    obj.enable
    Grant::Status.grant_enabled?.should be_true
    Grant::Status.grant_disabled?.should be_false
  end

  it "should be disabled if set to disabled" do
    obj = Class.new do
      include Grant::Status
      def disable; disable_grant; end
    end.new

    obj.disable
    Grant::Status.grant_enabled?.should be_false
    Grant::Status.grant_disabled?.should be_true
  end
end
