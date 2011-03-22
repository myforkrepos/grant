require 'grant/error'

describe Grant::Error do

  it 'should make user, action, and model available as readers' do
    user = OpenStruct.new(:id => 1)
    model = OpenStruct.new(:id => 2)
    action = :create
    ex = Grant::Error.new(user, action, model)

    ex.user.should == user
    ex.action.should == action
    ex.model.should == model
  end

  it 'should produce a nicely formatted message' do
    user = OpenStruct.new(:id => 3)
    model = OpenStruct.new(:id => 4)
    action = :create
    ex = Grant::Error.new(user, action, model)

    ex.message.should include("#{user.class.name}:#{user.id}")
    ex.message.should include("#{model.class.name}:#{model.id}")
    ex.message.should include(action.to_s)
  end

  it 'should make the a string passed to the constructor available as the error message' do
    ex = Grant::Error.new('message')
    ex.message.should == 'message'
    ex.to_s.should == 'message'
  end

end
