# frozen_string_literal: true
require 'chatoperastore'
require 'pp'
require 'dotenv/load'
module Admin::MembershipsHelper

  # 获取证书状态
  def call_get_license_status_api(license_id)
    quota_wd_client = Chatoperastore::QuotaWdClient.new
    user_id = current_user.id
    Rails.logger.info "method:license_status,user_id:#{user_id}, license_id:#{license_id}"
    result = quota_wd_client.getLicenseStatus(license_id)
    # 打印日志
    Rails.logger.info "user_id:#{user_id}, result:#{result}"
    if result['rc'] == 0
      message = result['data'][0]['status']
    else
      message = result['rc']
    end
    message
  end

  # 获取证书信息
  def call_get_license_basics_api(license_id)
    quota_wd_client = Chatoperastore::QuotaWdClient.new
    user_id = current_user.id

    Rails.logger.info "method:license_basics,user_id:#{user_id}, license_id:#{license_id}"

    result = quota_wd_client.getLicenseBasics(license_id)
    # 打印日志
    Rails.logger.info "user_id:#{user_id}, result:#{result}"
    status = ''
    valid_time = ''
    owner_nickname = ''
    if result['rc'] == 0
      data = result['data'][0]
      status = data['license']['status']
      owner_nickname = data['user']['nickname']
      valid_time = data['license']['effectivedateend']
      valid_time = DateTime.parse(valid_time).strftime("%Y-%m-%d %H:%M:%S") if valid_time.present?
      case status
      when 'inuse'
        status = I18n.t('memberships.save_inuse_msg')
      when 'expired'
        status = I18n.t('memberships.save_expired_msg')
      when 'exhausted'
        status = I18n.t('memberships.save_exhausted_msg')
      when 'notfound'
        status = I18n.t('memberships.save_notfound_msg')
      end
    elsif result['rc'] == 3
      status = I18n.t('memberships.save_notfound_msg')
    elsif result['rc'] == 6
      status = I18n.t('memberships.save_exhausted_msg')
    end

    [status, valid_time, owner_nickname]
  end

  #  扣减配额
  def call_license_write_api(license_id, consumes)
    # 打印日志
    user_id = current_user.id
    quota_wd_client = Chatoperastore::QuotaWdClient.new
    # 从服务环境变量读取
    server_inst_id = ENV['STORE_SERVINST_ID']
    service_name = ENV['STORE_SERVICE_NAME']
    Rails.logger.info "method:license_write,user_id:#{user_id}, license_id:#{license_id},server_inst_id:#{server_inst_id},service_name:#{service_name}"
    result = quota_wd_client.write(license_id, server_inst_id, service_name, consumes)

    Rails.logger.info "user_id:#{user_id}, result:#{result}"
    result['rc']
  end

end
