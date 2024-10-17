import React from 'react';
import { Clock, Package, Truck, CheckCircle } from 'lucide-react';
const convertToNZTime = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleString("en-NZ", { timeZone: "Pacific/Auckland", hour12: false });
};
const OrderCard = ({ order, actionText, onView, onAction, onCancel }) => {
    const getStatusInfo = (status) => {
        const statusMap = {
            1: { color: 'bg-green-100 border-green-500 ', icon: Package },
            2: { color: 'bg-yellow-100 border-yellow-500', icon: Truck },
            3: { color: 'bg-gray-100 border-gray-500', icon: CheckCircle }
        };
        return statusMap[status] || { color: 'bg-gray-100 border-gray-500', icon: Package, text: 'Unknown' };
    };

    const { color, icon: StatusIcon, text: statusText } = getStatusInfo(order.status);

    return (
        <div className={`${color} border-l-4 rounded-lg p-4 mb-4 transition duration-300 hover:shadow-lg flex justify-between`}>
            <div className="flex-grow">
                <div className="flex items-center justify-between mb-2">
                    <StatusIcon className="text-gray-600 mr-2" size={25} />
          <span className="text-sm font-semibold px-2 py-1 rounded-full bg-opacity-50" style={{backgroundColor: color}}>
            {statusText}
          </span>
                </div>
                {/*<p className="text-sm font-bold text-gray-800">Order #{order.orderId}</p>*/}
                <div className="text-xs text-gray-600 mt-1">
                    {/*<p className="text-sm font-bold text-gray-800">Order #{order.orderId}</p>*/}
                    <p className="text-sm font-bold text-gray-800">User: {order.username}</p>
                    <p>Pharmacy: {order.pharmacyId}</p>
                    <p className="flex items-center">
                        <Clock size={12} className="mr-1" />
                        {convertToNZTime(order.createdAt)}
                    </p>
                </div>
            </div>
            <div className="flex flex-col justify-between ml-4">
                <button
                    onClick={() => onView(order.orderId)}
                    className="bg-blue-500 hover:bg-blue-600 text-white text-xs font-medium py-1 px-2 rounded transition duration-300 mb-1"
                >
                    View
                </button>
                {order.status !== 3 && (
                    <button
                        onClick={() => onAction(order, order.status + 1)}
                        className="bg-green-500 hover:bg-green-600 text-white text-xs font-medium py-1 px-2 rounded transition duration-300 mb-1"
                    >
                        {actionText}
                    </button>
                )}
                <button
                    onClick={() => onCancel(order)}
                    className="bg-red-100 hover:bg-red-200 text-red-600 text-xs font-medium py-1 px-2 rounded transition duration-300"
                >
                    Cancel
                </button>
            </div>
        </div>
    );
};

export default OrderCard;


