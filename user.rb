class User
  attr_accessor :name, :role, :org_level

  def initialize(name, role, org)
    @name = name
    @role = role
    @org = org
  end

  def has_access?(org)
    if self.role == "admin" && !org.denied_users.include?(self)
      true
    end
  end
end
