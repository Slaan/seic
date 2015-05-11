class MainSearch

  def self.for(search_text)
    users = User.search(search_text)
    groups = Group.search(search_text)
    return users, groups, search_text
  end
  
end
