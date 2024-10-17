import axios from 'axios'
import {getUserToken} from "@/utils/index.jsx";
import {APP_API_URL} from "@/../config.js";

const requestProduct = axios.create({
    baseURL: `${APP_API_URL}/products`,
    timeout: 5000
})

requestProduct.interceptors.request.use(config => {
    if (getUserToken()) {
        config.headers.Authorization = `Bearer ${getUserToken()}`
        config.headers["Content-Type"] = "application/json; charset=utf-8"
    }
    return config
}, error => {
    return Promise.reject(error)
})

requestProduct.interceptors.response.use((response) => {
    return response.data
}, (error) => {
    return Promise.reject(error)
})

export {requestProduct}