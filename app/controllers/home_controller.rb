# frozen_string_literal: true

class HomeController < ApplicationController
  include WebAppControllerConcern, Admin::MembershipsHelper

  def index
    expires_in(15.seconds, public: true, stale_while_revalidate: 30.seconds, stale_if_error: 1.day) unless user_signed_in?
    # 获取证书id
    if user_signed_in?
      user_id = current_user.id
      @show_alert =checkMembership(user_id)
    end
  end
end
