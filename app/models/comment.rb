# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :meeting
  belongs_to :user
end
