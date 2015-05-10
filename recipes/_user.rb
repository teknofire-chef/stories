account = data_bag_item('users', 'webdev')

group 'webdev' do
  gid account['gid'] || account['uid']
end

user_account 'webdev' do
  gid 'webdev'
  comment 'Webdev User'
  ssh_keys account['ssh_keys']
  ssh_keygen false
end
