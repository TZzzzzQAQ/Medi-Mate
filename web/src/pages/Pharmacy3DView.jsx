import React, { useState } from 'react';
import { Image } from 'antd';

const PharmacyShelfView = ({ inventory, selectedProduct }) => {
    const [hoveredCell, setHoveredCell] = useState(null);

    const shelves = ['A', 'B', 'C', 'D', 'E'];
    const levels = [1, 2, 3, 4, 5, 6];

    const getProductsForCell = (shelf, level) => {
        return inventory.filter(item => item.shelfNumber === shelf && item.shelfLevel === level);
    };

    const isSelectedCell = (shelf, level) => {
        return selectedProduct && selectedProduct.shelfNumber === shelf && selectedProduct.shelfLevel === level;
    };

    return (
        <div className="pharmacy-shelf-view">
            <div className="shelf-container">
                {shelves.map(shelf => (
                    <div key={shelf} className="shelf">
                        {levels.map(level => {
                            const products = getProductsForCell(shelf, level);
                            const isSelected = isSelectedCell(shelf, level);
                            return (
                                <div
                                    key={`${shelf}-${level}`}
                                    className={`shelf-cell ${products.length > 0 ? 'has-products' : ''} ${isSelected ? 'selected' : ''}`}
                                    onMouseEnter={() => setHoveredCell({ shelf, level, products })}
                                    onMouseLeave={() => setHoveredCell(null)}
                                >
                                    {products.length > 0 ? (
                                        <Image
                                            src={products[0].imageSrc}
                                            alt={products[0].productName}
                                            preview={false}
                                            className="product-image"
                                        />
                                    ) : (
                                        <span className="cell-number">{level}</span>
                                    )}
                                </div>
                            );
                        })}
                        <div className="shelf-label">{shelf}</div>
                    </div>
                ))}
            </div>
            {hoveredCell && (
                <div className="product-tooltip">
                    <h3>Shelf {hoveredCell.shelf}, Level {hoveredCell.level}</h3>
                    {hoveredCell.products.length > 0 ? (
                        <ul>
                            {hoveredCell.products.map(product => (
                                <li key={product.productName}>
                                    {product.productName} - Quantity: {product.stockQuantity}
                                </li>
                            ))}
                        </ul>
                    ) : (
                        <p>No products in this location</p>
                    )}
                </div>
            )}
            <style jsx>{`
                .pharmacy-shelf-view {
                    position: relative;
                    padding: 20px;
                }
                .shelf-container {
                    display: flex;
                    justify-content: space-around;
                }
                .shelf {
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                }
                .shelf-label {
                    font-weight: bold;
                    margin-top: 10px;
                }
                .shelf-cell {
                    width: 60px;
                    height: 60px;
                    border: 1px solid #ccc;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin: 2px;
                    cursor: pointer;
                    overflow: hidden;
                    position: relative;
                }
                .has-products {
                    background-color: #e6f7ff;
                }
                .selected {
                    border: 2px solid #faad14;
                    box-shadow: 0 0 10px rgba(250, 173, 20, 0.5);
                }
                .product-image {
                    max-width: 100%;
                    max-height: 100%;
                    object-fit: cover;
                }
                .cell-number {
                    font-size: 24px;
                    color: #999;
                }
                .product-tooltip {
                    position: absolute;
                    top: 10px;
                    right: 10px;
                    background-color: white;
                    border: 1px solid #ccc;
                    padding: 10px;
                    border-radius: 4px;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
                    max-width: 300px;
                }
            `}</style>
        </div>
    );
};

export default PharmacyShelfView;