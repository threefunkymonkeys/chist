require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'
describe User do
  def setup
    User.dataset.delete
  end

  it 'should tell if has provider' do
    user = User.spawn(:github_user => nil)
    assert !user.has_provider?("github")

    user.github_user = "kandalf"
    assert user.has_provider? "github"
  end

  it 'should add provider' do
    user = User.spawn(:github_user => nil)
    assert !user.has_provider?("github")

    user.add_provider("github", "kandalf")
    assert user.has_provider? "github"
    assert_equal "kandalf", user.github_user
  end

  it 'should reject provider if not allowed' do
    user = User.spawn

    assert user.add_provider("github", "test_user")
    assert user.add_provider("twitter", "test_user")
    assert user.add_provider("facebook", "test_user")
    assert !user.add_provider("invalid", "test_user")
  end
end
