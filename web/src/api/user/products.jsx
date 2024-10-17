import {requestProduct} from "@/axios/requestProducts.jsx";

export function getProductsAPI(params) {
    return requestProduct({
        method: 'GET',
        url: "/allProductsDetail",
        params
    })
}

export function getProductByIdAPI(productId) {
    return requestProduct({
        method: 'GET',
        url: '/productDetail',
        params: { productId }
    });
}
export function updateProductAPI(productId, productData) {
    return requestProduct({
        method: 'PUT',
        url: '/changeProducts',
        params: { productId },
        data: productData
    });
}
export function getAllManufacturersAPI() {
    return requestProduct({
        method: 'GET',
        url: "/manufactureName",
    })
}