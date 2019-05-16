# frozen_string_literal: true

class Borough < ApplicationRecord
  def option_for_select
    [whole_name, self[:id]]
  end

  def whole_name
    self[:name] + '/' + self[:zone]
  end
end
