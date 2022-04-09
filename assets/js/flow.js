import React from 'react';
import { useState } from 'react';
import ReactFlow, { MiniMap, Controls } from 'react-flow-renderer';

import { initialNodes, initialEdges } from './nodes-edges.js';
import './index.css';

const graphStyles = { width: "1000px", height: "500px" };

import dagre from 'dagre';

const dagreGraph = new dagre.graphlib.Graph();
dagreGraph.setDefaultEdgeLabel(() => ({}));

const nodeWidth = 172;
const nodeHeight = 36;


function Flow() {
  const [nodes, setNodes] = useState(initialNodes);
  const [edges, setEdges] = useState(initialEdges);

  const onInit = function(instance) {
    window.reactFlow = instance
  }

  return (
    <ReactFlow
      nodes={nodes}
      edges={edges}
      style={graphStyles}
      fitView
      onInit={onInit}
    >
      <MiniMap />
      <Controls />
    </ReactFlow>
  );
}


import { createRoot } from 'react-dom/client';

function initFlow() {
  const container = document.getElementById('root');
  const root = createRoot(container);
  root.render(<Flow/>);
}

export default initFlow
