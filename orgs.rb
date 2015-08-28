class RootOrg
  attr_accessor :name, :orgs, :denied_users

  def initialize
      @name = "Root Org"
      @orgs = []
      @denied_users = []
      # self.class.change_new
  end

end


###########################################
################## ORG ####################
###########################################
class Org
  attr_accessor :name, :parent, :child_orgs, :denied_users

  def initialize(name, parent)
    @name = name
    @parent = parent
    @child_orgs = []
    @denied_users = []
  end

end


###########################################
############### CHILD ORG #################
###########################################
class ChildOrg
  attr_accessor :name, :parent, :denied_users

  def initialize(name, parent)
    @name = name
    @parent = parent
    @denied_users = []
  end
end
