import React from "react";
import hljs from "highlight.js";

function TracingPopup(props) {
  let ipRef = props.ipRef

  let events = []

  Object.entries(window.componentIps).map(function([key, value]) {
    let data = value[ipRef]
    if (data) {
      let event = {
        component_name: data['component']['name'],
        component_pid: data['component']['pid'],
        start_time: data['start']['time'],
        duration: data['stop']['duration'],
        event: data['stop']['event']
      }
      events.push(event)
    }
  })

  events.sort(function(a, b) {
    if(a.start_time > b.start_time) return 1;
    return -1;
  })

  return (ipRef) ? (
    <div className={'popup'}>
      <div className={'popup-inner'}>
        <button className={'close-btn'} onClick={() => props.setIpRef(false)}>Close</button>
        <span className={'ip-ref'}>{ipRef}</span>
        <div className={'code'}>
          <pre>
            <code dangerouslySetInnerHTML={{__html: hljs.highlight(JSON.stringify(events, null, 2), {language: 'javascript'}).value}}></code>
          </pre>
        </div>
      </div>
    </div>
  ) : "";
}

export default TracingPopup
