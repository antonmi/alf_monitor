import React from 'react';
import { useSelector, useDispatch } from 'react-redux';

import {
  getComponentId,
  getComponentData
} from './storage';

const Sidebar = () => {
  const componentId = useSelector(getComponentId)
  const componentData = useSelector(getComponentData)
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
      </div>
    </>
  );
}

export default Sidebar
