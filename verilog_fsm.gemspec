# -*- encoding: utf-8 -*-
GEMNAME="verilog_fsm"
require File.join( File.dirname(__FILE__), 'lib', GEMNAME )

Gem::Specification.new do |s|
  s.name      = GEMNAME
  s.version   = VerilogFSM::VERSION
  s.platform  = Gem::Platform::RUBY
  s.authors   = ["Richard Castle"]
  s.email     = "richard.castle156@gmail.com" 
  
  s.homepage  = %q{http://github.com/rcastle/verilog_fsm}
  s.summary   = %q{FSM (Finite State Machine) class for generating Verilog RTL and diagrams}
  s.has_rdoc  = false

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

