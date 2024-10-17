import axios from 'axios'
import {getUserToken} from "@/utils/index.jsx";
import {APP_API_URL} from "@/../config.js";

const requestInventory = axios.create({
    baseURL: `${APP_API_URL}/inventory/detailInventory`,
    timeout: 5000
})

requestInventory.interceptors.request.use(config => {
    if (getUserToken()) {
        config.headers.Authorization = `Bearer ${getUserToken()}`
        config.headers["Content-Type"] = "application/json; charset=utf-8"
    }
    return config
}, error => {
    return Promise.reject(error)
})

requestInventory.interceptors.response.use((response) => {
    return response.data
}, (error) => {
    return Promise.reject(error)
})

export {requestInventory}