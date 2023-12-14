# frozen_string_literal: true
require 'chatoperastore'
require 'pp'
require 'dotenv/load'
module Admin::MembershipsHelper

  # 获取证书状态
  def call_get_license_status_api(license_id)
    quota_wd_client = Chatoperastore::QuotaWdClient.new
    result = quota_wd_client.getLicenseStatus(license_id)
    user_id = current_user.id
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
    result = quota_wd_client.getLicenseBasics(license_id)
    user_id = current_user.id
    # 打印日志
    Rails.logger.info "user_id:#{user_id}, result:#{result}"
    status = ''
    valid_time = ''
    if result['rc'] == 0
      data = result['data'][0]
      status = data['license']['status']
      valid_time = data['effectivedateend']
      case status
      when 'inuse'
        status = I18n.t('memberships.save_notfound_msg')
      when 'expired'
        status = I18n.t('memberships.save_expired_msg')
      when 'exhausted'
        status = I18n.t('exhausted')
      when 'notfound'
        status = I18n.t('memberships.save_notfound_msg')
      end
    elsif result['rc'] == 3
      status = I18n.t('memberships.save_notfound_msg')
    elsif result['rc'] == 6
      status = I18n.t('memberships.save_exhausted_msg')
    end

    [status, valid_time]
  end


  # todo 扣减配额
  def call_license_write_api(license_id, consumes)
    quota_wd_client = Chatoperastore::QuotaWdClient.new
    # 从服务环境变量读取
    server_inst_id = ENV['SERVER_INST_ID']
    service_name = ENV['SERVER_NAME']
    result = quota_wd_client.write(license_id, server_inst_id, service_name, consumes)
    message = "";
    if result['rc'] == 0
      message = result['data']
    elsif item['rc'] == 3
      message = "notfound"
    elsif item['rc'] == 6
      message = "unQualifiedLicense"
    end
    message
  end



end
