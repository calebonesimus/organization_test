require_relative 'root_org'
require_relative 'org'

class ChildOrg
  attr_accessor :name, :parent, :denied_users

  def initialize(name, parent)
    @name = name
    @parent = parent
    @denied_users = []
  end
end
