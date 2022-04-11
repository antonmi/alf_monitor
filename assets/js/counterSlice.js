import { createSlice } from '@reduxjs/toolkit'

export const counterSlice = createSlice({
  name: 'counter',
  initialState: {
    value: 0,
    selectedComponentId: null,
    componentData: {}
  },
  reducers: {
    selectComponent: (state, action) => {
      state.selectedComponentId = action.payload.id
      state.componentData = action.payload.data
    },

    increment: (state) => {
      state.value += 1
    },
    decrement: (state) => {
      state.value -= 1
    },
    incrementByAmount: (state, action) => {
      state.value += action.payload
    },
  },
})

export const { selectComponent, increment, decrement, incrementByAmount } = counterSlice.actions

export const selectCount = (state) => state.value
export const getComponentId = (state) => state.selectedComponentId
export const getComponentData = (state) => state.componentData


export default counterSlice.reducer
