// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
import "../css/app.css"

import "phoenix_html"
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
import initFlow from "./flow";
import {
  addActiveComponentPidOrRef,
  removeActiveComponentPidOrRef,
  addErrorComponentStageSetRef
} from './storage';
import store from './store'

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let Hooks = {}

window.componentIps = {}

function stopIpData(ip, payload) {
  let data
  if (ip.type == "ip") {
    if (ip['done!']) {
      data = {event: ip.event, duration: payload.duration, 'done!': true}
    } else {
      data = {event: ip.event, duration: payload.duration}
    }

  } else if (ip.type == "error_ip") {
    data = {error: ip.error, stacktrace: ip.stacktrace, duration: payload.duration}
  }
  return data
}

function setComponentIps(payload) {
  let pid = payload.component.pid
  let stage_set_ref = payload.component.stage_set_ref
  let action = payload.action
  let ip = payload.ip

  if (ip) {
    if (!window.componentIps[pid]) {
      if (stage_set_ref) {
        window.componentIps[pid] = {stage_set_ref: stage_set_ref}
      } else {
        window.componentIps[pid] = {}
      }
    }
    if (!window.componentIps[pid][ip.ref]) {
      window.componentIps[pid][ip.ref] = {}
    }
    window.componentIps[pid][ip.ref]['component'] = payload.component
    if (action == "start") {
      window.componentIps[pid][ip.ref]['start'] = {event: ip.event, time: payload.time}
    } else if (action == "stop") {
      window.componentIps[pid][ip.ref]['stop'] = stopIpData(ip, payload)
    }
  }
}

Hooks.LiveReact = {
  mounted() {
    initFlow()
  },
  updated() {
    let json = atob(JSON.parse(this.el.textContent))
    let data = JSON.parse(json)
    setComponentIps(data)

    let pidOrRef
    if (data.component.type == 'stage') {
      pidOrRef = data.component.stage_set_ref
    } else {
      pidOrRef = data.component.pid
    }

    if (data.ip.type == 'error_ip') {
      let ref = data.component.stage_set_ref
      store.dispatch(addErrorComponentStageSetRef(ref))
    }

    if (data.action == "start") {
      store.dispatch(addActiveComponentPidOrRef(pidOrRef))
    } else if (data.action == "stop") {
      setTimeout(function () {
        store.dispatch(removeActiveComponentPidOrRef(pidOrRef))
      }, 100)
    }
  }
}

let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
liveSocket.disableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket




