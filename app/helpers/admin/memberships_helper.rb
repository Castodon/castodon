# frozen_string_literal: true
require 'chatoperastore'
require 'pp'
require 'dotenv/load'
module Admin::MembershipsHelper

  def call_get_license_status_api(license_id)
    quota_wd_client = Chatoperastore::QuotaWdClient.new
    result = quota_wd_client.getLicenseStatus(license_id)
    message = "";
    if result['rc'] == 0
      data = result['data']
      data.each do |item|
        if item['status'] == "inuse"
          return message = "inuse"
        else
          message = item['status']
        end
      end
    else
      error = result['error']
      message = error
    end
    message
  end

  def call_license_write_api(license_id, consumes)
    quota_wd_client = Chatoperastore::QuotaWdClient.new
    # 从服务环境变量读取
    Dotenv.load('.env')
    server_inst_id = ENV['server_inst_id']
    service_name = ENV['service_name']
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
