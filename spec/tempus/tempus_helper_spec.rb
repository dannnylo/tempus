# frozen_string_literal: true

RSpec.describe TempusHelper do
  let(:hours) { Tempus.new(30.hours + 5.minutes + 3.seconds) }
  let(:negative_hours) { Tempus.new(- 30.hours - 5.minutes - 3.seconds) }
  let(:inspect_output) { "<Tempus seconds=3723.0, formated=01:02:03>" }

  it "String to Tempus" do
    expect("12:05:35".to_tempus).to eq(Tempus.new(12.hours + 5.minutes + 35))
    expect("01:00:01".to_tempus).to eq(Tempus.new(1.hours + 1.seconds))
    expect("30:5:3".to_tempus).to eq(hours)
    expect("-30:5:3".to_tempus).to eq(negative_hours)
  end

  it "Number to Tempus" do
    expect(3723.to_tempus.to_s).to eq("01:02:03")
    expect(3723.to_tempus.inspect).to eq(inspect_output)
  end

  it "Float to Tempus" do
    expect(3723.0.to_tempus.to_string).to eq("01:02:03")
  end

  it "Time to Tempus" do
    expect(Time.parse("2014-01-01 01:02:03").to_tempus.to_i).to eq(3723)
  end

  it "nil to Tempus" do
    expect(nil.to_tempus.data).to eq(0)
  end
end
