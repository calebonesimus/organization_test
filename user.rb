class User
  attr_accessor :name, :admin_for, :user_for, :denied_from

  def initialize(name)
    @name = name
    @admin_for = []
    @user_for = []
    @denied_from = []
  end

  # Make admin for specified org and all children
  def make_admin_for(org)
    self.admin_for << org unless self.denied?(org)
    if org.has_children?
      org.children.each do |child|
        self.admin_for << child unless self.denied?(org)
        if child.has_children?
          child.children.each do |lower_child|
            self.admin_for << lower_child unless self.denied?(org)
          end
        end
      end
    end
  end

  def has_user_access?(org)
    true unless self.denied?(org)
  end

  def has_admin_access?(org)
    if self.admin_for.include?(org)
      true
    else
      false
    end
  end

  def deny_from(org)
    self.denied_from << org
    if self.admin_for.include?(org)
      self.admin_for.delete(org)
    end
  end

  def denied?(org)
    if self.denied_from.include?(org)
      true
    else
      false
    end
  end



end
