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
    @show_form = false
    @SHOW_PLT = false
    user_id = current_user.id
    # 查询当前用户是否已经绑定证书
    @user_memberships = UserMembership.find_by_user_id(user_id)
    # 判断结果是否为空。为空显示展示页面
    if @user_memberships.nil?
      hint_text = I18n.t('memberships.tip')
      @url = hint_text + " " + view_context.link_to(ENV['STORE_PRODUCT_URL'], ENV['STORE_PRODUCT_URL'], html_options = {target: "_blank"})
      @show_form = true
    else
      license_id=@user_memberships.license_id
      # 判断是否是平台证书
      if license_id.start_with?("PLT")
        # 字符串以 PLT 开头
        @SHOW_PLT = true
      else
      # 获取证书 信息
      @status, @valid_time, @owner_nickname = call_get_license_basics_api(license_id)
      @status=status_convert(@status)
      end
    end
  end

  #  进行保存会员信息
  def create
    # 获取前端传的表单参数
    input_value = params[:form_add_memberships][:license_id]
    # 验证证书标识是否有效
    @status, @valid_time, @owner_nickname,product_shortId = call_get_license_basics_api(input_value)
    last_part= ENV['STORE_PRODUCT_URL'].split("/").last
    # 证书有效才进行保存
    if @status == 'inuse' && last_part==product_shortId
      user_id = current_user.id
      # 保存证书
      membership = UserMembership.new(user_id: user_id, license_id: input_value, github_username: '', created_at: Time.now, updated_at: Time.now)
      if membership.save
        redirect_to memberships_path, notice: I18n.t('memberships.save_success_msg')
      else
        redirect_to memberships_path, notice: I18n.t('memberships.save_failure_msg')
      end
    elsif @status == 'inuse' && last_part!=product_shortId
      convert_result=status_convert('invalid')
      redirect_to memberships_path, notice: convert_result
    else
      convert_result=status_convert(@status)
      redirect_to memberships_path, notice: convert_result
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
      convert_result=status_convert(result)
      redirect_to memberships_path, notice: convert_result
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

  def status_convert(status)
    case status
    when 'inuse'
      convert_result = I18n.t('memberships.save_inuse_msg')
    when 'invalid'
      convert_result = I18n.t('memberships.save_invalid_msg')
    when 'expired'
      convert_result = I18n.t('memberships.save_expired_msg')
    when 'exhausted', 6
      convert_result = I18n.t('memberships.save_exhausted_msg')
    when 'notfound', 3
      convert_result = I18n.t('memberships.save_notfound_msg')
    else
      convert_result = I18n.t('memberships.save_operate_failure_msg')
    end
    convert_result
  end

  def set_body_classes
    @body_classes = 'admin'
  end

  def set_cache_headers
    response.cache_control.replace(private: true, no_store: true)
  end
end
