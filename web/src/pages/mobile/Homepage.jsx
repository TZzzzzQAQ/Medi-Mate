import React from 'react';
import { Outlet } from 'react-router-dom';
import PhotoCapture from './PhotoCapture';

const Homepage = () => {
  return (
    <div>
      <Outlet />
    </div>
    //Outlet组件是一个占位符，用于渲染子路由
  );
};

export default Homepage;