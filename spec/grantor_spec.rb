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

end