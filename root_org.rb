require_relative 'org'
require_relative 'child_org'

class RootOrg
  attr_accessor :name, :orgs, :denied_users

  def initialize
      @name = "Root Org"
      @orgs = []
      @denied_users = []
      # self.class.change_new
  end



end
