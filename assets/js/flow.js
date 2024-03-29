import React, { useMemo } from 'react';
import ReactFlow, { MiniMap, Controls, useNodesState, useEdgesState } from 'react-flow-renderer';
import store from './store'
import { Provider } from 'react-redux'
import { useDispatch } from 'react-redux';
import {
  selectComponent
} from './storage';

import dagre from 'dagre';

import Sidebar from "./sidebar";

const graphStyles = { height: "800px" };


const dagreGraph = new dagre.graphlib.Graph();
dagreGraph.setDefaultEdgeLabel(() => ({}));


const initialNodes = window.nodes
const initialEdges = window.edges

import './index.css';

import componentNode from "./componentNode";

const getLayoutedElements = (nodes, edges) => {
  dagreGraph.setGraph({ rankdir: 'LR', align: 'DR'});

  nodes.forEach((node) => {
    dagreGraph.setNode(node.id, { width: node.data.width, height: node.data.height });
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
      x: nodeWithPosition.x - node.data.width / 2,
      y: nodeWithPosition.y - node.data.height / 2
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

  const nodeTypes = useMemo(() => ({ componentNode: componentNode }), []);
  const onInit = (instance) => window.flowInstance = instance;

  const dispatch = useDispatch();

  const onNodeClick = function (event, node) {
    const action = {id: node.id, data: node.data}
    dispatch(selectComponent(action))
  }


  return (
    <div className="layoutflow flex-child grid-66">
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
        fitView={true}
        maxZoom={2.0}
        defaultZoom={0.5}
        minZoom={0.1}
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
      <Sidebar />
    </Provider>
  );
}

export default initFlow
