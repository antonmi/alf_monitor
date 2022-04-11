import React from 'react';
import {Handle, Position} from "react-flow-renderer";

export const nodeWidth = 160;
export const nodeHeight = 120;

function splitLabel(label) {
  const parts = label.split("_")

  return parts.join("_ ")
}

function componentNode({ data }) {
  const src = "images/" + data.type + ".png"
  const labelClass = data.type == 'stage' ? 'component-label-stage' : 'component-label'

  const label = splitLabel(data.name)

  return (
    <>
      <div className={'component'} style={{width: nodeWidth, height: nodeHeight}}>
        <Handle type="target" position={Position.Right} />

        <label className={labelClass}>{label}</label>
        <img src={src} width={nodeWidth} height={nodeHeight}/>

        <Handle type="source" position={Position.Left} />
      </div>
    </>
  );
}

export default componentNode
