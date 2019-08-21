module TempusHelper
  def to_tempus
    Tempus.new(self)
  end
end

Object.send(:include, TempusHelper)
