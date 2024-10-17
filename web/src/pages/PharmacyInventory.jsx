import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Table, Image, Pagination, Spin, Alert, Button, Modal, Input } from 'antd';
import { ArrowLeftOutlined, BoxPlotOutlined, SearchOutlined } from '@ant-design/icons';
import { getInventoryAPI } from '@/api/user/inventory';
import PharmacyShelfView from './pharmacy3DView';

const { Search } = Input;

const PharmacyInventory = () => {
    const { pharmacyId } = useParams();
    const navigate = useNavigate();
    const [inventory, setInventory] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [pagination, setPagination] = useState({
        current: 1,
        pageSize: 10,
        total: 0
    });
    const [isShelfViewVisible, setIsShelfViewVisible] = useState(false);
    const [selectedProduct, setSelectedProduct] = useState(null);
    const [searchTerm, setSearchTerm] = useState('');

    useEffect(() => {
        fetchInventory();
    }, [pharmacyId, pagination.current, pagination.pageSize, searchTerm]);

    const fetchInventory = async () => {
        setLoading(true);
        try {
            const response = await getInventoryAPI(
                parseInt(pharmacyId),
                pagination.current,
                pagination.pageSize,
                searchTerm
            );
            if (response && response.code === 1 && response.data) {
                setInventory(response.data.records);
                setPagination(prev => ({
                    ...prev,
                    total: response.data.total
                }));
            } else {
                throw new Error('Unexpected response structure');
            }
        } catch (error) {
            console.error('Error fetching inventory:', error);
            setError('Failed to fetch inventory. Please try again later.');
        } finally {
            setLoading(false);
        }
    };

    const handleSearch = (value) => {
        setSearchTerm(value);
        setPagination(prev => ({ ...prev, current: 1 }));
    };

    const handleViewDetails = (product) => {
        setSelectedProduct(product);
        setIsShelfViewVisible(true);
    };

    const columns = [
        {
            title: 'Image',
            dataIndex: 'imageSrc',
            key: 'imageSrc',
            render: (imageSrc) => <Image src={imageSrc} width={50} />,
        },
        {
            title: 'Product Name',
            dataIndex: 'productName',
            key: 'productName',
        },
        {
            title: 'Price',
            dataIndex: 'productPrice',
            key: 'productPrice',
            render: (price) => `$${price.toFixed(2)}`,
        },
        {
            title: 'Manufacturer',
            dataIndex: 'manufacturerName',
            key: 'manufacturerName',
        },
        {
            title: 'Stock Quantity',
            dataIndex: 'stockQuantity',
            key: 'stockQuantity',
        },
        {
            title: 'Shelf Number',
            dataIndex: 'shelfNumber',
            key: 'shelfNumber',
        },
        {
            title: 'Shelf Level',
            dataIndex: 'shelfLevel',
            key: 'shelfLevel',
        },
        {
            title: 'Drug Location',
            key: 'action',
            render: (_, record) => (
                <Button type="link" onClick={() => handleViewDetails(record)}>
                    Location
                </Button>
            ),
        },
    ];

    const handlePageChange = (page, pageSize) => {
        setPagination(prev => ({
            ...prev,
            current: page,
            pageSize: pageSize
        }));
    };

    const handleGoBack = () => {
        navigate('/pharmacies');
    };

    const toggleShelfView = () => {
        setIsShelfViewVisible(!isShelfViewVisible);
        setSelectedProduct(null);
    };

    if (loading) {
        return (
            <div className="flex justify-center items-center h-screen">
                <Spin size="large" tip="Loading inventory..." />
            </div>
        );
    }

    if (error) {
        return (
            <div className="p-8">
                <Alert
                    message="Error"
                    description={error}
                    type="error"
                    showIcon
                    action={
                        <Button size="small" danger onClick={fetchInventory}>
                            Try Again
                        </Button>
                    }
                />
            </div>
        );
    }

    return (
        <div className="p-8">
            <div className="flex justify-between items-center mb-6">
                <h1 className="text-3xl font-bold">
                    Pharmacy Inventory
                </h1>
                <div>
                    <Button
                        type="primary"
                        icon={<BoxPlotOutlined />}
                        onClick={toggleShelfView}
                        className="mr-4"
                    >
                        Toggle Shelf View
                    </Button>
                    <Button type="primary" icon={<ArrowLeftOutlined />} onClick={handleGoBack}>
                        Back to Pharmacies
                    </Button>
                </div>
            </div>
            <div className="mb-6">
                <Search
                    placeholder="Search products"
                    onSearch={handleSearch}
                    enterButton={<SearchOutlined />}
                    size="large"
                    className="max-w-xl"
                />
            </div>
            {inventory.length > 0 ? (
                <>
                    <Table
                        columns={columns}
                        dataSource={inventory}
                        rowKey="productName"
                        pagination={false}
                    />
                    <Pagination
                        current={pagination.current}
                        pageSize={pagination.pageSize}
                        total={pagination.total}
                        onChange={handlePageChange}
                        className="mt-6 text-right"
                    />
                </>
            ) : (
                <Alert
                    message="No Data"
                    description="No inventory data available for this pharmacy or matching your search criteria."
                    type="info"
                    showIcon
                />
            )}
            <Modal
                title={`Shelf View - ${selectedProduct ? selectedProduct.productName : 'Inventory'}`}
                visible={isShelfViewVisible}
                onCancel={() => {
                    setIsShelfViewVisible(false);
                    setSelectedProduct(null);
                }}
                width={800}
                footer={null}
            >
                <PharmacyShelfView inventory={inventory} selectedProduct={selectedProduct} />
            </Modal>
        </div>
    );
};

export default PharmacyInventory;