require File.dirname(__FILE__) + '/spec_helper'
require 'ostruct'
require 'grant/grantor'

describe Grant::Grantor do

  describe '#authorize!' do
    it 'should pass the user, model, and action to the supplied callback block' do
      model = Object.new
      user = Object.new
      Grant::User.current_user = user

      grantor = Grant::Grantor.new(:update) do |u, m, a|
        u.should == user
        m.should == model
        a.should == :update
        true
      end

      grantor.authorize!(model)
    end

    it 'should turn off grant when calling the supplied callback block' do
      grantor = Grant::Grantor.new(:destroy) do |user, model, action|
        Grant::Status.grant_disabled?.should be_true
        true
      end

      grantor.authorize!(Object.new)
    end
  end

end
