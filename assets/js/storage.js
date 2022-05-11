import { createSlice } from '@reduxjs/toolkit'

export const storage = createSlice({
  name: 'storage',
  initialState: {
    value: 0,
    selectedComponentId: null,
    activeComponentPidsOrRefs: {},
    errorComponentStageSetRefs: {},
    componentData: {},
  },
  reducers: {
    selectComponent: (state, action) => {
      state.selectedComponentId = action.payload.id
      state.componentData = action.payload.data
    },
    addActiveComponentPidOrRef: (state, action) => {
      let pidOrRef = action.payload
      state.activeComponentPidsOrRefs[pidOrRef] = true
    },
    removeActiveComponentPidOrRef: (state, action) => {
      let pidOrRef = action.payload
      delete state.activeComponentPidsOrRefs[pidOrRef]
    },
    addErrorComponentStageSetRef: (state, action) => {
      let ref = action.payload
      state.errorComponentStageSetRefs[ref] = true
    }
  }
})

export const {
  selectComponent,
  addActiveComponentPidOrRef,
  removeActiveComponentPidOrRef,
  addErrorComponentStageSetRef
} = storage.actions

export const getComponentId = (state) => state.selectedComponentId
export const getComponentData = (state) => state.componentData
export const getActiveComponentIds = (state) => state.activeComponentPidsOrRefs
export const getErrorComponentStageSetRefs = (state) => state.errorComponentStageSetRefs

export default storage.reducer
