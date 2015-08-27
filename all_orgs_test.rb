require 'rubygems'
require 'minitest/autorun'

require_relative 'root_org'
require_relative 'org'
require_relative 'child_org'
require_relative 'user'

class AllOrgsTest < MiniTest::Unit::TestCase

  def setup
    @root_org = RootOrg.new
  end

  def test_root_org_should_be_called_root_org
    assert_equal "Root Org", @root_org.name
  end

  def test_new_org_should_belong_to_root_org
    org = Org.new("Org Name", @root_org)
    @root_org.orgs << org
    assert org.parent = @root_org
    assert @root_org.orgs.include?(org)
  end

  def test_child_org_should_belong_to_org
    org = Org.new("Org Name", @root_org)
    child_org = ChildOrg.new("Child One", org)
    org.child_orgs << child_org
    assert child_org.parent = org, "Child org has no parent :("
    assert org.child_orgs.include?(child_org), "Org has no child orgs."
  end

  def test_root_org_admin_is_admin_everywhere
    user = User.new("Superman", "admin", @root_org)
    org = Org.new("Org Name", @root_org)
    assert user.has_access?(org), "User can't access owned orgs"
  end

  def test_user_should_not_acces_denied_orgs
    user = User.new("Superman", "admin", @root_org)
    org = Org.new("Org Name", @root_org)
    org.denied_users << user
    refute user.has_access?(org), "User can access owned orgs"
  end

end
