desc 'Grant access to all users in the waitlist'
task grant_all_access: :environment do
  puts 'Granting access to all users in the waitlist...'
  User.waiters do |user|
    puts "user id: #{ user.id }"
    user.update_attributes! waitlist: false
    puts "*User* #{user.name} (#{user.email}) granted access"
  end
  puts 'Done.'
end
