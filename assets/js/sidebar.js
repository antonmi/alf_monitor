import React, {useState} from 'react';
import { useSelector, useDispatch } from 'react-redux';
import hljs from "highlight.js";

import {
  getComponentId,
  getComponentData
} from './storage';

const Sidebar = () => {
  const componentId = useSelector(getComponentId)
  const componentData = useSelector(getComponentData)
  let allComponentIps = window.componentIps
  let ips = allComponentIps[componentId] || []

  const [currentView, setCurrentView] = useState('info')

  function stringifyEvent(value, key) {
    if (value) {
      return stringify(value[key])
    } else {
      return ""
    }
  };

  function stringify(value) {
    return (value ? JSON.stringify(value, null, 2) : "")
  }

  let activeWindow
  if (currentView == 'info') {
    activeWindow =
      <div className={'info-view'}>
        <pre>
          <code dangerouslySetInnerHTML={{__html: hljs.highlight(stringify(componentData), {language: 'javascript'}).value}}></code>
        </pre>
      </div>
  } else if (currentView == 'ips') {
    activeWindow =
      <div className={'ips-view'}>
      {
        Object.entries(ips).map(([ref, value]) =>
          (
            <div className={'ip-packet'} key={ref}>
              <span className={'ip-ref'}>{ref}</span>
              <div className={'events'}>
                <div className={'start'}>
                  <pre>
                    <code dangerouslySetInnerHTML={{__html: hljs.highlight(stringifyEvent(value, 'start'), {language: 'javascript'}).value}}></code>
                  </pre>
                </div>
                <div className={'stop'}>
                  <pre>
                    <code dangerouslySetInnerHTML={{__html: hljs.highlight(stringifyEvent(value, 'stop'), {language: 'javascript'}).value}}></code>
                  </pre>
                </div>
              </div>
            </div>
          )
        )
      }
    </div>
  } else if (currentView == 'code') {
    let source_code = componentData['source_code'] || "no code"
    activeWindow =
      <div className={'code-view'}>
        <pre>
          <code dangerouslySetInnerHTML={{__html: hljs.highlight(source_code, {language: 'elixir'}).value}}></code>
        </pre>
      </div>
  }

  return (
    <>
      <div className={'sidebar flex-child'}>
        {activeWindow}
        <div id={'sidebar-controls'}>
          <button onClick={() => setCurrentView('info')} disabled={currentView == 'info'}>
            Info
          </button>
          <button onClick={() => setCurrentView('ips')} disabled={currentView == 'ips'}>
            IPs
          </button>
          <button onClick={() => setCurrentView('code')} disabled={currentView == 'code'}>
            Code
          </button>
        </div>
      </div>
    </>
  );
}

export default Sidebar
