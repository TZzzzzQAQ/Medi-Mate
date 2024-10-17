import { createSlice } from '@reduxjs/toolkit';

export const messageSlice = createSlice({
    name: 'message',
    initialState: {
        orderId: "",
        pharmacyId: "",
        username: ""  // 添加 username 字段
    },
    reducers: {
        setOrderId: (state, action) => {
            state.orderId = action.payload;
        },
        setPharmacyId: (state, action) => {
            state.pharmacyId = action.payload;
        },
        setUsername: (state, action) => {
            state.username = action.payload;
        },
        setOrderInfo: (state, action) => {
            state.orderId = action.payload.orderId;
            state.pharmacyId = action.payload.pharmacyId;
            state.username = action.payload.username;  // 包含 username
        }
    },
});

export const { setOrderId, setPharmacyId, setUsername, setOrderInfo } = messageSlice.actions;

export default messageSlice.reducer;