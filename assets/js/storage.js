import { createSlice } from '@reduxjs/toolkit'

export const storage = createSlice({
  name: 'storage',
  initialState: {
    value: 0,
    selectedComponentId: null,
    componentData: {}
  },
  reducers: {
    selectComponent: (state, action) => {
      state.selectedComponentId = action.payload.id
      state.componentData = action.payload.data
    }
  },
})

export const { selectComponent } = storage.actions

export const getComponentId = (state) => state.selectedComponentId
export const getComponentData = (state) => state.componentData


export default storage.reducer
