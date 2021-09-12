FactoryBot.define do
  factory :receipt do

    user {User.last || FactoryBot.create(:user)}
    till {Till.last || FactoryBot.create(:till)}
    date {Date.current}
    sequence :reference do |n|
      zeros = "0000"
      stringified_n = n.to_s
      stringified_n_length = n.to_s.length
      ref = zeros[0..stringified_n_length] + stringified_n
    end
  end
end