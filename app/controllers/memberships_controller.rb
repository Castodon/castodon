# frozen_string_literal: true



class MembershipsController < ApplicationController
  include Admin::MembershipsHelper
  layout 'admin'

  before_action :authenticate_user!
  before_action :set_body_classes
  before_action :set_cache_headers

  # 会员订阅渲染页面，通过haml渲染，不是通过react组件进行渲染
  def show
    @form=Form::UserMemberships.new
    # 调用会员接口返回值来判断会员有效
    result= call_get_license_status_api("ddddd");
    # 根据接口返回值进行渲染不同的页面 result：inuse 添加页面 其他 :详情页面
    if result != 'unused'
      @show_form = true
    else
      @show_form = false
    end

    refresh unless @show_form

  end
  # TODO 进行保存会员信息
  def create
    input_value = params[:form_user_memberships][:license_id]
=begin

    if result[data].present?
      user_id = current_user.id
      create_at=Time.now
      update_at=Time.now
      github_username='CollectBugs'
      # 报存用户会员证书信息

    end
=end
    redirect_to memberships_path, notice: I18n.t('memberships.save_update_failure_msg')

  end
  # TODO 刷新页面会员信息
  def refresh
  end

  # TODO 解绑
  def cancel
  end
  def set_body_classes
    @body_classes = 'admin'
  end

  def set_cache_headers
    response.cache_control.replace(private: true, no_store: true)
  end
end
