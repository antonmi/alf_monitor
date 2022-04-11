// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
import "../css/app.css"

import "phoenix_html"
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
import initFlow from "./flow";
import { useSelector, useDispatch } from 'react-redux';
import {
  addActiveComponentId,
  removeActiveComponentId
} from './storage';
import store from './store'

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let Hooks = {}

var dispatch = null;

window.componentIps = {}

function setComponentIps(payload) {
  let id = payload.id
  let action = payload.data.action

  let ip = payload.data.ip

  if (ip) {
    if (!window.componentIps[id]) {
      window.componentIps[id] = {}
    }
    if (!window.componentIps[id][ip.ref]) {
      window.componentIps[id][ip.ref] = {}
    }
    if (action == "start") {
      window.componentIps[id][ip.ref]["start"] = {event: ip.event, time: payload.data.time}
    } else if (action == "stop") {
      window.componentIps[id][ip.ref]["stop"] = {event: ip.event, duration: payload.data.duration}
    }
  }
}

Hooks.LiveReact = {
  mounted() {
    initFlow()
  },
  updated() {
    let data = JSON.parse(JSON.parse(this.el.textContent))
    let payload = {id: data.pid, data: data}
    setComponentIps(payload)

    if (data.action == "start") {
      store.dispatch(addActiveComponentId(payload))
    } else if (data.action == "stop") {
      setTimeout(function () {
        store.dispatch(removeActiveComponentId(payload))
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




