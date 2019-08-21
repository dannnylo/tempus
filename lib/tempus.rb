# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'

require 'tempus/version'
require 'tempus/tempus_helper'

# Class to manipulate efficiently time
#=== Example:
## >>  duration = Tempus.new
## => #<Tempus:0xb7016b40 @data=0.0>
class Tempus
  class Error < StandardError; end

  HOURS_REGEX = /(\%h|\%hh|\%H|%HH)/.freeze
  MINUTES_REGEX = /(\%m|\%mm|\%M|%MM)/.freeze
  SECONDS_REGEX= /(\%s|\%ss|\%S|%SS)/.freeze

  attr_accessor :data

  delegate :to_i, :to_f, :negative?, :positive?, to: :data

  def initialize(value = 0, only_hours = true)
    @data = transform(value, only_hours)
  end

  def set(value, only_hours = true)
    @data = transform(value, only_hours)
  end

  def transform(value, only_hours = true)
    return from_string(value).to_f if value.is_a?(String)
    return from_time(value, only_hours).to_f if value.is_a?(Time)

    value.to_f
  end

  def from_string(value)
    str = value.to_s.split(':')
    value = 0

    %i[hours minutes seconds].each_with_index do |m, i|
      value += str.at(i).to_i.abs.send(m.to_s)
    end

    str.to_s.include?('-') ? value * -1 : value
  end

  def from_time(value, only_hours = true)
    (only_hours ? value - value.beginning_of_day : value).to_f
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

    return '' if text == ''

    text['%'] = '-%' if negative?

    text.gsub(HOURS_REGEX, format('%02d', hours.to_i.abs))
      .gsub(MINUTES_REGEX, format('%02d', minutes.to_i.abs))
      .gsub(SECONDS_REGEX, format('%02d', seconds.to_i.abs))
  end

  alias to_string to_s

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

  # Criando método para conversão para horas.
  def value_in_hours
    to_i / 1.hour.to_f
  end

  # Criando método para conversão para horas.
  def value_in_minutes
    to_i / 1.minute.to_f
  end

  def value_in_days
    to_i / 1.day.to_f
  end

  alias to_xls_time value_in_days

  # Soma valores ao objeto
  def +(other)
    Tempus.new(data + transform(other))
  end

  # Subtrai valores ao objeto
  def -(other)
    Tempus.new(data - transform(other))
  end

  def human
    "#{'menos ' if negative?}#{hours.abs} horas #{minutes.abs} minutos e #{seconds.abs} segundos"
  end

  def inspect
    "<Tempus seconds=#{data}, formated=#{self}>"
  end

  def ==(object)
    return false unless object.is_a?(Tempus)

    data == object.data
  end
end
