import { configureStore } from '@reduxjs/toolkit'
import storageReducer from './storage';

const store = configureStore({
  reducer: storageReducer
})

export default store;
