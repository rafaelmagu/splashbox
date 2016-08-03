desc 'Grant access to all users in the waitlist'
task grant_all_access: :environment do
  puts 'Granting access to all users in the waitlist...'
  User.waiters.find_each do |user|
    puts "user id: #{ user.id }"
    user.update_attributes! waitlist: false
    user.save!
    puts "*User* #{user.name} (#{user.email}) granted access"
  end
  puts 'Done.'
end
