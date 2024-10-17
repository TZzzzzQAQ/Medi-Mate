import axios from 'axios'
import {getUserToken} from "@/utils/index.jsx";
import {APP_API_URL} from "@/../config.js";

const requestPharmacy = axios.create({
    baseURL: `${APP_API_URL}/pharmacy`,
    timeout: 5000
})

requestPharmacy.interceptors.request.use(config => {
    if (getUserToken()) {
        config.headers.Authorization = `Bearer ${getUserToken()}`
        config.headers["Content-Type"] = "application/json; charset=utf-8"
    }
    return config
}, error => {
    return Promise.reject(error)
})

requestPharmacy.interceptors.response.use((response) => {
    return response.data
}, (error) => {
    return Promise.reject(error)
})

export {requestPharmacy}