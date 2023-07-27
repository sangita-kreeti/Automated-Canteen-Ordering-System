# frozen_string_literal: true

# This is a model
class Message < ApplicationRecord
  belongs_to :channel
end
