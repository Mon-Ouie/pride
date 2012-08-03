module Pride
  # RubyVariants are only used to allow Pride to pass around arbitrary objects
  # through Qt's signal system which only allows to pass Qt objects.
  #
  # @example Sending a RubyVariant
  #   emit foo(RubyVariant.new(obj))
  #
  # @example Receiving a RubyVariant
  #    connect SIGNAL("foo(QVariant)") do |var|
  #      obj = var.value
  #      p obj
  #    end
  class RubyVariant < Qt::Variant
    def initialize(object)
      super()
      @value = object
    end

    # @return [Object]
    attr_accessor :value
  end
end
