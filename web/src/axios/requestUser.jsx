import axios from 'axios'
import {getUserToken} from "@/utils/index.jsx";
import {APP_API_URL} from "@/../config.js";

const requestUser = axios.create({
    baseURL: `${APP_API_URL}/user`,
    timeout: 5000
})

requestUser.interceptors.request.use(config => {
    if (getUserToken()) {
        config.headers["Content-Type"] = "application/json; charset=utf-8"
    }
    return config
}, error => {
    return Promise.reject(error)
})

requestUser.interceptors.response.use((response) => {
    return response.data
}, (error) => {
    return Promise.reject(error)
})

export {requestUser}