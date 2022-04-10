import React, { useState, useCallback, useMemo } from 'react';
import ReactFlow, { Handle, Position, MiniMap, Controls, addEdge, useNodesState, useEdgesState } from 'react-flow-renderer';


const graphStyles = { width: "1600px", height: "800px" };

import dagre from 'dagre';

const dagreGraph = new dagre.graphlib.Graph();
dagreGraph.setDefaultEdgeLabel(() => ({}));


const initialNodes = window.nodes
const initialEdges = window.edges

import './index.css';

import {nodeWidth, nodeHeight} from "./component-node";
import ComponentNode from "./component-node";

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

  return (
    <div className="layoutflow">
      <ReactFlow
        nodes={nodes}
        edges={edges}
        onNodesChange={onNodesChange}
        onEdgesChange={onEdgesChange}
        connectionLineType="smoothstep"
        style={graphStyles}
        nodeTypes={nodeTypes}
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
  const container = document.getElementById('root');
  const root = createRoot(container);
  root.render(<Flow/>);
}

export default initFlow
