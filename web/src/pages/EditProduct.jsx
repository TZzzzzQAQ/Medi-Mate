import { useState, useEffect } from 'react';
import { Form, Input, InputNumber, Button, Spin, message, Image } from 'antd';
import { getProductByIdAPI, updateProductAPI } from "@/api/user/products.jsx";
import { useParams, useNavigate } from 'react-router-dom';

const { TextArea } = Input;

const DataFetchingProductForm = () => {
    const [form] = Form.useForm();
    const [loading, setLoading] = useState(true);
    const [submitting, setSubmitting] = useState(false);
    const [readOnly] = useState(false);
    const { id: productId } = useParams();
    const navigate = useNavigate();

    useEffect(() => {
        const fetchProductData = async () => {
            setLoading(true);
            try {
                const response = await getProductByIdAPI(productId);
                console.log('API response:', response);

                if (response && response.data) {
                    const productData = response.data.data || response.data;
                    if (productData) {
                        form.setFieldsValue(productData);
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
    }, [productId, form]);

    const onFinish = async (values) => {
        setSubmitting(true);
        try {
await updateProductAPI(productId, values);
            message.success('Product updated successfully');
            navigate(`/products/productDetail/view/${productId}`); // Redirect to product detail page
        } catch (error) {
            console.error('Error updating product:', error);
            message.error('Failed to update product');
        } finally {
            setSubmitting(false);
        }
    };

    if (loading) {
        return <Spin size="large" />;
    }

    return (
        <Form
            form={form}
            layout="vertical"
            onFinish={onFinish}
            style={{ maxWidth: '800px', margin: '0 auto' }}
        >
            <Form.Item name="imageSrc" label="Product Image">
                <Image
                    width={200}
                    src={form.getFieldValue('imageSrc')}
                />
            </Form.Item>
            <Form.Item name="productName" label="Product Name" rules={[{ required: true }]}>
                <Input readOnly={readOnly} />
            </Form.Item>
            <Form.Item name="productId" label="ID">
                <TextArea rows={4} readOnly={true} />
            </Form.Item>
            <Form.Item name="productPrice" label="Price" rules={[{ required: true }]}>
                <InputNumber
                    readOnly={readOnly}
                    formatter={value => `$ ${value}`.replace(/\B(?=(\d{3})+(?!\d))/g, ',')}
                    parser={value => value.replace(/\$\s?|(,*)/g, '')}
                />
            </Form.Item>
            <Form.Item name="manufacturerName" label="Manufacturer" rules={[{ required: true }]}>
                <Input readOnly={readOnly} />
            </Form.Item>
            <Form.Item name="generalInformation" label="General Information">
                <TextArea rows={6} readOnly={readOnly} />
            </Form.Item>
            <Form.Item name="warnings" label="Warnings">
                <TextArea rows={4} readOnly={readOnly} />
            </Form.Item>
            <Form.Item name="commonUse" label="Common Use">
                <TextArea rows={4} readOnly={readOnly} />
            </Form.Item>
            <Form.Item name="ingredients" label="Ingredients">
                <TextArea rows={4} readOnly={readOnly} />
            </Form.Item>
            <Form.Item name="directions" label="Directions">
                <TextArea rows={4} readOnly={readOnly} />
            </Form.Item>
            <Form.Item name="summary" label="Summary">
                <TextArea rows={6} readOnly={readOnly} />
            </Form.Item>
            {!readOnly && (
                <Form.Item>
                    <Button type="primary" htmlType="submit" loading={submitting}>
                        Update Product
                    </Button>
                    <Button style={{ marginLeft: 8 }} onClick={() => form.resetFields()}>
                        Reset
                    </Button>
                </Form.Item>
            )}
        </Form>
    );
};

export default DataFetchingProductForm;