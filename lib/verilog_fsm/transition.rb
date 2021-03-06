module VerilogFSM
  class Transition
    include VerilogFSM::Options::InstanceMethods
    attr_accessor(:name, :from, :to, :event, :condition)
    
    def initialize(name, from, to, options = {})
      unless name && from && to
        raise ArgumentError.new("name, from and to are required but were '#{name}', '#{from}' and '#{to}'") 
      end
      assert_options(options, [:event, :condition])
      self.name      = name
      self.from      = from
      self.to        = to
      self.event     = Executable.new options[:event] if options.has_key?(:event)
      self.condition = Executable.new options[:condition] if options.has_key?(:condition)
    end
    
    def fire_event(target, args)
      self.event.execute(target, *args) if self.event
    end  
    
    def fire?(target, args)
      self.condition ? self.condition.execute(target, *args) : true
    end  
    
    def to_s
      event_s = " with event #{self.event}" unless self.event.nil?
      condition_s = " with condition #{self.condition}" unless self.condition.nil?

      "Transition from #{self.from.name} -> #{self.to.name}#{event_s}#{condition_s}"
    end  
    
    def to_dot(options = {})
      "#{self.from.name} -> #{self.to.name} [label=\"#{self.condition.to_s}\"]"
    end  
  end
end
