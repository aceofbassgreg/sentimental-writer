require 'sentimental'

class Sentimental::Processor
  
  attr_reader :str, :analyzer

  Sentimental.load_defaults

  def initialize(str)
    @str  = str
    @analyzer = Sentimental.new
  end

  def get_score
    analyzer.get_score(str)
  end

end