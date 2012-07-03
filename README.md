verilog_fsm
==

Based on Version 0.3.9 from [simplificator](https://github.com/simplificator/fsm)

FSM is a simple finite state machine class, which can be used to generate images and Verilog RTL.

Status
==
FSM is still under development so the API will change,

Usage
==
    
    class Water
      include VerilgoFSM
      attr_accessor(:state)

      # The state machine is specified as a block in define_fsm.
      define_fsm do
        # now define all the states
        # you can add :enter / :exit callbacks (callback can be a String, Symbol or Proc)
        # these callbacks are triggered on any transition from/to this state.
        
        states(:gas, :liquid) # shortcut to define several states but you can not specify callbacks
        state(:solid, :enter => :on_enter_solid, :exit => :on_exit_solid)
        
        # define all valid transitions (arguments are name of transition, from state name, to state name)
        # you can define callbacks which are called only on this transition as well as guards 
        # guards prevent transition when they return nil/false
        transition(:heat_up, :solid, :liquid, :event => :on_heat, :guard => :guard_something)
        transition(:heat_up, :liquid, :gas, :event => :on_heat)     # look mam.... two transitions with same name
        transition(:cool_down, [:gas, :liquid], :liquid, :event => :on_cool)
        
        # define the attribute which is used to store the state (defaults to :state)
        state_attribute(:state_of_material)
        
        # define the initial state (defaults to the first state defined - :gas in this sample)
        initial(:liquid)
      end
      
      private
      # callbacks here...
      def ...
      
      # 
      def guard_something()
        
      end
    end
    
    # then you can call these methods
    w = Water.new
    w.heat_up  # the name of the transition is the name of the method
    w.fsm_state_names
    w.fsm_next_transition_names
    w.cool_down # again... it's the name of the transition
    w.state_of_material
    w.state_liquid?
    w.state_solid?
    
    
Guards
==

Guards are methods or Procs which can prevent a transition. 
To do so they just need to return false/nil. If no guard is specified
then the transition is always executed.

## Callbacks and arguments
If the :enter/:exit callbacks are methods, then they are not
passed any arguments, if it's a Proc, then a single argument
(the caller) is passed. 

Short: :enter/:exit methods must take 0 arguments, :enter/:exit Procs must take one argument.

If :event and :guard callbacks are methods then they are passed 
all the arguments that were passed to the transition method. With 
Procs for :event and :guard the caller as well as all the arguments 
passed to the transition methods are passed.

   
Order of callbacks/guards calls
==

The callbacks/guards are called in following order if the guard returns __true__:
  * :exit (state)
  * :guard (transition)
  * :event (transition)
  * :enter (state) 
  
The callbacks/guards are called in following order if the guard returns __false__:
  * :exit (state)
  * :guard (transition)


Graphviz / Dot format
==

FSM supports the dot format of graphviz (http://www.graphviz.org/).
If you have the graphviz tools installed (the dot executable must be on the path) then
you can export a graph to png like this
    # Export to water.png in the current dir
    Water.draw_graph    
    # Export in another format. (see graphviz documentation for supported file formats)
    Water.draw_graph(:format => :foo)
    # Change the extension (defaults to the format)
    Water.draw_graph(:format => :jpg, :extension => :jpeg)
    # Specify a custom file
    Water.draw_graph(:outfile => '/afile.png')
  
Licence
==

    Copyright (c) 2012, Richard Castle
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
        * Redistributions of source code must retain the above copyright
          notice, this list of conditions and the following disclaimer.
        * Redistributions in binary form must reproduce the above copyright
          notice, this list of conditions and the following disclaimer in the
          documentation and/or other materials provided with the distribution.
        * Neither the name of the organization nor the
          names of its contributors may be used to endorse or promote products
          derived from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY
    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Based on Simplificator-fsm
Copyright (c) 2009 simplificator GmbH. See [LICENSE](https://github.com/simplificator/fsm/blob/master/LICENSE) for details.
