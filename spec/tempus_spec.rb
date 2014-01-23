# -*- encoding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Tempus" do
  before do
    @hours = Tempus.new(30.hours  + 5.minutes + 3.seconds)
    @negative_hours = Tempus.new(-30.hours  - 5.minutes - 3.seconds)
  end

  it "validates the object creation" do
    @hours.should_not == nil
    @negative_hours.should_not == nil
  end

  it "set value" do
    hours = @hours.clone
    hours.object_id.should_not == @hours.object_id
    hours.set(125).should == 125.0
    hours.to_s.should == "00:02:05"
    hours.value_in_seconds.should == 125
    hours.set(Time.now.midnight).should == 0.0
    hours.value_in_seconds.should == 0
    hours.to_s.should == "00:00:00"
    hours.set(Time.now.midnight,true).should == Time.now.midnight.to_i
    hours.to_s("%M:%S").should == "00:00"
  end

  it "test output" do
    @hours.respond_to?("to_s").should == true
    @hours.to_s("").should == ""
    @hours.to_s().should == "30:05:03"
    @hours.to_s("%H").should == "30"
    @hours.to_s("%M").should == "05"
    @hours.to_s("%S").should == "03"
    @hours.to_s("%Mdakhdkj$#").should ==  "05dakhdkj$#"
    @hours.to_s("hours Utilizadas: %H:%M").should == "hours Utilizadas: 30:05"
    @hours.to_s("%H:%M:%S").should == "30:05:03"
    @negative_hours.to_s("").should == ""
    @negative_hours.to_s().should == "-30:05:03"
    @negative_hours.to_s("%H").should == "-30"
    @negative_hours.to_s("%M").should == "-05"
    @negative_hours.to_s("%S").should == "-03"
    @negative_hours.to_s("%Mdakhdkj$#").should ==  "-05dakhdkj$#"
    #Por enquanto existe este bug
    @negative_hours.to_s("hours Utilizadas: %H:%M").should == "-hours Utilizadas: 30:05" #FIXME: Corrigir este problema.
    @negative_hours.to_s("%H:%M:%S").should == "-30:05:03"

    @hours.human.should == "30 horas 5 minutos e 3 segundos"
    @negative_hours.human.should == "menos 30 horas 5 minutos e 3 segundos"

    @hours.positive?.should == true
    @hours.negative?.should == false

    @negative_hours.positive?.should == false
    @negative_hours.negative?.should == true

  end

  it "plus" do
    (@hours + "00:01:00").to_s.should == "30:06:03"
    (@hours + 1).to_s.should == "30:05:04"
    (@hours + 1.minutes).to_s.should == "30:06:03"
    (@hours + 1.hours).to_s.should == "31:05:03"
    (@hours + 5.hours).to_s.should == "35:05:03"
    (@hours + nil).to_s.should == "30:05:03"
    (@hours + @negative_hours).to_s.should == "00:00:00"
  end

  it "minus" do
    (@hours - "00:01:00").to_s.should == "30:04:03"
    (@hours - 1).to_s.should == "30:05:02"
    (@hours - 1.minutes).to_s.should == "30:04:03"
    (@hours - 1.hours).to_s.should == "29:05:03"
    (@hours - 5.hours).to_s.should == "25:05:03"
    (@hours - nil).to_s.should == "30:05:03"
    (@hours - @negative_hours ).to_s.should == "60:10:06"
  end

  it "validates the value in methods" do
    1.day.to_tempus.value_in_days.should == 1
    1.day.to_tempus.to_xls_time.should == 1
    2.hours.to_tempus.value_in_hours.should == 2
    30.minutes.to_tempus.value_in_hours.should == 0.5
    30.minutes.to_tempus.value_in_minutes.should == 30
  end


  describe "Other Class" do
    it "String to Tempus" do
      "12:05:35".to_tempus.value.should == Tempus.new(12.hours  + 5.minutes + 35.seconds).value
      "01:00:01".to_tempus.value.should == Tempus.new(1.hours + 1.seconds).value
      "30:5:3".to_tempus.should == @hours
      "-30:5:3".to_tempus.should == @negative_hours
    end

    it "Fixnum to Tempus" do
      3723.to_tempus.to_s.should == "01:02:03"
      3723.to_tempus.inspect.should == "<Tempus seconds=3723.0, formated=01:02:03>"
    end

    it "Float to Tempus" do
      3723.0.to_tempus.to_string.should == "01:02:03"
    end

    it "Time to Tempus" do
      Time.parse("2014-01-01 01:02:03").to_tempus.to_i.should == 3723
    end

    it "nil to Tempus" do
      nil.to_tempus.value.should == 0
    end
  end
end
