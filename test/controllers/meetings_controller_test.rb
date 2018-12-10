require 'test_helper'

class MeetingsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @meeting = meetings(:one)
  end

  test "should get index when signed in" do
    sign_in users(:one)
    get meetings_url
    assert_response :success
  end

  test "should redirect get when not signed in" do
    get meetings_url
    assert_redirected_to new_user_session_url
  end

  test "should get new when signed in" do
    sign_in users(:one)
    get new_meeting_url
    assert_response :success
  end

  test "should redirect new when not signed in" do
    get new_meeting_url
    assert_redirected_to new_user_session_url
  end

  test "should create meeting when signed in" do
    sign_in users(:one)
    assert_difference('Meeting.count') do
      post meetings_url, params: { meeting: { end_time: @meeting.end_time, name: @meeting.name, start_time: @meeting.start_time, user_id: @meeting.user_id } }
    end
    assert_redirected_to meeting_url(Meeting.last)
  end

  test "should not create meeting when not signed in" do
    assert_no_difference('Meeting.count') do
      post meetings_url, params: { meeting: { end_time: @meeting.end_time, name: @meeting.name, start_time: @meeting.start_time, user_id: @meeting.user_id } }
    end
    assert_redirected_to new_user_session_url
  end

  test "should not show meeting when signed in" do
    sign_in users(:one)
    get meeting_url(:en, @meeting)
    assert_response :error
  end

  test "should reddirect show meeting when not signed in" do
    get meeting_url(:en, @meeting)
    assert_redirected_to new_user_session_url 
  end

  test "should get edit when user signed in" do
    sign_in users(:one)
    get edit_meeting_url(:en, @meeting)
    assert_response :success
  end

  test "should redirect get edit when user not signed in" do
    get edit_meeting_url(:en, @meeting)
    assert_redirected_to new_user_session_url 
  end

  test "should update meeting when user signed in" do
    sign_in users(:one)
    patch meeting_url(:en, @meeting), params: { meeting: { end_time: @meeting.end_time, name: @meeting.name, start_time: @meeting.start_time, user_id: @meeting.user_id } }
    assert_response :success
  end

  test "should redirect update meeting when user not signed in" do
    patch meeting_url(:en, @meeting), params: { meeting: { end_time: @meeting.end_time, name: @meeting.name, start_time: @meeting.start_time, user_id: @meeting.user_id } }
    assert_redirected_to new_user_session_url 
  end

  test "should destroy meeting when user signed in" do
    sign_in users(:one)
    assert_difference('Meeting.count', -1) do
      delete meeting_url(:en, @meeting)
    end
    assert_redirected_to meetings_url
  end

  test "should redirect destroy meeting when user not signed in" do
    assert_no_difference('Meeting.count') do
      delete meeting_url(:en, @meeting)
    end
    assert_redirected_to new_user_session_url
  end
end
