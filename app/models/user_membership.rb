# == Schema Information
#
# Table name: user_memberships
#
#  id              :bigint(8)        not null, primary key
#  user_id         :bigint(8)        not null
#  license_id      :string
#  github_username :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class UserMembership < ApplicationRecord
  belongs_to :user
end
