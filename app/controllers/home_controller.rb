# frozen_string_literal: true

class HomeController < ApplicationController
  include WebAppControllerConcern, Admin::MembershipsHelper

  def index
    expires_in(15.seconds, public: true, stale_while_revalidate: 30.seconds, stale_if_error: 1.day) unless user_signed_in?
    # 获取证书id
    user_id = current_user.id
    membership = UserMembership.where(user_id: user_id).first
    if membership
      license_id = membership.license_id
      # 获取证书状态
      result = call_get_license_status_api(license_id);
      if result == 'inuse'
        @show_alert = false
      else
        @show_alert = true
      end
    else
      @show_alert = true
    end
  end
end
