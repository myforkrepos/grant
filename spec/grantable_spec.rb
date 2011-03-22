require File.dirname(__FILE__) + '/spec_helper'
require 'grant/grantable'
require 'grant/user'

describe Grant::Grantable do
  before(:each) do
    @user = User.create
    Grant::User.current_user = @user
  end

  it 'should not restrict CRUD operations until the first grant method call' do
    lambda {
      m = Model.create
      m = Model.find(m.id)
      m.update_attributes(:name => 'new')
      m.destroy
    }.should_not raise_error
  end

  it 'should automatically include Grant::Status after the first grant method call' do
    redefine_model { grant(:create) { true } }
    Model.included_modules.should include(Grant::Status)
  end

  it 'should setup failing Grant::Grantor objects for create, find, update, and destroy callbacks when initialized' do
    m = Model.create
    Model.initialize_grant
    lambda { Model.create }.should raise_error(Grant::Error)
    lambda { Model.find(m.id) }.should raise_error(Grant::Error)
    lambda { m.update_attributes(:name => 'new') }.should raise_error(Grant::Error)
    lambda { m.destroy }.should raise_error(Grant::Error)
  end

  it 'should indicate whether Grant has been initialized' do
    redefine_model
    Model.should_not be_grant_initialized
    Model.initialize_grant
    Model.should be_grant_initialized
  end

  it 'should associate callbacks with active record create, find, update, and destroy callbacks' do
    redefine_model do
      grant(:create) { true }
      grant(:find) { true }
      grant(:update) { false }
      grant(:destroy) { false }
    end

    m = Model.create
    m = Model.find(m.id)
    lambda { m.update_attributes(:name => 'new')}.should raise_error(Grant::Error)
    lambda { m.destroy }.should raise_error(Grant::Error)
  end

  it 'should allow multiple actions to be specified in a grant statement' do
    redefine_model
    m = Model.create
    redefine_model do
      grant(:create, :find) { false }
      grant(:update, :destroy) { true }
    end

    lambda { Model.find(m.id) }.should raise_error(Grant::Error)
    lambda { Model.create }.should raise_error(Grant::Error)
    m.update_attributes(:name => 'new')
    m.destroy
  end

  it 'should allow callbacks to be redefined with subsequent grant statements' do
    redefine_model do
      grant(:create) { true }
      grant(:create) { false }
    end

    lambda { Model.create }.should raise_error(Grant::Error)
  end

  it 'should provide callbacks with the user and model being protected' do
    redefine_model do
      grant(:create) do |user, model|
        user.should == Grant::User.current_user
        model.should_not == nil
        true
      end
    end

    Model.create
  end

  def redefine_model(&blk)
    clazz = Class.new(ActiveRecord::Base, &blk)
    Object.send :remove_const, 'Model'
    Object.send :const_set, 'Model', clazz
  end

  class User < ActiveRecord::Base; end
  class Model < ActiveRecord::Base; end

end
