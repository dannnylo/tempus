# frozen_string_literal: true

RSpec.describe Tempus do
  let(:hours) { described_class.new(30.hours + 5.minutes + 3.seconds) }
  let(:negative_hours) { described_class.new(- 30.hours - 5.minutes - 3.seconds) }

  it "has a version number" do
    expect(Tempus::VERSION).not_to be_nil
  end

  it "validates the object creation" do
    expect(hours).to be_instance_of(described_class)
    expect(negative_hours).to be_instance_of(described_class)
  end

  it "set value" do
    expect(hours.set(125)).to eq(125.0)
    expect(hours.set(Time.now.midnight)).to eq(0.0)
    expect(hours.to_s).to eq("00:00:00")
    expect(hours.to_s("%M:%S")).to eq("00:00")

    midnight = Time.now.midnight

    expect(described_class.new(0, only_hours: false).set(midnight)).to eq(midnight.to_i)
  end

  it "test output" do
    expect(hours.respond_to?(:to_s)).to be(true)
    expect(hours.to_s("")).to eq("")
    expect(hours.to_s).to eq("30:05:03")
    expect(hours.to_s("%H")).to eq("30")
    expect(hours.to_s("%M")).to eq("05")
    expect(hours.to_s("%S")).to eq("03")
    expect(hours.to_s("%Mdakhdkj$#")).to eq("05dakhdkj$#")
    expect(hours.to_s("Duration: %H:%M")).to eq("Duration: 30:05")
    expect(hours.to_s("%H:%M:%S")).to eq("30:05:03")
    expect(negative_hours.to_s("")).to eq("")
    expect(negative_hours.to_s).to eq("-30:05:03")
    expect(negative_hours.to_s("%H")).to eq("-30")
    expect(negative_hours.to_s("%M")).to eq("-05")
    expect(negative_hours.to_s("%S")).to eq("-03")
    expect(negative_hours.to_s("%Mdakhdkj$#")).to eq("-05dakhdkj$#")
    expect(negative_hours.to_s("Duration: %H:%M")).to eq("Duration: -30:05")
    expect(negative_hours.to_s("%H:%M:%S")).to eq("-30:05:03")
    expect(hours.human).to eq("30 horas 5 minutos e 3 segundos")
    expect(negative_hours.human).to eq("menos 30 horas 5 minutos e 3 segundos")
    expect(hours.positive?).to be(true)
    expect(hours.negative?).to be(false)
    expect(negative_hours.positive?).to be(false)
    expect(negative_hours.negative?).to be(true)
  end

  it "plus" do
    expect(hours.respond_to?(:+)).to be(true)

    [
      ["00:01:00", "30:06:03"],
      [1, "30:05:04"],
      [negative_hours, "00:00:00"],
      [1.hours, "31:05:03"],
      [5.hours, "35:05:03"],
      [1.minutes, "30:06:03"],
      [nil, "30:05:03"]
    ].each { |value, expected| expect((hours + value).to_s).to eq(expected) }
  end

  it "minus" do
    expect(hours.respond_to?(:-)).to be(true)

    [
      ["00:01:00", "30:04:03"],
      [1, "30:05:02"],
      [1.minutes, "30:04:03"],
      [1.hours, "29:05:03"],
      [5.hours, "25:05:03"],
      [nil, "30:05:03"],
      [negative_hours, "60:10:06"]
    ].each { |value, expected| expect((hours - value).to_s).to eq(expected) }
  end

  it "multiplication" do
    expect(hours.respond_to?(:*)).to be(true)

    expect(hours * 2).to eq("60:10:06".to_tempus)
    expect("10:00:00".to_tempus * 0.5).to eq("5:00:00".to_tempus)
  end

  it "division" do
    expect(hours.respond_to?(:/)).to be(true)

    expect((hours / 0.5).to_s).to eq("60:10:06")
    expect((hours / 2).to_s).to eq("15:02:31")
  end

  it "validates the value in methods" do
    expect(1.day.to_tempus.value_in_days).to eq(1)
    expect(1.day.to_tempus.to_xls_time).to eq(1)
    expect(2.hours.to_tempus.value_in_hours).to eq(2)
    expect(30.minutes.to_tempus.value_in_hours).to eq(0.5)
    expect(30.minutes.to_tempus.value_in_minutes).to eq(30)
  end
end
