user = User.create!(name:'admin')

AuthInfo.create!(email: 'abc@example.com', password: 'password', password: 'password', user: user)

30.times do |n|
  Task.create!(
    name: "task#{'%02d' % n}",
    description: "This is task#{'%02d' % n}",
    have_a_due: [true, false].sample,
    due_at: Random.rand(Time.zone.tomorrow..Time.zone.tomorrow.next_year),
    status: Status.all.sample,
    user: user
  )
end