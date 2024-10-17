import { createBrowserRouter } from 'react-router-dom';

import Result from '../pages/Result';
import HomePage from '../pages/HomePage';
import ProductDetail from '../pages/ProductDetail';

const router = createBrowserRouter([
    {
      path: '/',
      element: <HomePage />,
    },
    {
      path: '/result',
        element: <Result />,
    },
    {
        path: '/result/:productId',
        element: <ProductDetail />,
    }
  ]);


export default router;