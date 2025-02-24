# frozen_string_literal: true

module Helpers
  include ApplicationHelper
end

RSpec.configure do |config|
  config.include Helpers
end
