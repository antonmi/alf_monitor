import React, { useState, useCallback, useEffect, useMemo } from 'react';
import ReactFlow, { Handle, Position, MiniMap, Controls, addEdge, useNodesState, useEdgesState } from 'react-flow-renderer';
import store from './store'
import { Provider } from 'react-redux'
import { useSelector, useDispatch } from 'react-redux';
import {
  decrement,
  increment,
  incrementByAmount,
  selectCount,
  selectComponent
} from './counterSlice';

import dagre from 'dagre';

import Sidebar from "./sidebar";

const graphStyles = { width: "1000px", height: "600px" };


const dagreGraph = new dagre.graphlib.Graph();
dagreGraph.setDefaultEdgeLabel(() => ({}));


const initialNodes = window.nodes
const initialEdges = window.edges

import './index.css';

import {nodeWidth, nodeHeight} from "./componentNode";
import ComponentNode from "./componentNode";

const getLayoutedElements = (nodes, edges) => {
  dagreGraph.setGraph({ rankdir: 'LR' });

  nodes.forEach((node) => {
    dagreGraph.setNode(node.id, { width: nodeWidth, height: nodeHeight });
  });

  edges.forEach((edge) => {
    dagreGraph.setEdge(edge.target, edge.source);
  });

  dagre.layout(dagreGraph);

  nodes.forEach((node) => {
    const nodeWithPosition = dagreGraph.node(node.id);
    node.targetPosition = 'left';
    node.sourcePosition = 'right';

    // We are shifting the dagre node position (anchor=center center) to the top left
    // so it matches the React Flow node anchor point (top left).
    node.position = {
      x: nodeWithPosition.x - nodeWidth / 2,
      y: nodeWithPosition.y - nodeHeight / 2,
    };

    return node;
  });

  return { nodes, edges };
};

const { nodes: layoutedNodes, edges: layoutedEdges } = getLayoutedElements(
  initialNodes,
  initialEdges
);

const Flow = () => {
  const [nodes, setNodes, onNodesChange] = useNodesState(layoutedNodes);
  const [edges, setEdges, onEdgesChange] = useEdgesState(layoutedEdges);

  const nodeTypes = useMemo(() => ({ customNode: ComponentNode }), []);
  const onInit = (instance) => window.flowInstance = instance;

  const dispatch = useDispatch();

  const onNodeClick = function (event, node) {
    dispatch(incrementByAmount(10))
    const action = {id: node.id, data: node.data}
    dispatch(selectComponent(action))
  }


  return (
    <div className="layoutflow flex-child">
      <ReactFlow
        onInit={onInit}
        nodes={nodes}
        edges={edges}
        onNodesChange={onNodesChange}
        onEdgesChange={onEdgesChange}
        connectionLineType="smoothstep"
        style={graphStyles}
        nodeTypes={nodeTypes}
        nodesDraggable={false}
        onNodeClick={onNodeClick}
        maxZoom={2.0}
        defaultZoom={0.5}
        minZoom={0.3}
      >
        <MiniMap />
        <Controls />
      </ReactFlow>
    </div>
  );
};



import { createRoot } from 'react-dom/client';

function initFlow() {
  const container = document.getElementById('app');
  const root = createRoot(container);
  root.render(
    <Provider store={store}>
      <Flow/>
      <Sidebar/>
    </Provider>
  );
}

export default initFlow
