import { createSlice } from '@reduxjs/toolkit'

export const storage = createSlice({
  name: 'storage',
  initialState: {
    value: 0,
    selectedComponentId: null,
    activeComponentPidsOrRefs: [],
    componentData: {},
  },
  reducers: {
    selectComponent: (state, action) => {
      state.selectedComponentId = action.payload.id
      state.componentData = action.payload.data
    },
    addActiveComponentPidOrRef: (state, action) => {
      state.activeComponentPidsOrRefs.push(action.payload)
    },
    removeActiveComponentPidOrRef: (state, action) => {
      const index = state.activeComponentPidsOrRefs.indexOf(action.payload)
      if (index > -1) {
        state.activeComponentPidsOrRefs.splice(index, 1)
      }
    }
  }
})

export const { selectComponent, addActiveComponentPidOrRef, removeActiveComponentPidOrRef } = storage.actions

export const getComponentId = (state) => state.selectedComponentId
export const getComponentData = (state) => state.componentData
export const getActiveComponentIds = (state) => state.activeComponentPidsOrRefs

export default storage.reducer
