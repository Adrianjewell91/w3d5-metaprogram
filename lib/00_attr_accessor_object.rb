class AttrAccessorObject
  def self.my_attr_accessor(*names)
    # ...
    #Should be creating getter methods for instnace variables.

    names.each do |name|
      define_method("#{name}") do
        instance_variable_get("@#{name}") #call the @ equivalent.
      end

      define_method("#{name}=") do |val|
        instance_variable_set("@#{name}", val) #don't stick the '=' sign in the setter.
      end
    end
  end
end
