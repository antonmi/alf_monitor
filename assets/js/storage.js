import { createSlice } from '@reduxjs/toolkit'

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
      state.activeComponentIds.push(action.payload)
    },
    removeActiveComponentId: (state, action) => {
      const index = state.activeComponentIds.indexOf(action.payload)
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
