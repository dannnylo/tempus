# -*- encoding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Tempus" do
  before do
    @hours = Tempus.new(30.hours  + 5.minutes + 3.seconds)
    @negative_hours = Tempus.new(-30.hours  - 5.minutes - 3.seconds)
  end

  it "new" do
    @hours.should_not == nil
    @negative_hours.should_not == nil
  end

  it "set" do
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

  it "to_s" do
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

  it "String to Tempus" do
    "12:05:35".to_tempus.value.should == Tempus.new(12.hours  + 5.minutes + 35.seconds).value
    "01:00:01".to_tempus.value.should == Tempus.new(1.hours + 1.seconds).value
    "30:5:3".to_tempus.should == @hours
    "-30:5:3".to_tempus.should == @negative_hours
  end
end
