require 'rubygems'
require 'minitest/autorun'

require_relative 'orgs'
require_relative 'user'

class AllOrgsTest < MiniTest::Unit::TestCase

  def setup
    @root = RootOrg.new
    @user = User.new("Superman")
    @org = Org.new("Org Name", @root)
    @child = ChildOrg.new("Child Org Name", @org)
    @second_child = ChildOrg.new("Second Child", @org)
  end

  # Families
  def test_root_org_should_be_called_root_org
    assert_equal "Root Org", @root.name
  end

  def test_new_org_should_belong_to_root_org
    assert @org.parent = @root, "Org does not belong to root."
    assert @root.children.include?(@org), "Root does not have children."
  end

  def test_child_org_should_belong_to_org
    assert @child.parent = @org, "Child org has no parent :("
    assert @org.children.include?(@child), "Org has no child orgs."
  end

  # Admin access
  def test_root_org_admin_is_admin_everywhere
    @user.make_admin_for(@root)
    assert @user.has_admin_access?(@root)
    assert @user.has_admin_access?(@org), "User can't access owned orgs"
    assert @user.has_admin_access?(@child), "User can't access child org with root org access."
  end

  def test_org_admin_should_be_child_admin
    @user.make_admin_for(@org)
    assert @user.has_admin_access?(@child), "User can't access child org with org admin access."
  end

  def test_user_should_access_all_children
    @user.make_admin_for(@org)
    assert @user.has_admin_access?(@child), "User can't access more than than one child."
    assert @user.has_admin_access?(@second_child), "User can't access more than than one child."
  end


  # Denied
  def test_org_admin_cannot_access_root_org
    @user.make_admin_for(@org)
    refute @user.has_admin_access?(@root)
  end

  def test_user_should_not_access_denied_orgs
    @user.make_admin_for(@root)
    @user.deny_from(@child)
    refute @user.has_admin_access?(@child), "User can access owned orgs she is denied from."
  end

  def test_user_should_not_access_denied_orgs_that_are_related
    @user.make_admin_for(@org)
    @user.deny_from(@second_child)
    assert @user.has_admin_access?(@child)
    refute @user.has_admin_access?(@second_child)
  end

  def test_user_admin_for_should_not_include_denied_orgs
    @user.make_admin_for(@root)
    @user.deny_from(@second_child)
    assert @user.admin_for.include?(@root)
    assert @user.admin_for.include?(@org)
    assert @user.admin_for.include?(@child)
    refute @user.admin_for.include?(@second_child)
  end

  # Messy tree with a few denials
  def test_crazy_tree
    @second_org = Org.new("Second Org", @root)
    @third_org = Org.new("Third Org", @root)
    @third_child = ChildOrg.new("Third Child", @second_org)
    @fourth_child = ChildOrg.new("Fourth Child", @org)
    @user.make_admin_for(@root)
    @user.deny_from(@third_org)
    @user.deny_from(@child)
    @user.deny_from(@third_child)
    assert @user.has_admin_access?(@root)
    assert @user.has_admin_access?(@org)
    assert @user.has_admin_access?(@second_org)
    refute @user.has_admin_access?(@third_org)
    refute @user.has_admin_access?(@child)
    assert @user.has_admin_access?(@second_child)
    refute @user.has_admin_access?(@third_child)
    assert @user.has_admin_access?(@fourth_child)
  end

  # User access and denial
  def test_user_access_everywhere
    assert @user.has_user_access?(@root)
    assert @user.has_user_access?(@org)
    assert @user.has_user_access?(@child)
  end

  def test_user_access_can_be_denied
    @user.deny_from(@org)
    refute @user.has_user_access?(@org), "User has user access when denied."
  end

end
