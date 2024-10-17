
import { Form, Input, InputNumber, Button, message, Upload } from 'antd';
import { UploadOutlined } from '@ant-design/icons';

const { TextArea } = Input;

const NewProductForm = () => {
    const [form] = Form.useForm();

    const onFinish = (values) => {
        console.log('Form values:', values);
        // Here you would typically send the data to your API
        message.success('Product successfully added!');
        form.resetFields();
    };

    const normFile = (e) => {
        if (Array.isArray(e)) {
            return e;
        }
        return e?.fileList;
    };

    return (
        <Form
            form={form}
            layout="vertical"
            onFinish={onFinish}
            style={{ maxWidth: '800px', margin: '0 auto' }}
        >
            <Form.Item
                name="imageSrc"
                label="Product Image"
                valuePropName="fileList"
                getValueFromEvent={normFile}
            >
                <Upload name="logo" listType="picture">
                    <Button icon={<UploadOutlined />}>Click to upload</Button>
                </Upload>
            </Form.Item>

            <Form.Item name="productName" label="Product Name" rules={[{ required: true, message: 'Please input the product name!' }]}>
                <Input />
            </Form.Item>

            <Form.Item name="productPrice" label="Price" rules={[{ required: true, message: 'Please input the price!' }]}>
                <InputNumber
                    formatter={value => `$ ${value}`.replace(/\B(?=(\d{3})+(?!\d))/g, ',')}
                    parser={value => value.replace(/\$\s?|(,*)/g, '')}
                    style={{ width: '100%' }}
                />
            </Form.Item>

            <Form.Item name="manufacturerName" label="Manufacturer" rules={[{ required: true, message: 'Please input the manufacturer name!' }]}>
                <Input />
            </Form.Item>

            <Form.Item name="generalInformation" label="General Information">
                <TextArea rows={6} />
            </Form.Item>

            <Form.Item name="warnings" label="Warnings">
                <TextArea rows={4} />
            </Form.Item>

            <Form.Item name="commonUse" label="Common Use">
                <TextArea rows={4} />
            </Form.Item>

            <Form.Item name="ingredients" label="Ingredients">
                <TextArea rows={4} />
            </Form.Item>

            <Form.Item name="directions" label="Directions">
                <TextArea rows={4} />
            </Form.Item>

            <Form.Item name="summary" label="Summary">
                <TextArea rows={6} />
            </Form.Item>

            <Form.Item>
                <Button type="primary" htmlType="submit">
                    Add Product
                </Button>
                <Button style={{ marginLeft: 8 }} onClick={() => form.resetFields()}>
                    Reset
                </Button>
            </Form.Item>
        </Form>
    );
};

export default NewProductForm;