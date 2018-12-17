# frozen_string_literal: true

class MeetingMailer < ApplicationMailer
  helper :application
  default from: 'notifacations@planner.com'

  def meeting_scheduled
    @meeting = params[:meeting]
    @user = params[:user]

    mail(to: @user.email, subject: 'New Session Confirmation')
  end
end
