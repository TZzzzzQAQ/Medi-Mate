const TOKEN = 'token';
const setUserToken = (token) => {
    localStorage.setItem(TOKEN, token)
}

const getUserToken = () => {
    return localStorage.getItem(TOKEN)
}

const removeUserToken = () => {
    localStorage.removeItem(TOKEN)
}

export {
    setUserToken,
    getUserToken,
    removeUserToken
}