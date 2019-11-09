package main

import (
   "eossdk"
   "fmt"
)


// HelloWorld agent interface
type HelloWorld interface {
   IsHelloWorld()
}

// helloWorld agent
type helloWorld struct {
   mgr eossdk.AgentMgr
   tracer eossdk.Tracer
}

// make sure helloWorld is a HelloWorld
func (hw helloWorld) IsHelloWorld() {}

func (hw helloWorld) On_initialized() {
   hw.tracer.Trace0("Initialized")
   name := hw.mgr.Agent_option("name")
   if name == "" {
      hw.mgr.Status_set("greeting", "Welcome! What is your name?")
   } else {
      hw.On_agent_option("name", name)
   }
}

func (hw helloWorld) On_agent_enabled(enabled bool) {
   if !enabled {
      hw.tracer.Trace0("Shutting down")
      hw.mgr.Status_set("greeting", "Adios!")
      hw.mgr.Agent_shutdown_complete_is(true)
   }
}

func (hw helloWorld) On_agent_option(key string, val string) {
   if key == "name" {
      if val == "" {
         hw.tracer.Trace3("Name deleted")
         hw.mgr.Status_set("greeting", "Goodbye!")
      } else {
         hw.tracer.Trace3(fmt.Sprintf("Saying hi to %s", val))
         hw.mgr.Status_set("greeting", fmt.Sprintf("Hello %s!", val))
      }
   }
}

func NewHelloWorld(sdk eossdk.Sdk) HelloWorld {
   // Get mgr
   mgr := sdk.Get_agent_mgr()
   // Create tracer
   tracer := eossdk.NewTracer("HelloWorldGoAgent")
   agent := helloWorld{mgr: mgr, tracer: tracer}
   tracer.Trace0("Go agent constructed")
   // initialize handler
   _ = eossdk.NewDirectorAgent_handler(agent, mgr)

   return &agent
}

func main() {
   sdk := eossdk.NewSdk()
   name := sdk.Name()
   fmt.Printf("daemon name is %s\n", name)

   argv := "foo"
   _ = NewHelloWorld(sdk)

   sdk.Main_loop(1, &argv)
}
