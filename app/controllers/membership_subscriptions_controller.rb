# frozen_string_literal: true

class MembershipSubscriptionsController < ApplicationController


  def show
    @form = Form::AccountBatch.new
  end


end
