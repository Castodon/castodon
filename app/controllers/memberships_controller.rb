# frozen_string_literal: true



class MembershipsController < ApplicationController
  include Admin::MembershipsHelper
  layout 'admin'

  before_action :authenticate_user!
  before_action :set_body_classes
  before_action :set_cache_headers

  # 会员订阅渲染页面，通过haml渲染，不是通过react组件进行渲染
  def show
    @form=Form::AddMemberships.new
    # 调用会员接口返回值来判断会员有效
    #result= call_get_license_status_api("ddddd");
    # 根据接口返回值进行渲染不同的页面 result：inuse 添加页面 其他 :详情页面
    user_id = current_user.id
    @user_memberships =UserMembership.find_by_user_id(user_id)

    if @user_memberships.nil?
      @show_form = true
    else
      @show_form = false
    end


  end
  # TODO 进行保存会员信息
  def create
    input_value = params[:form_add_memberships][:license_id]
    user_id = current_user.id
    # 保存证书
    membership = UserMembership.new(user_id: user_id, license_id: input_value,github_username: 'CollectBugs4',created_at: Time.now,updated_at: Time.now)
    if membership.save
      redirect_to memberships_path, notice: I18n.t('memberships.save_success_msg')
    else
      redirect_to memberships_path, notice: I18n.t('memberships.save_failure_msg')
    end


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
