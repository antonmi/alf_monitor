import { configureStore } from '@reduxjs/toolkit'
import counterReducer from './counterSlice';

const store = configureStore({
  reducer: counterReducer
})

export default store;
