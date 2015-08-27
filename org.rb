require_relative 'root_org'
require_relative 'child_org'

class Org
  attr_accessor :name, :parent, :child_orgs, :denied_users

  def initialize(name, parent)
    @name = name
    @parent = parent
    @child_orgs = []
    @denied_users = []
  end

end
