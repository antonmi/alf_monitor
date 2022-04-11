import React from 'react';
import {Handle, Position} from "react-flow-renderer";

import { useSelector, useDispatch } from 'react-redux';

import {
  getComponentId,
  getComponentData,
  getActiveComponentIds
} from './storage';

export const nodeWidth = 160;
export const nodeHeight = 120;

function splitLabel(label) {
  const parts = label.split("_")

  return parts.join("_ ")
}

function getClassName(id) {
  const componentId = useSelector(getComponentId)
  const activeComponentIds = useSelector(getActiveComponentIds)

  var className = 'component'

  if (componentId == id) {
    className = className + ' selected'
  }

  if (activeComponentIds.includes(id)) {
    className = className + ' active'
  }
  return className
}

function componentNode({ data }) {
  const imageSrc = "images/" + data.type + ".png"
  const labelClass = data.type == 'stage' ? 'component-label-stage' : 'component-label'

  const label = splitLabel(data.name)
  const className = getClassName(data.pid)

  return (
    <>
      <div className={className} style={{width: nodeWidth, height: nodeHeight}}>
        <Handle type="target" position={Position.Right} />

        <label className={labelClass}>{label}</label>
        <img src={imageSrc} width={nodeWidth} height={nodeHeight}/>

        <Handle type="source" position={Position.Left} />
      </div>
    </>
  );
}

export default componentNode
