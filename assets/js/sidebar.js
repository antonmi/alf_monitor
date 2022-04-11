import React, { Component } from 'react';
import {createRoot} from "react-dom/client";
import store from './store'
import { Provider } from 'react-redux'
import { useSelector, useDispatch } from 'react-redux';

import {
  decrement,
  increment,
  incrementByAmount,
  selectCount,
  getComponentId,
  getComponentData
} from './counterSlice';

const Sidebar = () => {
  const count = useSelector(selectCount);
  const componentId = useSelector(getComponentId)
  const componentData = useSelector(getComponentData)
  const dispatch = useDispatch();

  console.log(componentId)

  return (
    <>
      <div className={'sidebar flex-child'}>
        <p>
          Info goes here
        </p>
        <p>
          {count}
        </p>
        <p>
          {componentId}
        </p>
        <p>
          {JSON.stringify(componentData)}
        </p>
        <button
          aria-label="Increment value"
          onClick={() => dispatch(increment())}
        >
          +
        </button>
      </div>
    </>
  );
}

// function initSidebar() {
//   const container = document.getElementById('sidebar');
//   const root = createRoot(container);
  // root.render(
  //   <Provider store={store}>
  //     <Sidebar/>
  //   </Provider>
  // );
// }

export default Sidebar
