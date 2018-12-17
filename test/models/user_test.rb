# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should not create user' do
    user = User.new
    assert !user.save
  end

  test 'should find user' do
    assert User.exists?(email: 'test@test.ru')
  end

  test 'should not save with same fields' do
    user = User.new
    user.email = 'test@test.ru'
    assert !user.save
  end
end
