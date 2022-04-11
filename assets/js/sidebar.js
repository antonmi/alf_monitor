import React from 'react';
import {createRoot} from "react-dom/client";

function Sidebar({ data }) {

  return (
    <>
      <div className={'info-window'}>
        <p>
          Info goes here
        </p>
      </div>
    </>
  );
}

function initSidebar() {
  const container = document.getElementById('sidebar');
  const root = createRoot(container);
  root.render(<Sidebar/>);
}

export default initSidebar
