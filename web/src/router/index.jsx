import {createBrowserRouter, Navigate, Outlet} from 'react-router-dom';
import TLogin from "@/pages/TLogin.jsx";
import DashBoardLayout from "@/layouts/DashBoardLayout.jsx";
import Products from "@/pages/Products.jsx";
import EditProduct from "@/pages/EditProduct.jsx";
import ViewProduct from "@/pages/ViewProduct.jsx";
import NewProductForm from "@/pages/NewAddProduct.jsx";
import ProductAnalytics from "@/pages/Analytics.jsx";
import Inventory from "@/pages/Inventory.jsx";
import Pharmacies from "@/pages/Pharmacies.jsx";
import PharmacyInventory from "@/pages/PharmacyInventory.jsx";
import Homepage from '../pages/mobile/Homepage';
import OrderPage from '../pages/Order/OrderPage';
import ProductResultDisplay from '../pages/mobile/ProductResultDisplay';
import PhotoCapture from '../pages/mobile/PhotoCapture';

const isAuthenticated = () => {
    return localStorage.getItem('token') !== null;
};

const ProtectedRoute = () => {
    if (!isAuthenticated()) {
        return <Navigate to="/login" replace/>;
    }
    return <Outlet/>;
};

const router = createBrowserRouter([
    {
        path: '/',
        element: <Navigate to="/login" replace/>,
    },
    {
        path: '/login',
        element: <TLogin/>,
    },
    {
        path: '/mobile',
        element: <Homepage />,
        children: [
          {
            path: '',
            element: <PhotoCapture />,
          },
          {
            path: 'result',
            element: <ProductResultDisplay />,
          },
        ],
      },
    {
        path: '/',
        element: <ProtectedRoute/>, // 使用受保护的路由组件
        children: [
            {
                path: '/',
                element: <DashBoardLayout/>,
                children: [
                    {
                        path: 'analytics',
                        element: <ProductAnalytics/>,
                    },
                    {
                        path: 'products',
                        element: <Products/>,
                    },
                    {
                        path: 'products/productDetail/view/:id',
                        element: <ViewProduct/>,
                    },
                    {
                        path: 'products/productDetail/edit/:id',
                        element: <EditProduct/>,
                    },
                    {
                        path: 'products/new',
                        element: <NewProductForm/>,
                    },
                    {
                        path: 'inventory',
                        element: <Inventory/>,
                    },
                    {
                        path: 'pharmacies',
                        element: <Pharmacies/>,
                    },
                    {
                        path: '/pharmacies/inventory/:pharmacyId',
                        element: <PharmacyInventory/>,
                    },
                    {
                        path: 'OrderPage',
                        element: <OrderPage/>,
                    },
                ],
            },
        ],
    },
]);

export default router;