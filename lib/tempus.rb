# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'

require 'tempus/version'
require 'tempus/parser'
require 'tempus/tempus_helper'

# Class to manipulate efficiently time
#=== Example:
## >>  duration = Tempus.new
## => #<Tempus:0xb7016b40 @data=0.0>
class Tempus
  class Error < StandardError; end

  HOURS_REGEX = /(\%h|\%hh|\%H|\%HH)/.freeze
  MINUTES_REGEX = /(\%m|\%mm|\%M|\%MM)/.freeze
  SECONDS_REGEX = /(\%s|\%ss|\%S|\%SS)/.freeze
  OPERATIONS = %i[+ - * /].freeze

  attr_reader :data

  delegate :to_i, :to_f, :negative?, :positive?, to: :data

  def initialize(value = 0, only_hours = true)
    @parser = Parser.new(only_hours)

    set(value)
  end

  def set(value)
    @data = @parser.parse(value)
  end

  # Format the duration to para HH:MM:SS .
  # === Sample:
  ## >> duration = Tempus.new(30.hours  + 5.minutes + 3.seconds)
  ## => #<Tempus:0xb6e4b860 @data=108303.0>
  ## >> duration.to_s
  ## => "30:05:03"
  ## >> duration = Tempus.new(-30.hours  - 5.minutes - 3.seconds)
  ## => #<Tempus:0xb6e4b860 @data=-108303.0>
  ## >> duration.to_s
  ## => "-30:05:03"
  ## >> duration.to_s("%H:%M")
  ## => "-30:05"
  ## >> duration.to_s("%H*%M*%S")
  ## => "-30*05*03"
  def to_s(string = '%H:%M:%S')
    text = string.dup

    text['%'] = '-%' if text != '' && negative?

    text = text.gsub(HOURS_REGEX, format_number_abs(hours))
    text = text.gsub(MINUTES_REGEX, format_number_abs(minutes))
    text.gsub(SECONDS_REGEX, format_number_abs(seconds))
  end

  alias to_string to_s

  def format_number_abs(number)
    format('%02d', number.to_i.abs)
  end

  def seconds
    ((data.to_f - hours.hour - minutes.minute) / 1.second).to_i
  end

  def minutes
    ((data.to_f - hours.hour) / 1.minute).to_i
  end

  def hours
    (data.to_f / 1.hour).to_i
  end

  alias value_in_seconds to_i

  # Convert value to hours.
  def value_in_hours
    to_i / 1.hour.to_f
  end

  # Convert value to minutes.
  def value_in_minutes
    to_i / 1.minute.to_f
  end

  def value_in_days
    to_i / 1.day.to_f
  end

  alias to_xls_time value_in_days

  def human
    [
      ('menos' if negative?),
      "#{hours.abs} horas",
      "#{minutes.abs} minutos",
      'e',
      "#{seconds.abs} segundos"
    ].compact.join(' ')
  end

  def inspect
    "<Tempus seconds=#{data}, formated=#{self}>"
  end

  def ==(other)
    return false unless other.is_a?(Tempus)

    data == other.data
  end

  def method_missing(method_name, *args, &block)
    return super unless OPERATIONS.include?(method_name)

    @data.send(method_name, @parser.parse(args.first)).to_tempus
  end

  def respond_to_missing?(method_name, include_private = false)
    OPERATIONS.include?(method_name.to_sym) || super
  end
end
