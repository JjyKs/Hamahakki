require 'mechanize'
load 'widgets.rb'

class WidgetFinder
  attr_accessor :has_widgets

  def initialize src
    @src = src

    @widgets = Widgets.widgets
    @has_widgets = Array.new
    find_widgets
  end

  def find_widgets
    @widgets.each do |w|
      w[:identifiers].each do |str|
        if @src.include? str
          add_to_has_widgets w[:name]
        end
      end

    end

  end

  def add_to_has_widgets str
    unless @has_widgets.include? str
      @has_widgets.push str
    end
  end

end