import React from 'react';
import {Handle, Position} from "react-flow-renderer";

import { useSelector } from 'react-redux';

import {
  getComponentId,
  getActiveComponentIds
} from './storage';

function splitLabel(label) {
  const len = 10
  const parts = label.split("_")
  const initialValue = [parts.shift()]

  const newParts = parts.reduce(
    function(previousValue, currentValue){
      let last = previousValue.pop()
      if (last.length < len) {
        previousValue.push(last + "_" + currentValue)
        return previousValue
      } else {
        previousValue.push(last)
        previousValue.push(currentValue)
        return previousValue
      }
    },
    initialValue
  );

  return newParts.join("_ ")
}

function formatPipelineName(name) {
  return name.slice(7)
}

function getClassName(id, ref) {
  const componentId = useSelector(getComponentId)
  const activeComponentPidsOrRefs = useSelector(getActiveComponentIds)

  var className = 'component'

  if (componentId == id) {
    className = className + ' selected'
  }

  if (activeComponentPidsOrRefs.includes(id) || activeComponentPidsOrRefs.includes(ref)) {
    className = className + ' active'
  }
  return className
}

function componentNode({ data }) {
  const nodeWidth = data.width
  const nodeHeight = data.height
  const imageSrc = "images/" + data.type + ".png"
  const labelClass = data.type == 'stage' ? 'component-label-stage' : 'component-label'
  const count = data.count

  let label
  if (data.type == 'producer' || data.type == 'consumer') {
    label = formatPipelineName(data.pipeline_module)
  } else if (data.type == 'goto') {
    label = splitLabel(data.name) + ' -> ' + splitLabel(data.to)
  } else {
    label = splitLabel(data.name)
  }

  let className = getClassName(data.pid, data.stage_set_ref)

  return (
    <>
      <div className={className} style={{width: nodeWidth, height: nodeHeight}}>
        <Handle type="target" position={Position.Right} />


        <label className={labelClass}>{label}
          {count > 1 &&
            <span className={'component-label-count'}>({count})</span>
          }
        </label>
        <img src={imageSrc} width={nodeWidth} height={nodeHeight}/>

        <Handle type="source" position={Position.Left} />
      </div>
    </>
  );
}

export default componentNode
