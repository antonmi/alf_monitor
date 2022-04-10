import React from 'react';
import {Handle, Position} from "react-flow-renderer";

export const nodeWidth = 160;
export const nodeHeight = 120;


function ComponentNode({ data }) {
  const src = "images/" + data.type + ".png"
  const labelClass = data.type == 'stage' ? 'component-label-stage' : 'component-label'


  return (
    <>
      <div>
        <Handle type="target" position={Position.Right} />

        <label className={labelClass}>{data.label}</label>
        <img src={src} width={nodeWidth} height={nodeHeight}/>

        <Handle type="source" position={Position.Left} />
      </div>
    </>
  );
}

export default ComponentNode
