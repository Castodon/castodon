# frozen_string_literal: true

class MembershipsController < ApplicationController
  include Admin::MembershipsHelper
  layout 'admin'

  before_action :authenticate_user!
  before_action :set_body_classes
  before_action :set_cache_headers

  # 会员订阅渲染页面，通过haml渲染，不是通过react组件进行渲染
  def show
    @form = Form::AddMemberships.new
    user_id = current_user.id
    # 查询当前用户是否已经绑定证书
    @user_memberships = UserMembership.find_by_user_id(user_id)
    # 判断结果是否为空。为空显示展示页面
    if @user_memberships.nil?
      hint_text = I18n.t('memberships.tip')
      @url = hint_text+ view_context.link_to(ENV['STORE_PRODUCT_URL'], ENV['STORE_PRODUCT_URL'], html_options = {target: "_blank"})
      @show_form = true
    else
      # 获取证书 信息
      @status, @valid_time = call_get_license_basics_api(@user_memberships.license_id)
      @show_form = false
    end
  end

  #  进行保存会员信息
  def create
    # 获取前端传的表单参数
    input_value = params[:form_add_memberships][:license_id]
    # 验证证书标识是否有效
    result = call_get_license_status_api(input_value);
    # 证书有效才进行保存
    if result == 'inuse'
      user_id = current_user.id
      # 保存证书
      membership = UserMembership.new(user_id: user_id, license_id: input_value, github_username: '', created_at: Time.now, updated_at: Time.now)
      if membership.save
        redirect_to memberships_path, notice: I18n.t('memberships.save_success_msg')
      else
        redirect_to memberships_path, notice: I18n.t('memberships.save_failure_msg')
      end
    else
      save_result_notice(result)
    end
  end

  #  刷新证书信息
  def update
    user_id = current_user.id
    input_value = params[:form_add_memberships][:license_id]
    result = call_get_license_status_api(input_value);
    # 获取证书状态
    if result == 'inuse'
      # 更新证书导入时间
      membership = UserMembership.find_by_user_id(user_id)
      membership.updated_at = Time.now
      if membership.save!
        redirect_to memberships_path, notice: I18n.t('memberships.refresh_success_msg')
      else
        redirect_to memberships_path, notice: I18n.t('memberships.refresh_failure_msg')
      end
    else
      save_result_notice(result)
    end
  end

  #  解绑
  def destroy
    user_id = current_user.id
    user_membership = UserMembership.find_by(user_id: user_id)
    if user_membership
      user_membership.destroy
      redirect_to memberships_path, notice: I18n.t('memberships.cancel_success_msg')
    else
      redirect_to memberships_path, notice: I18n.t('memberships.cancel_failure_msg')
    end
  end

  def save_result_notice(result)
    case result
    when 'expired'
      notice_message = I18n.t('memberships.save_expired_msg')
    when 'exhausted', 6
      notice_message = I18n.t('memberships.save_exhausted_msg')
    when 'notfound', 3
      notice_message = I18n.t('memberships.save_notfound_msg')
    else
      notice_message = I18n.t('memberships.save_operate_failure_msg')
    end

    redirect_to memberships_path, notice: notice_message
  end

  def set_body_classes
    @body_classes = 'admin'
  end

  def set_cache_headers
    response.cache_control.replace(private: true, no_store: true)
  end
end
