import {useState, useEffect} from 'react';
import {Layout, Card, Spin, Row, Col, Typography} from 'antd';
import ReactECharts from 'echarts-for-react';
import {getProductsAPI} from "@/api/user/products.jsx";
import 'echarts-gl';
import Product3DScatterPlot from './Product3DScatterPlot';

const {Title, Paragraph} = Typography;

const ProductAnalytics = () => {
    const [loading, setLoading] = useState(true);
    const [products, setProducts] = useState([]);
    const [selectedManufacturer] = useState("");

    useEffect(() => {
        fetchData();
    }, []);

    const fetchData = async () => {
        setLoading(true);
        try {
            const response = await getProductsAPI({page: 1, pageSize: 8905});
            if (response && response.data && response.data.records) {
                setProducts(response.data.records);
            }
        } catch (error) {
            console.error('Error fetching products:', error);
        } finally {
            setLoading(false);
        }
    };

    const filteredProducts = selectedManufacturer
        ? products.filter(product => product.manufacturerName === selectedManufacturer)
        : products;

    const getPriceDistributionOption = () => {
        const priceRanges = [0, 10, 20, 50, 100, 200];
        const distribution = priceRanges.map((range, index) => {
            const nextRange = priceRanges[index + 1] || Infinity;
            const count = filteredProducts.filter(product => {
                const price = parseFloat(product.productPrice);
                return price >= range && price < nextRange;
            }).length;
            return {range: `$${range} - ${nextRange === Infinity ? '+' : '$' + nextRange}`, count};
        });

        return {
            title: {text: 'Product Price Distribution', left: 'center'},
            tooltip: {trigger: 'item'},
            legend: {orient: 'vertical', left: 'left'},
            series: [{
                name: 'Price Range',
                type: 'pie',
                radius: '50%',
                data: distribution.map(item => ({value: item.count, name: item.range})),
                emphasis: {
                    itemStyle: {
                        shadowBlur: 10,
                        shadowOffsetX: 0,
                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                    }
                }
            }]
        };
    };

    const getProductCategoryAnalysisOption = () => {
        const categories = filteredProducts.reduce((acc, product) => {
            const category = product.productName.split(' ')[0]; // Simple categorization by first word
            acc[category] = (acc[category] || 0) + 1;
            return acc;
        }, {});

        const sortedCategories = Object.entries(categories)
            .sort((a, b) => b[1] - a[1])
            .slice(0, 10);

        return {
            title: {text: 'Top 10 Product Categories', left: 'center'},
            tooltip: {trigger: 'axis', axisPointer: {type: 'shadow'}},
            xAxis: {type: 'value', name: 'Number of Products'},
            yAxis: {type: 'category', data: sortedCategories.map(item => item[0]), inverse: true},
            series: [{
                name: 'Product Count',
                type: 'bar',
                data: sortedCategories.map(item => item[1]),
                itemStyle: {color: '#5470c6'}
            }]
        };
    };

    const getInfoLengthAnalysisOption = () => {
        const infoLengths = filteredProducts.map(product => ({
            name: product.productName,
            value: product.generalInformation ? product.generalInformation.length : 0
        }));

        infoLengths.sort((a, b) => b.value - a.value);

        return {
            title: {text: 'Product Information Length Analysis', left: 'center'},
            tooltip: {trigger: 'axis', axisPointer: {type: 'shadow'}},
            xAxis: {type: 'value', name: 'Information Length (characters)'},
            yAxis: {type: 'category', data: infoLengths.slice(0, 20).map(item => item.name), inverse: true},
            series: [{
                name: 'Information Length',
                type: 'bar',
                data: infoLengths.slice(0, 20).map(item => item.value),
                itemStyle: {color: '#91cc75'}
            }]
        };
    };

    const getKeywordAnalysisOption = () => {
        const keywords = filteredProducts.flatMap(product =>
            (product.productName + ' ' + (product.summary || '')).toLowerCase().split(/\W+/)
        );
        const keywordFrequency = keywords.reduce((acc, word) => {
            if (word.length > 3) { // Ignore short words
                acc[word] = (acc[word] || 0) + 1;
            }
            return acc;
        }, {});

        const sortedKeywords = Object.entries(keywordFrequency)
            .sort((a, b) => b[1] - a[1])
            .slice(0, 20);

        return {
            title: {text: 'Top 20 Keywords', left: 'center'},
            tooltip: {trigger: 'axis', axisPointer: {type: 'shadow'}},
            xAxis: {type: 'value', name: 'Frequency'},
            yAxis: {type: 'category', data: sortedKeywords.map(item => item[0]), inverse: true},
            series: [{
                name: 'Keyword Frequency',
                type: 'bar',
                data: sortedKeywords.map(item => item[1]),
                itemStyle: {color: '#fac858'}
            }]
        };
    };

    return (
        <Layout className={"bg-transparent"}>
            <Title level={2}>Product Analytics</Title>
            {loading ? (
                <Spin size="large" className={"flex items-center justify-center"}/>
            ) : (
                <Row gutter={[16, 16]}>
                    <Col span={12}>
                        <Card title="Price Distribution">
                            <ReactECharts
                                option={getPriceDistributionOption()}
                                style={{height: '400px'}}
                            />
                        </Card>
                    </Col>
                    <Col span={12}>
                        <Card title="Product Category Analysis">
                            <ReactECharts
                                option={getProductCategoryAnalysisOption()}
                                style={{height: '400px'}}
                            />
                        </Card>
                    </Col>
                    <Col span={24}>
                        <Card title="Product Information Length Analysis">
                            <ReactECharts
                                option={getInfoLengthAnalysisOption()}
                                style={{height: '400px'}}
                            />
                        </Card>
                    </Col>
                    <Col span={24}>
                        <Card title="Keyword Analysis">
                            <ReactECharts
                                option={getKeywordAnalysisOption()}
                                style={{height: '400px'}}
                            />
                        </Card>
                    </Col>
                    <Col span={24}>
                        <Card title="3D Brand Analysis: Average Price, Product Count">
                            <Product3DScatterPlot products={filteredProducts}/>
                        </Card>
                    </Col>
                    {selectedManufacturer && (
                        <Col span={24}>
                            <Card title="Brand Insights">
                                <Paragraph>
                                    Total Products: {filteredProducts.length}
                                </Paragraph>
                                <Paragraph>
                                    Average Price:
                                    ${(filteredProducts.reduce((sum, product) => sum + parseFloat(product.productPrice), 0) / filteredProducts.length).toFixed(2)}
                                </Paragraph>
                                <Paragraph>
                                    Price Range:
                                    ${Math.min(...filteredProducts.map(p => parseFloat(p.productPrice))).toFixed(2)} -
                                    ${Math.max(...filteredProducts.map(p => parseFloat(p.productPrice))).toFixed(2)}
                                </Paragraph>
                            </Card>
                        </Col>
                    )}
                </Row>
            )}
        </Layout>
    );
};

export default ProductAnalytics;