import { pharmacyOrderAPI } from "@/api/orderApi.jsx";
import { useEffect, useState, useRef } from "react";
import { Modal, Input, message, Table, Button, Select } from "antd";
import { useSelector } from "react-redux";
import generateReceipt from './PDFReceipt';
import generateReport from './PDFReport';
import OrderCard from './renderOrderCard.jsx';
import {  Package, Truck, CheckCircle } from 'lucide-react';
const { Option } = Select;



const OrderPage = () => {
    const { orderId: currentOrderId, username: currentUsername, pharmacyId: currentOrderPharmacyId } = useSelector(state => state.message);
    const [orders, setOrders] = useState({
        finishOrder: [],
        startPicking: [],
        finishPicking: []
    });

    const [currentPharmacy, setCurrentPharmacy] = useState(1);
    const [isModalVisible, setIsModalVisible] = useState(false);
    const [cancelReason, setCancelReason] = useState("");
    const [orderToCancel, setOrderToCancel] = useState(null);
    const [isConfirmModalVisible, setIsConfirmModalVisible] = useState(false);
    const [orderToUpdate, setOrderToUpdate] = useState(null);
    const [isEmailModalVisible, setIsEmailModalVisible] = useState(false);
    const [timers, setTimers] = useState({});
    const [isDetailsModalVisible, setIsDetailsModalVisible] = useState(false);
    const [orderDetails, setOrderDetails] = useState([]);
    const [totalAmount, setTotalAmount] = useState(0);
    const [latestUsername, setLatestUsername] = useState('');
    const timerRef = useRef();
    const orderRefs = useRef({});
    useEffect(() => {
        fetchOrders();
        return () => clearInterval(timerRef.current);
    }, [currentPharmacy, currentOrderId, currentOrderPharmacyId]);

    useEffect(() => {
        timerRef.current = setInterval(() => {
            setTimers(prevTimers => {
                const updatedTimers = { ...prevTimers };
                Object.keys(updatedTimers).forEach(orderId => {
                    updatedTimers[orderId] += 1;
                });
                return updatedTimers;
            });
        }, 1000);

        return () => clearInterval(timerRef.current);
    }, []);

    const fetchOrders = () => {
        pharmacyOrderAPI.getOrderDetails(currentPharmacy).then((response) => {
            if (response.code === 1 && Array.isArray(response.data)) {
                const sortedOrders = {
                    finishOrder: response.data.filter(order => order.status === 1),
                    startPicking: response.data.filter(order => order.status === 2),
                    finishPicking: response.data.filter(order => order.status === 3)
                };
                Object.keys(sortedOrders).forEach(key => {
                    sortedOrders[key] = sortedOrders[key].map(order => ({
                        ...order,
                        username: order.username || 'Unknown'

                    }))
                });
                setOrders(sortedOrders);

                const allOrders = [...sortedOrders.finishOrder, ...sortedOrders.startPicking, ...sortedOrders.finishPicking];
                if (allOrders.length > 0) {
                    // Sort orders by createdAt date in descending order
                    const sortedByDate = allOrders.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
                    setLatestUsername(sortedByDate[0].username);
                }

                const newTimers = {};
                [...sortedOrders.finishOrder, ...sortedOrders.startPicking].forEach(order => {
                    if (!timers[order.orderId]) {
                        newTimers[order.orderId] = 0;
                    }
                });
                setTimers(prevTimers => ({ ...prevTimers, ...newTimers }));
            }
        });
    };
    const scrollToOrder = (username) => {
        const allOrders = [...orders.finishOrder, ...orders.startPicking, ...orders.finishPicking];
        const targetOrder = allOrders.find(order => order.username === username);

        if (targetOrder && orderRefs.current[targetOrder.orderId]) {
            orderRefs.current[targetOrder.orderId].scrollIntoView({
                behavior: 'smooth',
                block: 'center'
            });
        } else {
            message.info("Couldn't find the order for this user.");
        }
    };
    const handlePharmacyChange = (value) => {
        setCurrentPharmacy(value);
    }
    const fetchOrderDetails = (orderId) => {
        pharmacyOrderAPI.getOrderDetail(orderId).then((response) => {
            if (response.code === 1 && Array.isArray(response.data)) {
                const orderDetailsWithUsername = response.data.map(item => ({
                    ...item,
                    username: item.username || 'UnKnown' // 确保每个项目都有 username
                }));
                setOrderDetails(orderDetailsWithUsername);
                const total = orderDetailsWithUsername.reduce((sum, item) => sum + item.price * item.quantity, 0);
                setTotalAmount(total);
                setIsDetailsModalVisible(true);
            } else {
                message.error("Failed to fetch order details");
            }
        }).catch((error) => {
            console.error("Error fetching order details:", error);
            message.error("Failed to fetch order details");
        });
    };



    const showConfirmModal = (order, newStatus) => {
        setOrderToUpdate({ ...order, newStatus });
        setIsConfirmModalVisible(true);
    };

    const handleConfirmUpdate = () => {
        if (orderToUpdate) {
            if (orderToUpdate.newStatus === 3) {
                setIsConfirmModalVisible(false);
                setIsEmailModalVisible(true);
            } else {
                updateOrderStatus(orderToUpdate.orderId, orderToUpdate.newStatus, orderToUpdate.pharmacyId);
            }
        }
    };

    const handleEmailConfirm = () => {
        if (orderToUpdate) {
            updateOrderStatus(orderToUpdate.orderId, orderToUpdate.newStatus, orderToUpdate.pharmacyId);
            setIsEmailModalVisible(false);
        }
    };

    const updateOrderStatus = (orderId, newStatus, pharmacyId) => {
        pharmacyOrderAPI.updateOrderStatus(orderId, newStatus, pharmacyId)
            .then((response) => {
                if (response.code === 1) {
                    message.success(`Order ${orderId} updated to status ${newStatus}`);
                    if (newStatus === 3) {
                        setTimers(prevTimers => {
                            const { [orderId]: _, ...restTimers } = prevTimers;
                            return restTimers;
                        });
                    }
                    fetchOrders();
                }
            })
            .catch((error) => {
                message.error("Failed to update order status");
                console.error("Failed to update order status:", error);
            })
            .finally(() => {
                setIsConfirmModalVisible(false);
                setOrderToUpdate(null);
            });
    };

    const showCancelModal = (order) => {
        setOrderToCancel(order);
        setIsModalVisible(true);
    };

    const handleCancel = () => {
        setIsModalVisible(false);
        setIsConfirmModalVisible(false);
        setIsEmailModalVisible(false);
        setCancelReason("");
        setOrderToCancel(null);
        setOrderToUpdate(null);
    };

    const handleConfirmCancel = () => {
        if (orderToCancel && cancelReason) {
            pharmacyOrderAPI.updateOrderStatus(orderToCancel.orderId, 4, orderToCancel.pharmacyId, cancelReason)
                .then((response) => {
                    if (response.code === 1) {
                        message.success(`Order ${orderToCancel.orderId} cancelled successfully`);
                        setTimers(prevTimers => {
                            const { [orderToCancel.orderId]: _, ...restTimers } = prevTimers;
                            return restTimers;
                        });
                        fetchOrders();
                    }
                })
                .catch((error) => {
                    message.error("Failed to cancel order");
                    console.error("Failed to cancel order:", error);
                })
                .finally(() => {
                    setIsModalVisible(false);
                    setCancelReason("");
                    setOrderToCancel(null);
                });
        }
    };


    const renderOrderCard = (order, actionText) => (

        <div ref={el => orderRefs.current[order.orderId] = el}>
            <OrderCard
                key={order.orderId}
                order={order}
                actionText={actionText}
                onView={fetchOrderDetails}
                onAction={(order, newStatus) => showConfirmModal(order, newStatus)}
                onCancel={showCancelModal}
            />
        </div>
    );
    const columns = [
        {
            title: 'Product Name',
            dataIndex: 'productName',
            key: 'productName',
        },
        {
            title: 'Quantity',
            dataIndex: 'quantity',
            key: 'quantity',
        },
        {
            title: 'Price',
            dataIndex: 'price',
            key: 'price',
            render: (price) => `$${price.toFixed(2)}`,
        },
        {
            title: 'Total',
            key: 'total',
            render: (_, record) => `$${(record.price * record.quantity).toFixed(2)}`,
        },
        {
            title: 'Manufacturer',
            dataIndex: 'manufacturerName',
            key: 'manufacturerName',
        },
        {
            title: 'Image',
            dataIndex: 'imageSrc',
            key: 'imageSrc',
            render: (imageSrc) => <img src={imageSrc} alt="Product" style={{ width: '50px', height: '50px' }} />,
        },
    ];
    const handleGenerateReport = () => {
        generateReport([...orders.finishOrder, ...orders.startPicking, ...orders.finishPicking]);
    };

    const handleGenerateReceipt = () => {
        const currentOrderId = orderDetails[0]?.orderId;
        if (currentOrderId) {
            generateReceipt(currentOrderId);
        } else {
            message.error("No order selected for receipt generation");
        }
    };

    return (
        <div className="container mx-auto px-4 py-8 min-h-screen bg-gradient-to-r bg-sky-50">
            <h1 className="text-3xl font-bold mb-6 text-gray-800">Order Management</h1>
            <p className="text-lg mb-6 text-gray-700">
                Current User Name: <span
                className="font-semibold cursor-pointer text-blue-600 hover:text-blue-800"
                onClick={() => scrollToOrder(latestUsername)}
            >
                    {latestUsername || 'No recent orders'}
                </span>
                {currentUsername &&
                    <span className="ml-2">for user: <span className="font-semibold">{currentUsername}</span></span>}
                {currentOrderPharmacyId && (
                    <span> - Pharmacy ID: <span className="font-semibold">{currentOrderPharmacyId}</span></span>
                )}
            </p>
            {currentOrderPharmacyId && currentOrderPharmacyId !== currentPharmacy && (
                <p className="text-lg mb-6 text-red-600">
                    New order in Pharmacy {currentOrderPharmacyId}! Please switch to view.
                </p>
            )}
            <div className="mb-6 flex items-center space-x-4">
                <Select
                    value={currentPharmacy}
                    onChange={handlePharmacyChange}
                    style={{width: 200}}
                >
                    <Option value={1}>MANUKAU</Option>
                    <Option value={2}>New Market</Option>
                    <Option value={3}>Mount Albert</Option>
                    <Option value={4}>Albany</Option>
                    <Option value={5}>CBD</Option>
                </Select>
                <Button type="primary" onClick={handleGenerateReport}>Generate Order Report</Button>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div className="space-y-4">
                    <h2 className="text-xl font-semibold text-green-800 flex items-center">
                        <Package className="mr-2" size={24}/>
                        Order
                    </h2>
                    {orders.finishOrder.map(order => renderOrderCard(order, "Start Picking"))}
                </div>
                <div className="space-y-4">
                    <h2 className="text-xl font-semibold text-yellow-600 flex items-center">
                        <Truck className="mr-2" size={24}/>
                        Picking
                    </h2>
                    {orders.startPicking.map(order => renderOrderCard(order, "Finish Picking"))}
                </div>
                <div className="space-y-4">
                    <h2 className="text-xl font-semibold text-gary-100 flex items-center">
                        <CheckCircle className="mr-2" size={24}/>
                        Finish
                    </h2>
                    {orders.finishPicking.map(order => renderOrderCard(order, "Complete Order"))}
                </div>
            </div>

            <Modal
                title="Cancel Order"
                visible={isModalVisible}
                onOk={handleConfirmCancel}
                onCancel={handleCancel}
                okText="Confirm Cancellation"
                cancelText="Close"
            >
                <p className="mb-2">Please enter the reason for cancellation:</p>
                <Input.TextArea
                    value={cancelReason}
                    onChange={(e) => setCancelReason(e.target.value)}
                    rows={4}
                    className="w-full"
                />
            </Modal>

            <Modal
                title="Confirm Status Update"
                visible={isConfirmModalVisible}
                onOk={handleConfirmUpdate}
                onCancel={handleCancel}
                okText="Confirm"
                cancelText="Cancel"
            >
                <p>Are you sure you want to update the status of this order?</p>
            </Modal>

            <Modal
                title="Confirm Email to Customer"
                visible={isEmailModalVisible}
                onOk={handleEmailConfirm}
                onCancel={handleCancel}
                okText="Send Email and Update"
                cancelText="Cancel"
            >
                <p>Are you sure you want to send an email to the customer and update the order status?</p>
            </Modal>

            <Modal
                title="Order Details "

                visible={isDetailsModalVisible}
                onCancel={() => setIsDetailsModalVisible(false)}
                footer={[
                    <Button key="close" onClick={() => setIsDetailsModalVisible(false)}>
                        Close
                    </Button>,
                    <Button key="download" type="primary" onClick={handleGenerateReceipt}>
                        Generate Receipt
                    </Button>
                ]}
                width={1000}
            >
                <Table dataSource={orderDetails} columns={columns} rowKey="productId"/>
                <p className="text-right mt-4 text-lg font-semibold">Total Amount: ${totalAmount.toFixed(2)}</p>
            </Modal>
        </div>
    );
};

export default OrderPage;