require 'rubygems'
require 'minitest/autorun'

require_relative 'orgs'
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
    @root_org.children << org
    assert org.parent = @root_org
    assert @root_org.children.include?(org)
  end

  def test_child_org_should_belong_to_org
    org = Org.new("Org Name", @root_org)
    child_org = ChildOrg.new("Child One", org)
    org.children << child_org
    assert child_org.parent = org, "Child org has no parent :("
    assert org.children.include?(child_org), "Org has no child orgs."
  end

  def test_root_org_admin_is_admin_everywhere
    user = User.new("Superman")
    org = Org.new("Org Name", @root_org)
    child_org = ChildOrg.new("Child Org Name", org)
    user.make_admin_for(@root_org)
    # User should access both
    assert user.has_admin_access?(@root_org)
    assert user.has_admin_access?(org), "User can't access owned orgs"
    assert user.has_admin_access?(child_org), "User can't access child org with root org access."
  end

  def test_user_should_not_access_denied_orgs
    user = User.new("Superman")
    org = Org.new("Org Name", @root_org)
    user.deny_from(org)
    refute user.has_admin_access?(org), "User can access owned orgs she is denied from."
  end

end
