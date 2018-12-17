# frozen_string_literal: true

require 'test_helper'

class MeetingTest < ActiveSupport::TestCase
  test 'should not create meeting' do
    meeting = Meeting.new
    meeting.start_time = Time.now
    meeting.end_time = Time.now + 100
    assert !meeting.save
  end

  test 'should not find meeting' do
    assert !Meeting.exists?(id: -1)
  end

  test 'should not save with time mistake' do
    meeting = Meeting.new
    meeting.start_time = Time.now
    meeting.end_time = Time.now - 1
    assert !meeting.save
  end

  test 'should not save with time before now' do
    meeting = Meeting.new
    meeting.start_time = Time.now - 1
    meeting.end_time = Time.now
    assert !meeting.save
  end
end
