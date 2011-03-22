require File.dirname(__FILE__) + '/spec_helper'
require 'ostruct'
require 'grant/grantor'

describe Grant::Grantor do

  describe '#initialize' do
    it 'should define a before_create callback method when passed create as an argument' do
      Grant::Grantor.new(:create).should respond_to(:before_create)
    end
    it 'should define an after_find callback method when passed find as an argument' do
      Grant::Grantor.new(:find).should respond_to(:after_find)
    end
    it 'should define a before_update callback method when passed update as an argument' do
      Grant::Grantor.new(:update).should respond_to(:before_update)
    end
    it 'should define a before_destroy callback method when passed destroy as an argument' do
      Grant::Grantor.new(:destroy).should respond_to(:before_destroy)
    end
  end

  describe '#error' do
    it 'should raise a nicely formatted error detailing the user and model objects' do
      user = OpenStruct.new(:id => 1)
      model = OpenStruct.new(:id => 2)
      action = :create

      begin
        Grant::Grantor.new(:create).error(user, action, model)
      rescue => ex
        ex.message.should include("#{user.class.name}:#{user.id}")
        ex.message.should include("#{model.class.name}:#{model.id}")
        ex.message.should include(action.to_s)
      else
        fail "should have received an exception"
      end
    end
  end

end
