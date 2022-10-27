# frozen_string_literal: true

# Parser others types to value
class Parser
  def initialize(only_hours: true)
    @only_hours = only_hours
  end

  def parse(value)
    @value = value

    case @value
    when String
      from_string.to_f
    when Time
      from_time.to_f
    else
      @value.to_f
    end
  end

  private

  def from_time
    return @value.to_f unless @only_hours

    (@value - @value.beginning_of_day).to_f
  end

  def from_string
    str = @value.to_s.split(':')
    value = 0

    %i[hours minutes seconds].each_with_index do |m, i|
      value += str.at(i).to_i.abs.send(m.to_s)
    end

    str.to_s.include?('-') ? value * -1 : value
  end
end
