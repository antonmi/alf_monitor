defmodule ALFMonitor.GraphTest do
  use ExUnit.Case, async: false

  alias ALFMonitor.Graph

  @test_data_1 [
    %{
      ips: [],
      manager_name: ALF.IntrospectionTest.SimplePipeline,
      name: :producer,
      pid: "#PID<0.232.0>",
      pipe_module: ALF.IntrospectionTest.SimplePipeline,
      pipeline_module: ALF.IntrospectionTest.SimplePipeline,
      subscribe_to: [],
      telemetry_enabled: false
    },
    %{
      count: 1,
      function: :add_one,
      module: ALF.IntrospectionTest.SimplePipeline,
      name: :add_one,
      number: 0,
      opts: [],
      pid: "#PID<0.233.0>",
      pipe_module: ALF.IntrospectionTest.SimplePipeline,
      pipeline_module: ALF.IntrospectionTest.SimplePipeline,
      subscribe_to: [{"#PID<0.232.0>", [max_demand: 1]}],
      subscribers: [{"#PID<0.234.0>", "#Reference<0.563406805.4136894468.129270>"}],
      telemetry_enabled: false
    },
    %{
      count: 1,
      function: :mult_two,
      module: ALF.IntrospectionTest.SimplePipeline,
      name: :mult_two,
      number: 0,
      opts: [],
      pid: "#PID<0.234.0>",
      pipe_module: ALF.IntrospectionTest.SimplePipeline,
      pipeline_module: ALF.IntrospectionTest.SimplePipeline,
      subscribe_to: [{"#PID<0.233.0>", [max_demand: 1]}],
      subscribers: [{"#PID<0.235.0>", "#Reference<0.563406805.4136894468.129275>"}],
      telemetry_enabled: false
    },
    %{
      manager_name: ALF.IntrospectionTest.SimplePipeline,
      name: :consumer,
      pid: "#PID<0.235.0>",
      pipe_module: ALF.IntrospectionTest.SimplePipeline,
      pipeline_module: ALF.IntrospectionTest.SimplePipeline,
      subscribe_to: [{"#PID<0.234.0>", [max_demand: 1]}],
      telemetry_enabled: false
    }
  ]

  describe "pipeline_to_graph" do
    test "nodes and edges" do
      {nodes, edges} = Graph.pipeline_to_graph(@test_data_1)
      assert length(nodes) == 4
      assert length(edges) == 3
    end
  end
end
