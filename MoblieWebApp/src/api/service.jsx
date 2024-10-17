import axios from 'axios';
import { APP_API_URL } from '/config.js';

const client = axios.create({
    baseURL: APP_API_URL,
  });
  
export const getProductByIdAPI = async (productId) => {
    try {
        const response = await client.get('/products/productDetail', {
            params: {
                productId,
            },
        });
      return response.data;
    } catch (error) {
      throw error;
    }
  };