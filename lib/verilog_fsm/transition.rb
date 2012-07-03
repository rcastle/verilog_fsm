module VerilogFSM
  class Transition
    include VerilogFSM::Options::InstanceMethods
    attr_accessor(:name, :from, :to, :event, :guard)
    
    def initialize(name, from, to, options = {})
      unless name && from && to
        raise ArgumentError.new("name, from and to are required but were '#{name}', '#{from}' and '#{to}'") 
      end
      assert_options(options, [:event, :guard])
      self.name  = name
      self.from  = from
      self.to    = to
      self.event = Executable.new options[:event] if options.has_key?(:event)
      self.guard = Executable.new options[:guard] if options.has_key?(:guard)
    end
    
    def fire_event(target, args)
      self.event.execute(target, *args) if self.event
    end  
    
    def fire?(target, args)
      self.guard ? self.guard.execute(target, *args) : true
    end  
    
    def to_s
      event_s = " with event #{self.event}" unless self.event.nil?
      guard_s = " with guard #{self.guard}" unless self.guard.nil?

      "Transition from #{self.from.name} -> #{self.to.name}#{event_s}#{guard_s}"
    end  
    
    def to_dot(options = {})
      "#{self.from.name} -> #{self.to.name} [label=\"#{self.name}\"]"
    end  
  end
end
