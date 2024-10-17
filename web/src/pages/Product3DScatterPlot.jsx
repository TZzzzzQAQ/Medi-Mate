
import ReactECharts from 'echarts-for-react';
import * as echarts from 'echarts';
import 'echarts-gl';

const Product3DScatterPlot = ({ products }) => {
    const get3DScatterOption = () => {
        // 按品牌聚合数据
        const brandData = products.reduce((acc, product) => {
            const brand = product.manufacturerName;
            if (!acc[brand]) {
                acc[brand] = { totalPrice: 0, count: 0 };
            }
            acc[brand].totalPrice += parseFloat(product.productPrice);
            acc[brand].count += 1;
            return acc;
        }, {});

        // 转换数据为3D散点图所需格式
        const data = Object.entries(brandData).map(([brand, info]) => {
            const averagePrice = info.totalPrice / info.count;
            return [brand, averagePrice, info.count];
        });

        const maxPrice = Math.max(...data.map(item => item[1]));
        const maxCount = Math.max(...data.map(item => item[2]));

        return {
            title: { text: '3D View: Brand, Average Price & Product Count', left: 'center' },
            tooltip: {
                formatter: (params) => {
                    const data = params.data;
                    return `Brand: ${data[0]}<br/>Average Price: $${data[1].toFixed(2)}<br/>Product Count: ${data[2]}`;
                }
            },
            xAxis3D: { name: 'Brand', type: 'category' },
            yAxis3D: { name: 'Average Price ($)', type: 'value', max: maxPrice },
            zAxis3D: { name: 'Product Count', type: 'value', max: maxCount },
            grid3D: {
                viewControl: {
                    projection: 'orthographic',
                    rotateSensitivity: 1,
                    zoomSensitivity: 1,
                    panSensitivity: 1,
                    damping: 0.8
                },
                light: {
                    main: { intensity: 1.2, shadow: true },
                    ambient: { intensity: 0.3 }
                }
            },
            series: [{
                type: 'scatter3D',
                data: data,
                symbolSize: (dataItem) => {
                    return Math.sqrt(dataItem[2]) * 1.5; // 根据产品数量调整点的大小
                },
                itemStyle: {
                    color: (params) => {
                        const price = params.data[1];
                        const normalizedPrice = price / maxPrice;
                        return new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                            offset: 0, color: `rgba(0, 255, 255, ${normalizedPrice})`
                        }, {
                            offset: 1, color: `rgba(0, 0, 255, ${normalizedPrice})`
                        }]);
                    },
                    opacity: 0.8,
                    shadowBlur: 10,
                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                },
                emphasis: {
                    itemStyle: { opacity: 1 }
                }
            }]
        };
    };

    return (
        <ReactECharts
            option={get3DScatterOption()}
            style={{ height: '600px' }}
            echarts={echarts}
        />
    );
};

export default Product3DScatterPlot;