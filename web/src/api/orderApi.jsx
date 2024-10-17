import requestOrder from '../axios/requstOrder.jsx';

export const pharmacyOrderAPI = {
    getOrderDetails: (pharmacyId) => {
        return requestOrder({
            method: 'GET',
            url: `/pharmacyOrder/${pharmacyId}`
        });
    },
    getOrderDetail: (orderId) => {
        return requestOrder({
            method: 'GET',
            url: `/detailOrder/${orderId}`
        });
    },
    updateOrderStatus: (orderId, newStatus, pharmacyId, cancelReason) => {
        // 添加 pharmacyId 到请求体
        const data = { orderId, status: newStatus, pharmacyId };

        if (cancelReason) {
            data.cancelReason = cancelReason;
        }

        return requestOrder({
            method: 'PATCH',
            url: `/updateOrderStatus`,
            data
        });
    }
};