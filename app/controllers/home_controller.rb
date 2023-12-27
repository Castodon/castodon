# frozen_string_literal: true

class HomeController < ApplicationController
  include WebAppControllerConcern, Admin::MembershipsHelper

  def index
    expires_in(15.seconds, public: true, stale_while_revalidate: 30.seconds, stale_if_error: 1.day) unless user_signed_in?
    # 获取证书id
    if user_signed_in?
      user_id = current_user.id
      user_memberships = UserMembership.find_by_user_id(user_id)
      if user_memberships
        license_id=user_memberships.license_id
        # 判断是否平台正式标识 以PLT开头
        if license_id.start_with?("PLT")
          # 字符串以 PLT 开头
          @show_alert = false
        else
          # 获取证书状态
          result = call_get_license_status_api(license_id);
          if result == 'inuse'
            @show_alert = false
          else
            @show_alert = true
          end
        end
      else
        @show_alert = true
      end
    end
  end
end
