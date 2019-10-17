# frozen_string_literal: true

# Helper to inject tempus transformation to all objects
module TempusHelper
  def to_tempus
    Tempus.new(self)
  end
end

Object.include(TempusHelper)
