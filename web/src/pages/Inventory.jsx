import {useState, useEffect} from 'react';
import {Table, Image, Pagination, Select, Spin} from 'antd';
import {getInventoryAPI} from '@/api/user/inventory';
import {useParams, useNavigate} from 'react-router-dom';

const {Option} = Select;

const InventoryPage = () => {
    const {pharmacyId: routePharmacyId} = useParams();
    const navigate = useNavigate();
    const [inventory, setInventory] = useState([]);
    const [loading, setLoading] = useState(false);
    const [pagination, setPagination] = useState({
        current: 1,
        pageSize: 10,
        total: 0
    });
    const [selectedPharmacy, setSelectedPharmacy] = useState(routePharmacyId ? parseInt(routePharmacyId) : 1);

    const pharmacies = [
        {id: 1, name: 'MediMate Manakau'},
        {id: 2, name: 'MediMate NewMarket'},
        {id: 3, name: 'MediMate Mount Albert'},
        {id: 4, name: 'MediMate Albany'},
        {id: 5, name: 'MediMate CBD'},
    ];

    useEffect(() => {
        fetchInventory();
    }, [selectedPharmacy, pagination.current, pagination.pageSize]);

    const fetchInventory = async () => {
        setLoading(true);
        try {
            const response = await getInventoryAPI(selectedPharmacy, pagination.current, pagination.pageSize);
            console.log('API Response:', response);

            if (response && response.code === 1 && response.data) {
                setInventory(response.data.records);
                setPagination(prev => ({
                    ...prev,
                    total: response.data.total
                }));
            } else {
                console.error('Unexpected response structure:', response);
            }
        } catch (error) {
            console.error('Error fetching inventory:', error);
        } finally {
            setLoading(false);
        }
    };
    const columns = [
        {
            title: 'Image',
            dataIndex: 'imageSrc',
            key: 'imageSrc',
            render: (imageSrc) => <Image src={imageSrc} width={50}/>,
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
    ];

    const handlePageChange = (page, pageSize) => {
        setPagination(prev => ({
            ...prev,
            current: page,
            pageSize: pageSize
        }));
    };

    const handlePharmacyChange = (value) => {
        setSelectedPharmacy(value);
        setPagination(prev => ({
            ...prev,
            current: 1
        }));
        navigate(`/inventory/${value}`);
    };

    return (
        <div style={{padding: '20px'}}>
            <h1>Pharmacy inventory management</h1>
            <Select
                style={{width: 200, marginBottom: 20}}
                value={selectedPharmacy}
                onChange={handlePharmacyChange}
            >
                {pharmacies.map(pharmacy => (
                    <Option key={pharmacy.id} value={pharmacy.id}>{pharmacy.name}</Option>
                ))}
            </Select>
            <Spin spinning={loading}>
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
                            style={{marginTop: '20px', textAlign: 'right'}}
                        />
                    </>
                ) : (
                    <div>No inventory data available</div>
                )}
            </Spin>
        </div>
    );
};

export default InventoryPage;