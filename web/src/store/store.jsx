import {configureStore} from '@reduxjs/toolkit';

import messageReducer from './features/messageSlice';
export const store = configureStore({
    reducer: {
        message: messageReducer
    },
});
