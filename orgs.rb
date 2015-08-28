###########################################
############## ORG METHODS ################
###########################################
module OrgMethods

  def has_children?
    if self.class == ChildOrg
      false
    elsif self.children.empty?
      false
    else
      true
    end
  end

end


###########################################
################ ROOT ORG #################
###########################################
class RootOrg
  include OrgMethods
  attr_accessor :name, :children

  def initialize
    @name = "Root Org"
    @children = []
  end

end


###########################################
################## ORG ####################
###########################################
class Org
  include OrgMethods
  attr_accessor :name, :parent, :children

  def initialize(name, parent)
    @name = name
    @parent = parent
    parent.children << self
    @children = []
  end

end


###########################################
############### CHILD ORG #################
###########################################
class ChildOrg
  include OrgMethods
  attr_accessor :name, :parent

  def initialize(name, parent)
    @name = name
    @parent = parent
    parent.children << self
  end
end
