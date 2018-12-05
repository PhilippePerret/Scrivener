# encoding: UTF-8
=begin
  Pour gérer souplement les surfaces
=end
class Surface
  attr_accessor :point_TL, :point_BR
  # +data+ est une donnée ressemblant soit à :
  #   "{{toplefttop, topleftleft}, {botleftbot, botleftleft}}"
  # Soit à:
  #   [[toplefttop, topleftleft], [botleftbot, botleftleft]]
  # 
  def initialize data
    if data.is_a?(String)
      data = data.gsub(/\{/,'[').gsub(/\}/,']')
      data = eval(data)
    end
    self.point_TL = Point.new(data[0])
    self.point_BR = Point.new(data[1])
  end
  def to_plist
    @to_plist ||= '{%s, %s}' % [point_TL.to_plist, point_BR.to_plist]
  end
  class Point
    attr_accessor :top, :left
    def initialize data
      self.top  = data[0]
      self.left = data[1]
    end
    def to_plist
      @to_plist ||= "{#{top}, #{left}}"
    end
  end #/Point
end #/Surface
