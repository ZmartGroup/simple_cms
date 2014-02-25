class DecoratingObject
  def initialize(name, parent=nil, klass=nil, attrs={})
    @name   = name
    @parent = parent
    @klass  = klass
    @attrs  = attrs
  end

  def method_missing(name, *args, &block)
    @attrs.has_key?(name.to_sym) ? @attrs[name.to_sym] : DecoratingObject.new(name, self)
  end

  def to_s
    (@parent.nil? ? "#{@name}" : "#{@parent}.#{@name}").upcase
  end

  def class
    @klass || DecoratingObject
  end
end
