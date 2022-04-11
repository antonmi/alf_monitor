import { createSlice } from '@reduxjs/toolkit'

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
      window.componentIps[id][ip.ref]["start"] = {ip: ip, time: payload.data.time}
    } else if (action == "stop") {
      window.componentIps[id][ip.ref]["stop"] = {ip: ip, duration: payload.data.duration}
    }
  }
}

export const storage = createSlice({
  name: 'storage',
  initialState: {
    value: 0,
    selectedComponentId: null,
    activeComponentIds: [],
    componentData: {},
  },
  reducers: {
    selectComponent: (state, action) => {
      state.selectedComponentId = action.payload.id
      state.componentData = action.payload.data
    },
    addActiveComponentId: (state, action) => {
      state.activeComponentIds.push(action.payload.id)
      setComponentIps(action.payload)
    },
    removeActiveComponentId: (state, action) => {
      const index = state.activeComponentIds.indexOf(action.payload.id)
      if (index > -1) {
        state.activeComponentIds.splice(index, 1)
      }
    }
  }
})

export const { selectComponent, addActiveComponentId, removeActiveComponentId } = storage.actions

export const getComponentId = (state) => state.selectedComponentId
export const getComponentData = (state) => state.componentData
export const getActiveComponentIds = (state) => state.activeComponentIds


export default storage.reducer
