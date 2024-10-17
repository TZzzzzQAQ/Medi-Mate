import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { ArrowLeft } from 'lucide-react';
import { getProductByIdAPI } from '../api/service';

const ProductDetail = () => {
  const { productId } = useParams();
  const navigate = useNavigate();
  const [product, setProduct] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchProduct = async () => {
      try {
        const response = await getProductByIdAPI(productId);
        // Extract the product data from the response
        if (response && response.data) {
          setProduct(response.data);
        } else {
          throw new Error('Product data not found in the response');
        }
      } catch (error) {
        console.error("Error fetching product:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchProduct();
  }, [productId]);

  if (loading) {
    return (
      <div className="flex items-center justify-center h-screen bg-gray-100 p-4">
        <div className="w-full max-w-md bg-white rounded-lg shadow-md p-6">
          <p className="text-center text-gray-600">Loading...</p>
        </div>
      </div>
    );
  }

  if (!product) {
    return (
      <div className="flex items-center justify-center h-screen bg-gray-100 p-4">
        <div className="w-full max-w-md bg-white rounded-lg shadow-md p-6">
          <p className="text-center text-gray-600">Product not found.</p>
        </div>
      </div>
    );
  }

  return (
    <div className="bg-gray-100 min-h-screen p-4">
      <div className="max-w-4xl mx-auto bg-white rounded-lg shadow-md p-6">
        <button
          onClick={() => navigate(-1)}
          className="mb-4 flex items-center text-blue-500 hover:text-blue-600"
        >
          <ArrowLeft className="mr-2" size={20} />
          Back to Results
        </button>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <img
              src={product.imageSrc}
              alt={product.productName}
              className="w-full h-64 object-cover rounded-lg mb-4"
            />
            <h1 className="text-2xl font-bold mb-2">{product.productName}</h1>
            <p className="text-xl font-bold text-green-600 mb-4">${product.productPrice}</p>
            <p className="text-gray-600 mb-2">Manufacturer: {product.manufacturerName}</p>
          </div>
          <div>
            <h2 className="text-xl font-semibold mb-2">Product Summary</h2>
            <p className="mb-4">{product.summary}</p>
            <h3 className="font-semibold mb-1">General Information:</h3>
            <p className="mb-3">{product.generalInformation}</p>
            <h3 className="font-semibold mb-1">Directions:</h3>
            <p className="mb-3">{product.directions}</p>
            <h3 className="font-semibold mb-1">Ingredients:</h3>
            <p className="mb-3">{product.ingredients}</p>
            <h3 className="font-semibold mb-1 text-red-600">Warnings:</h3>
            <p className="mb-3 text-red-600">{product.warnings}</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ProductDetail;