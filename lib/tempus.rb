require "active_support/core_ext"

#Class to manipulate efficiently time
#=== Example:
## >>  horas = Tempus.new()
## => #<Tempus:0xb7016b40 @value=0.0>
class Tempus
  attr_accessor :value

  def initialize(value=0,count_all_time=false)
    set(value, count_all_time)
  end

  #Atribui o valor para o objeto
  ## Os valores podem ser passados em inteiros/floats ou Time.
  ## O parâmetro count_all_time se falso serve para transformar apenas a hora de um objeto da classe Time, desconsiderando a data.
  def set(value=0, count_all_time=false)
    if(value.class == Time && !count_all_time)
      @value = (value - value.beginning_of_day).to_f
    else
      @value = value.to_f
    end
  end

  #Formata o horário para HH:MM:SS .
  #=== Exemplo:
  ## >> horas = Tempus.new(30.hours  + 5.minutes + 3.seconds)
  ## => #<Tempus:0xb6e4b860 @value=108303.0>
  ## >> horas.to_s
  ## => "30:05:03"
  ## >> horas = Tempus.new(-30.hours  - 5.minutes - 3.seconds)
  ## => #<Tempus:0xb6e4b860 @value=-108303.0>
  ## >> horas.to_s
  ## => "-30:05:03"
  ## >> horas.to_s("%H:%M")
  ## => "-30:05"
  ## >> horas.to_s("%H*%M*%S")
  ## => "-30*05*03"
  def to_s(format="%H:%M:%S")
    h = ("%02d" % convert[0].to_i.abs)
    m = ("%02d" % convert[1].to_i.abs)
    s = ("%02d" % convert[2].to_i.abs)
    n = @value<0 ? "-" : ""
    str = format.to_s.gsub("%h","%H").gsub("%m","%M").gsub("%s","%S").gsub("%hh","%H").gsub("%mm","%M").gsub("%ss","%S")
    str.gsub!("%H",h)
    str.gsub!("%HH",h)
    str.gsub!("%M",m)
    str.gsub!("%MM",m)
    str.gsub!("%S",s)
    str.gsub!("%SS",s)
    str = n + str unless(str=="")
    str
  end

  def convert
    valor = @value.to_f
    h = (valor.to_f / 1.hour.to_f ).to_i
    valor = valor.to_f - h.hours.to_f
    m = (valor.to_f / 1.minute.to_f).to_i
    s = (valor.to_f - m.minutes.to_f).to_i
    return h,m,s
  end

  #Retorna o número de minutos
  def minutes
    convert[1]
  end

  #Retorna o número de segundos
  def seconds
    convert[2]
  end

  #Retorna o número de horas
  def hours
    convert[0]
  end

  def to_string
    self.to_s
  end

  #Criando método para conversão para segundos.
  def value_in_seconds
    @value.to_i
  end

  #Criando método para conversão para horas.
  def value_in_hours
    @value.to_i / 1.hour.to_f
  end

  #Criando método para conversão para horas.
  def value_in_minutes
    @value.to_i / 1.minute.to_f
  end

  def value_in_days
     @value.to_i / 1.day.to_f
  end

  def to_xls_time
    self.value_in_days
  end

  #Soma valores ao objeto
  def + v
    if(v.class == Tempus)
      Tempus.new(@value + v.value_in_seconds)
    elsif(v.class == NilClass)
      self
    elsif(v.class == String)
      Tempus.new(@value + v.to_tempus.value_in_seconds)
    else
      Tempus.new(@value + v)
    end
  end

  #Subtrai valores ao objeto
  def - v
    if(v.class == Tempus)
      Tempus.new(@value - v.value_in_seconds)
    elsif(v.class == NilClass)
      self
    elsif(v.class == String)
      Tempus.new(@value - v.to_tempus.value_in_seconds)
    else
      Tempus.new(@value - v)
    end
  end

  #Criando método para conversão para Inteiro
  def to_i
    value_in_seconds
  end

  #Método para verificar se o valor é negativo
  def negative?
    to_i < 0
  end

  #Método para verificar se o valor é positivo
  def positive?
    to_i >= 0
  end

  def human
    "#{"menos " if negative?}#{hours.abs} horas #{minutes.abs} minutos e #{seconds.abs} segundos"
  end

  def inspect
    "<Tempus:#{self.object_id} seconds=#{value}, formated=#{to_s}>"
  end

  def ==(object)
    if object.is_a?(Tempus)
      value == object.value
    else
      false
    end
  end
end


class Fixnum
  #Criando método para conversão da classe Fixnum
  def to_tempus
    Tempus.new(self)
  end
end

class Float
  #Criando método para conversão da classe Float
  def to_tempus
    Tempus.new(self)
  end
end

class Time
  #Criando método para conversão da classe Float
  def to_tempus(count_all_time=false)
    Tempus.new(self, count_all_time)
  end
end

class NilClass
  #Criando método para a classe nil
  def to_tempus
    Tempus.new(self)
  end
end

class String
  #Criando método para conversão da classe String
  def to_tempus
    str = (self).to_s.split(":")
    value = 0
    [:hours, :minutes, :seconds].each_with_index do |m, i|
      value += str.at(i).to_i.abs.send(m.to_s)
    end
    value = -value if str.to_s.include?('-')
    Tempus.new(value)
  end
end
