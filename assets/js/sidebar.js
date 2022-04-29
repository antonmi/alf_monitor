import React, {useState} from 'react';
import { useSelector } from 'react-redux';
import hljs from "highlight.js";
import TracingPopup from "./tracingPopup";

import {
  getComponentId,
  getComponentData
} from './storage';

function select_ips(componentId, componentType, stage_set_ref) {
  let allComponentIps = window.componentIps
  let ips;
  if (componentType == 'stage') {
    ips = Object.entries(allComponentIps).reduce(function(acc, [_ref, value]) {
      if (value.stage_set_ref == stage_set_ref) {
        acc = Object.entries(value).reduce(function(inner_acc, [ref, inner_value]){
          if (ref == 'stage_set_ref') {
            return inner_acc
          }
          inner_acc[ref] = inner_value
          return inner_acc
        }, acc)
      }
      return acc
    }, {});
  } else {
    ips = allComponentIps[componentId] || {}
  }

  return ips
}

const Sidebar = () => {
  const componentId = useSelector(getComponentId)
  const componentData = useSelector(getComponentData)

  let ips = select_ips(componentId, componentData.type, componentData.stage_set_ref)

  const [currentView, setCurrentView] = useState('info')
  const [popupIpRef, setPopupIpRef] = useState(false)

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
    let source_code = componentData['source_code'] || "no code"
    activeWindow =
      <div className={'info-view'}>
        <pre>
          <code dangerouslySetInnerHTML={{__html: hljs.highlight(source_code, {language: 'elixir'}).value}}></code>
        </pre>
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
              <span className={'ip-ref'} onClick={() => setPopupIpRef(ref)}>{ref}</span>
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
        </div>
      </div>
      <TracingPopup ipRef={popupIpRef} setIpRef={setPopupIpRef}/>
    </>
  );
}

export default Sidebar
