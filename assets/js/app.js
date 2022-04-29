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
  removeActiveComponentPidOrRef
} from './storage';
import store from './store'

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let Hooks = {}

var dispatch = null;

window.componentIps = {}

function setComponentIps(payload) {
  let id = payload.component.pid
  let action = payload.action
  let ip = payload.ip

  if (ip) {
    if (!window.componentIps[id]) {
      window.componentIps[id] = {}
    }
    if (!window.componentIps[id][ip.ref]) {
      window.componentIps[id][ip.ref] = {}
    }
    window.componentIps[id][ip.ref]['component'] = payload.component
    if (action == "start") {
      window.componentIps[id][ip.ref]['start'] = {event: ip.event, time: payload.time}
    } else if (action == "stop") {
      window.componentIps[id][ip.ref]['stop'] = {event: ip.event, duration: payload.duration}
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

    let pipOrRef
    if (data.component.type == 'stage') {
      pipOrRef = data.component.stage_set_ref
    } else {
      pipOrRef = data.component.pid
    }

    if (data.action == "start") {
      store.dispatch(addActiveComponentPidOrRef(pipOrRef))
    } else if (data.action == "stop") {
      setTimeout(function () {
        store.dispatch(removeActiveComponentPidOrRef(pipOrRef))
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




