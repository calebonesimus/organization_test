require_relative 'orgs'
require_relative 'user'


root = RootOrg.new
org = Org.new("Org", root)
child = ChildOrg.new("Child", org)
user = User.new("Superman")
