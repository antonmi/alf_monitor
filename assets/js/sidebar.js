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

function formatComponentData(componentData) {
  let componentDataCopy = { ...componentData }
  delete componentDataCopy['width']
  delete componentDataCopy['height']
  delete componentDataCopy['source_code']
  delete componentDataCopy['max_throughput']
  delete componentDataCopy['processed_ips']
  delete componentDataCopy['average_processing_time']
  delete componentDataCopy['avg_throughput']
  return componentDataCopy
}

function fetchComponentStats(componentData) {
  let componentDataCopy = { ...componentData }
  if (componentDataCopy.type == 'stage') {
    let fetchData = ({max_throughput, processed_ips, average_processing_time}) => ({max_throughput, processed_ips, average_processing_time});
    return fetchData(componentDataCopy)
  } else if (componentDataCopy.type == 'producer') {
    let fetchData = ({ips_in_queue, processed_ips, avg_throughput}) => ({ips_in_queue, processed_ips, avg_throughput});
    return fetchData(componentDataCopy)
  } else if (componentDataCopy.type == 'consumer') {
    let fetchData = ({processed_ips, avg_throughput}) => ({processed_ips, avg_throughput});
    return fetchData(componentDataCopy)
  } else {
    return false
  }
}

const Sidebar = () => {
  const componentId = useSelector(getComponentId)
  const componentData = useSelector(getComponentData)
  let formattedComponentData = formatComponentData(componentData)

  let componentStats = fetchComponentStats(componentData)
  let ips = select_ips(componentId, componentData.type, componentData.stage_set_ref)

  const [currentView, setCurrentView] = useState('info')
  const [popupIpRef, setPopupIpRef] = useState(false)

  function stringifyEvent(value, key) {
    if (value) {
      return stringify(value[key])
    } else {
      return ""
    }
  }

  function stringify(value) {
    return (value ? JSON.stringify(value, null, 2) : "")
  }

  let activeWindow
  if (currentView == 'info') {
    let source_code = componentData['source_code']
    activeWindow =
      <div className={'info-view'}>
        {source_code &&
          <pre>
            <code dangerouslySetInnerHTML={{__html: hljs.highlight(source_code, {language: 'elixir'}).value}}></code>
          </pre>
        }
        { componentStats &&
          <pre>
            <code dangerouslySetInnerHTML={{__html: hljs.highlight(stringify(componentStats), {language: 'elixir'}).value}}></code>
          </pre>
        }
        {Object.keys(formattedComponentData).length > 0 &&
          <pre>
            <code dangerouslySetInnerHTML={{__html: hljs.highlight(stringify(formattedComponentData), {language: 'javascript'}).value}}></code>
          </pre>
        }
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
