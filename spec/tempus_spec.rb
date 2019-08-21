# frozen_string_literal: true

RSpec.describe Tempus do
  let(:hours) { Tempus.new(30.hours + 5.minutes + 3.seconds) }
  let(:negative_hours) { Tempus.new(- 30.hours - 5.minutes - 3.seconds) }

  it 'has a version number' do
    expect(Tempus::VERSION).not_to be nil
  end

  it 'validates the object creation' do
    expect(hours).to be_instance_of(Tempus)
    expect(negative_hours).to be_instance_of(Tempus)
  end

  it 'set value' do
    expect(hours.set(125)).to eq(125.0)
    expect(hours.to_s).to eq('00:02:05')
    expect(hours.value_in_seconds).to eq(125)
    expect(hours.set(Time.now.midnight)).to eq(0.0)
    expect(hours.value_in_seconds).to eq(0)
    expect(hours.to_s).to eq('00:00:00')
    expect(hours.set(Time.now.midnight, false)).to eq(Time.now.midnight.to_i)
    expect(hours.to_s('%M:%S')).to eq('00:00')
  end

  it 'test output' do
    expect(hours.respond_to?('to_s')).to eq(true)
    expect(hours.to_s('')).to eq('')
    expect(hours.to_s).to eq('30:05:03')
    expect(hours.to_s('%H')).to eq('30')
    expect(hours.to_s('%M')).to eq('05')
    expect(hours.to_s('%S')).to eq('03')
    expect(hours.to_s('%Mdakhdkj$#')).to eq('05dakhdkj$#')
    expect(hours.to_s('hours Utilizadas: %H:%M')).to eq('hours Utilizadas: 30:05')
    expect(hours.to_s('%H:%M:%S')).to eq('30:05:03')
    expect(negative_hours.to_s('')).to eq('')
    expect(negative_hours.to_s).to eq('-30:05:03')
    expect(negative_hours.to_s('%H')).to eq('-30')
    expect(negative_hours.to_s('%M')).to eq('-05')
    expect(negative_hours.to_s('%S')).to eq('-03')
    expect(negative_hours.to_s('%Mdakhdkj$#')).to eq('-05dakhdkj$#')
    expect(negative_hours.to_s('hours Utilizadas: %H:%M')).to eq('hours Utilizadas: -30:05')
    expect(negative_hours.to_s('%H:%M:%S')).to eq('-30:05:03')
    expect(hours.human).to eq('30 horas 5 minutos e 3 segundos')
    expect(negative_hours.human).to eq('menos 30 horas 5 minutos e 3 segundos')
    expect(hours.positive?).to eq(true)
    expect(hours.negative?).to eq(false)
    expect(negative_hours.positive?).to eq(false)
    expect(negative_hours.negative?).to eq(true)
  end

  it 'plus' do
    expect((hours + '00:01:00').to_s).to eq('30:06:03')
    expect((hours + 1).to_s).to eq('30:05:04')
    expect((hours + 1.minutes).to_s).to eq('30:06:03')
    expect((hours + 1.hours).to_s).to eq('31:05:03')
    expect((hours + 5.hours).to_s).to eq('35:05:03')
    expect((hours + nil).to_s).to eq('30:05:03')
    expect((hours + negative_hours).to_s).to eq('00:00:00')
  end

  it 'minus' do
    expect((hours - '00:01:00').to_s).to eq('30:04:03')
    expect((hours - 1).to_s).to eq('30:05:02')
    expect((hours - 1.minutes).to_s).to eq('30:04:03')
    expect((hours - 1.hours).to_s).to eq('29:05:03')
    expect((hours - 5.hours).to_s).to eq('25:05:03')
    expect((hours - nil).to_s).to eq('30:05:03')
    expect((hours - negative_hours).to_s).to eq('60:10:06')
  end

  it 'validates the value in methods' do
    expect(1.day.to_tempus.value_in_days).to eq(1)
    expect(1.day.to_tempus.to_xls_time).to eq(1)
    expect(2.hours.to_tempus.value_in_hours).to eq(2)
    expect(30.minutes.to_tempus.value_in_hours).to eq(0.5)
    expect(30.minutes.to_tempus.value_in_minutes).to eq(30)
  end

  it 'validates the value in methods' do
    expect(1.day.to_tempus.value_in_days).to eq(1)
    expect(1.day.to_tempus.to_xls_time).to eq(1)
    expect(2.hours.to_tempus.value_in_hours).to eq(2)
    expect(30.minutes.to_tempus.value_in_hours).to eq(0.5)
    expect(30.minutes.to_tempus.value_in_minutes).to eq(30)
  end
end
