require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "should not create comment" do
    comment = Comment.new
    assert !comment.save
  end

  test 'should not find comment' do
    assert !Comment.exists?(:id => -1)
  end
end
