import { Card, Typography, Descriptions, Image, Divider, Button } from 'antd';
import { useState, useEffect } from 'react';
import { Spin, message } from 'antd';
import { EditOutlined } from '@ant-design/icons';
import { getProductByIdAPI } from "@/api/user/products.jsx";
import { useNavigate, useParams } from 'react-router-dom';

const { Title, Paragraph } = Typography;

const ProductDetailsDisplay = () => {
    const [product, setProduct] = useState(null);
    const [loading, setLoading] = useState(true);
    const { id: productId } = useParams();
    const navigate = useNavigate();

    useEffect(() => {
        const fetchProductData = async () => {
            setLoading(true);
            try {
                const response = await getProductByIdAPI(productId);
                if (response && response.data) {
                    const productData = response.data.data || response.data;
                    if (productData) {
                        setProduct(productData);
                    } else {
                        message.error('Product data not found');
                    }
                } else {
                    message.error('Product not found');
                }
            } catch (error) {
                console.error('Error fetching product:', error);
                message.error('Failed to fetch product data');
            } finally {
                setLoading(false);
            }
        };

        fetchProductData();
    }, [productId]);

    const handleEdit = () => {
        navigate(`/products/productDetail/edit/${productId}`);
    };

    if (loading) {
        return <Spin size="large" />;
    }

    if (!product) {
        return <Title level={3}>Product not found</Title>;
    }

    return (
        <Card className="max-w-4xl mx-auto">
            <div className="flex flex-col md:flex-row">
                <div className="md:w-1/3 p-4">
                    <Image
                        alt={product.productName}
                        src={product.imageSrc}
                        className="w-full rounded-lg shadow-lg mb-4"
                    />
                    <Button
                        type="primary"
                        icon={<EditOutlined />}
                        onClick={handleEdit}
                        className="w-full"
                    >
                        Edit Product
                    </Button>
                </div>
                <div className="md:w-2/3 p-4">
                    <Title level={2} className="text-left font-serif">{product.productName}</Title>
                    <Descriptions layout="vertical" column={1} className="text-left">
                        <Descriptions.Item label="Price" className="font-sans">
                            ${parseFloat(product.productPrice).toFixed(2)}
                        </Descriptions.Item>
                        <Descriptions.Item label="Manufacturer" className="font-sans">
                            {product.manufacturerName}
                        </Descriptions.Item>
                    </Descriptions>
                    <Divider />
                    <Title level={4} className="text-left font-serif">General Information</Title>
                    <Paragraph className="text-left font-sans">{product.generalInformation}</Paragraph>
                    <Divider />
                    <Title level={4} className="text-left font-serif">Common Use</Title>
                    <Paragraph className="text-left font-sans">{product.commonUse}</Paragraph>
                </div>
            </div>
            <Divider />
            <div className="p-4">
                <Title level={4} className="text-left font-serif">Warnings</Title>
                <Paragraph className="text-left font-sans">{product.warnings}</Paragraph>
                <Divider />
                <Title level={4} className="text-left font-serif">Ingredients</Title>
                <Paragraph className="text-left font-sans">{product.ingredients}</Paragraph>
                <Divider />
                <Title level={4} className="text-left font-serif">Directions</Title>
                <Paragraph className="text-left font-sans">{product.directions}</Paragraph>
                <Divider />
                <Title level={4} className="text-left font-serif">Summary</Title>
                <Paragraph className="text-left font-sans">{product.summary}</Paragraph>
            </div>
        </Card>
    );
};

export default ProductDetailsDisplay;