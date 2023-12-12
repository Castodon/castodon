# frozen_string_literal: true

class MembershipsController < ApplicationController
  layout 'admin'

  before_action :authenticate_user!
  before_action :set_body_classes
  before_action :set_cache_headers

  # 会员订阅渲染页面，通过haml渲染，不是通过react组件进行渲染
  def show
    # TODO  调研接口返回值来判断会员有效
    flag = 1
    # 根据接口返回值进行渲染不同的页面 flag：1 添加页面 0 :详情页面
    if flag == 1
      @show_form = true
    else
      @show_form = false
    end

    refresh unless @show_form

  end
  # TODO 进行保存会员信息
  def create
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
