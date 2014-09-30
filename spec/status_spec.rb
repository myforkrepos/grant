require File.dirname(__FILE__) + '/spec_helper'
require 'grant/status'

describe Grant::Status do
  it "should be enabled by default" do
    Grant::Status.grant_enabled?.should be_true  
  end

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

  describe "threads" do
    context "when mono thread" do
      before { Grant::Status.disable_grant }
      after { Grant::Status.enable_grant }

      it "should be disabled in current thread" do
        Grant::Status.grant_enabled?.should be_false
      end

      it "should still be enable in another thread" do |variable|
        t = Thread.new do
          Grant::Status.grant_enabled?.should be_true
        end
        t.join
      end
    end

    context "when multithread" do
      before do
        Grant::Status.switch_to_multithread
        Grant::Status.disable_grant
      end
      after do
        Grant::Status.enable_grant
        Grant::Status.switch_to_monothread
      end

      it "should have set class variable" do
        Grant::Status.class_variable_get(:@@grant_disabled).should be_true
      end

      it "should be disabled in current thread" do
        Grant::Status.grant_enabled?.should be_false
      end

      it "should also be disabled in another thread" do |variable|
        t = Thread.new do
          Grant::Status.grant_enabled?.should be_false
        end
        t.join
      end
    end
  end
end
