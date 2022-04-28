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
      subscribed_to: [],
      telemetry_enabled: true,
      type: :producer
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
      subscribed_to: [{"#PID<0.232.0>", "#Reference<0.563406805.4136894468.129270>"}],
      subscribers: [{"#PID<0.234.0>", "#Reference<0.563406805.4136894468.129270>"}],
      stage_set_ref: "stage_set_ref_add_one",
      telemetry_enabled: true,
      type: :stage
    },
    %{
      count: 2,
      function: :add_one,
      module: ALF.IntrospectionTest.SimplePipeline,
      name: :add_one,
      number: 1,
      opts: [],
      pid: "#PID<0.240.0>",
      pipe_module: ALF.IntrospectionTest.SimplePipeline,
      pipeline_module: ALF.IntrospectionTest.SimplePipeline,
      subscribed_to: [{"#PID<0.232.0>", "#Reference<0.563406805.4136894468.129270>"}],
      subscribers: [{"#PID<0.234.0>", "#Reference<0.563406805.4136894468.129270>"}],
      stage_set_ref: "stage_set_ref_add_one",
      telemetry_enabled: true,
      type: :stage
    },
    %{
      count: 2,
      function: :mult_two,
      module: ALF.IntrospectionTest.SimplePipeline,
      name: :mult_two,
      number: 0,
      opts: [],
      pid: "#PID<0.234.0>",
      pipe_module: ALF.IntrospectionTest.SimplePipeline,
      pipeline_module: ALF.IntrospectionTest.SimplePipeline,
      subscribed_to: [{"#PID<0.233.0>", "#Reference<0.563406805.4136894468.129275>"}],
      subscribers: [{"#PID<0.235.0>", "#Reference<0.563406805.4136894468.129275>"}],
      stage_set_ref: "stage_set_ref_mult_two",
      telemetry_enabled: true,
      type: :stage
    },
    %{
      count: 2,
      function: :mult_two,
      module: ALF.IntrospectionTest.SimplePipeline,
      name: :mult_two,
      number: 1,
      opts: [],
      pid: "#PID<0.241.0>",
      pipe_module: ALF.IntrospectionTest.SimplePipeline,
      pipeline_module: ALF.IntrospectionTest.SimplePipeline,
      subscribed_to: [{"#PID<0.233.0>", "#Reference<0.563406805.4136894468.129275>"}],
      subscribers: [{"#PID<0.235.0>", "#Reference<0.563406805.4136894468.129275>"}],
      stage_set_ref: "stage_set_ref_mult_two",
      telemetry_enabled: true,
      type: :stage
    },
    %{
      manager_name: ALF.IntrospectionTest.SimplePipeline,
      name: :consumer,
      pid: "#PID<0.235.0>",
      pipe_module: ALF.IntrospectionTest.SimplePipeline,
      pipeline_module: ALF.IntrospectionTest.SimplePipeline,
      subscribed_to: [{"#PID<0.234.0>", "#Reference<0.563406805.4136894468.129275>"}],
      telemetry_enabled: true,
      type: :consumer
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
