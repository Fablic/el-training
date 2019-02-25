# frozen_string_literal: true

unless User.exists?(email: 'admin@example.com')
  User.create(email: 'admin@example.com', password: 'password', password_confirmation: 'password', role: User.roles[:admin])
end

%w[掃除 買い物 Ruby PHP Python JavaScript 予約 学習 プライベート 業務].each do |value|
  Label.create(name: value) unless Label.exists?(name: value)
end
