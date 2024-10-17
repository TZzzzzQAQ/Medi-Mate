import axios from 'axios';
import { getUserToken } from "@/utils/index.jsx";
import { APP_API_URL } from "@/../config.js";

const requestOrder = axios.create({
    baseURL: `${APP_API_URL}/order`,
    timeout: 5000
});

requestOrder.interceptors.request.use(config => {
    if (getUserToken()) {
        //如果存在token，则在请求头中携带token
        config.headers.Authorization = `Bearer ${getUserToken()}`;
        config.headers["Content-Type"] = "application/json; charset=utf-8";
    }
    return config;
}, error => {
    return Promise.reject(error);
});

requestOrder.interceptors.response.use((response) => {
    return response.data;
}, (error) => {
    return Promise.reject(error);
});

export default requestOrder;