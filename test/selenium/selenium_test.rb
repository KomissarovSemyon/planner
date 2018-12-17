# frozen_string_literal: true

require 'json'
require 'selenium-webdriver'
require 'test/unit'

ADMIN_EMAIL = 'admin@a.ru'
PASSWORD = '111111'
USER_NAME = 'selenium'
USER_EMAIL = 'selenium@gmail.com'
ADMIN_EMAIL.freeze
PASSWORD.freeze
USER_NAME.freeze
USER_EMAIL.freeze

class Registration < Test::Unit::TestCase
  def setup
    @driver = Selenium::WebDriver.for :chrome
    @base_url = 'http://localhost:3000/'
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end

  def teardown
    @driver.quit
    assert_equal [], @verification_errors
  end

  test '1 registration' do
    @driver.get(@base_url + 'users/sign_in')
    @driver.find_element(:link, 'Sign up').click
    assert element_exists?(:link, 'Log in')
    @driver.find_element(:id, 'user_username').clear
    @driver.find_element(:id, 'user_username').send_keys USER_NAME
    @driver.find_element(:id, 'user_name').clear
    @driver.find_element(:id, 'user_name').send_keys USER_NAME
    @driver.find_element(:id, 'user_email').clear
    @driver.find_element(:id, 'user_email').send_keys USER_EMAIL
    @driver.find_element(:id, 'user_password').clear
    @driver.find_element(:id, 'user_password').send_keys PASSWORD
    @driver.find_element(:id, 'user_password_confirmation').clear
    @driver.find_element(:id, 'user_password_confirmation').send_keys PASSWORD
    @driver.find_element(:name, 'commit').click
    assert element_exists?(:link, 'Schedule new session')
  end

  test '2 sign in' do
    log_in
  end

  test '3 no meeting = no calendar' do
    log_in
    @driver.find_element(:link, 'Dashboard').click
    assert element_exists?(:link, 'Schedule new session')
  end

  test '4 create meeting' do
    log_in
    @driver.find_element(:link, 'Schedule new session').click
    @driver.find_element(:id, 'meeting_name').clear
    @driver.find_element(:id, 'meeting_name').send_keys 'selenium meeting'
    @driver.find_element(:id, 'meeting_start_time_4i').send_keys 22
    @driver.find_element(:id, 'meeting_end_time_4i').send_keys 23
    @driver.find_element(:name, 'commit').click
    assert element_exists?(:id, 'comment_reply_trix')
  end

  test '5 check created meeting' do
    log_in
    @driver.find_element(:link, 'Dashboard').click
    assert element_exists?(:link, 'selenium meeting')
  end

  test '6 go to created meeting' do
    log_in
    @driver.find_element(:link, 'Dashboard').click
    assert element_exists?(:link, 'selenium meeting')
    @driver.find_element(:link, 'selenium meeting').click
    assert element_exists?(:id, 'comment_reply_trix')
  end

  test '7 go to created meeting and add comment' do
    log_in
    @driver.find_element(:link, 'Dashboard').click
    assert element_exists?(:link, 'selenium meeting')
    @driver.find_element(:link, 'selenium meeting').click
    assert element_exists?(:id, 'comment_reply_trix')
    @driver.find_element(:id, 'comment_reply_trix').send_keys 'test comment'
    @driver.find_element(:name, 'commit').click
    assert element_exists?(:link, 'Delete')
  end

  test '8 go to created meeting and delete created comment' do
    log_in
    @driver.find_element(:link, 'Dashboard').click
    assert element_exists?(:link, 'selenium meeting')
    @driver.find_element(:link, 'selenium meeting').click
    assert element_exists?(:link, 'Delete')
    @driver.find_element(:link, 'Delete').click
    @driver.switch_to.alert.accept
  end

  test '9 sign out' do
    log_in
    @driver.find_element(:link, 'Sign out').click
    assert element_exists?(:link, 'Log in')
  end

  test '0 0 log in admin' do
    log_in_admin
  end

  test '0 1 admin check users' do
    log_in_admin
    @driver.find_element(:link, 'Users').click
    assert element_exists?(:link_text, 'Delete User')
  end

  test '0 2 admin delete users' do
    log_in_admin
    @driver.find_element(:link, 'Users').click
    assert element_exists?(:link_text, 'Delete User')
    @driver.find_element(:link_text, 'Delete User').click
    @driver.switch_to.alert.accept
  end

  private

  def log_in
    @driver.get(@base_url)
    @driver.find_element(:link, 'Log in').click
    assert element_exists?(:link, 'Log in')
    @driver.find_element(:id, 'user_email').clear
    @driver.find_element(:id, 'user_email').send_keys USER_EMAIL
    @driver.find_element(:id, 'user_password').clear
    @driver.find_element(:id, 'user_password').send_keys PASSWORD
    @driver.find_element(:name, 'commit').click
    assert element_exists?(:link, 'Schedule new session')
  end

  def log_in_admin
    @driver.get(@base_url)
    @driver.find_element(:link, 'Log in').click
    assert element_exists?(:link, 'Log in')
    @driver.find_element(:id, 'user_email').clear
    @driver.find_element(:id, 'user_email').send_keys ADMIN_EMAIL
    @driver.find_element(:id, 'user_password').clear
    @driver.find_element(:id, 'user_password').send_keys PASSWORD
    @driver.find_element(:name, 'commit').click
    assert element_exists?(:link, 'Users')
  end

  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end

  def element_exists?(how, what)
    !10.times do
      break if begin
                  element_present?(how, what)
               rescue StandardError
                 false
                end

      sleep 1
    end
  end
end
