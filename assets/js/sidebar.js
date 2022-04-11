import React from 'react';
import { useSelector, useDispatch } from 'react-redux';

import {
  getComponentId,
  getComponentData
} from './storage';

const Sidebar = () => {
  const componentId = useSelector(getComponentId)
  const componentData = useSelector(getComponentData)
  let allComponentIps = window.componentIps
  let ips = allComponentIps[componentId]
  const dispatch = useDispatch();

  return (
    <>
      <div className={'sidebar flex-child'}>
        <p>
          Info goes here
        </p>
        <p>
          {componentId}
        </p>
        <p>
          {JSON.stringify(componentData)}
        </p>
          {JSON.stringify(ips)}
        <p>
        </p>
      </div>
    </>
  );
}

export default Sidebar
