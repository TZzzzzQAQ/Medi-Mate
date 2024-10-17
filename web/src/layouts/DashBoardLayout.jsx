import { useState, useEffect, useCallback, useRef} from 'react';
import { ConfigProvider, Layout, Button, notification } from 'antd';
// import { LeftOutlined, RightOutlined } from '@ant-design/icons';
import LeftMenuLayout from "@/layouts/LeftMenuLayout";
import { Outlet, useLocation, useNavigate } from "react-router-dom";
import HeaderLayout from "@/layouts/HeaderLayout";
import { APP_API_URL } from "@/../config.js";
import { setOrderInfo } from "@/store/features/messageSlice";

import { useDispatch } from "react-redux";

const { Header, Sider, Content } = Layout;

const themeConfig = {
    components: {
        Layout: {
            bodyBg: '#f5f7fa',
            headerBg: '#ffffff',
            siderBg: '#f8f7f4'  // 保持不变
        },
        Menu: {
            itemSelectedBg: '#1d39c4',
            itemSelectedColor: '#ffffff',
            itemColor: 'rgba(0, 0, 0, 0.65)',
            itemBg: 'transparent',
            itemHoverColor: '#2f54eb',
            itemHoverBg: 'rgba(45, 83, 235, 0.1)'
        },
        Button: {
            primaryColor: '#ffffff',
            primaryBg: '#2f54eb',
            primaryHoverBg: '#597ef7',
            defaultBg: '#ffffff',
            defaultColor: 'rgba(0, 0, 0, 0.85)',
            defaultHoverBg: '#ffffff',
            defaultHoverColor: '#2f54eb'
        }
    },
    token: {
        colorPrimary: '#2f54eb',
        colorBgContainer: '#ffffff'
    },
};

const DashboardLayout = () => {
    const [collapsed, setCollapsed] = useState({ left: true, right: true });
    const [isHovering, setIsHovering] = useState(false);
    const [messages, setMessages] = useState([]);

    const navigate = useNavigate();
    const dispatch = useDispatch()
    const audioRef = useRef(null);

    const playAudio = () => {
        if (audioRef.current) {
            audioRef.current.play();
        }
    };

    useEffect(() => {
        const eventSource = new EventSource(`${APP_API_URL}/sse/connect`);

        eventSource.onmessage = event => {
            const newMessage = JSON.parse(event.data);
            if (newMessage.orderId === "ping") {
                return;
            }
            setMessages(prevMessages => [...prevMessages, newMessage]);
            dispatch(setOrderInfo({
                orderId: newMessage.orderId,
                pharmacyId: newMessage.pharmacyId  // Assuming the API sends pharmacyId
            }));
            console.log("New message:", newMessage);
        };

        eventSource.onerror = error => {
            console.error("EventSource failed:", error);
            eventSource.close();
        };

        return () => {
            eventSource.close();
        };
    }, []);

    useEffect(() => {
        if (!messages.length) return;
        openNotification('topRight');
        playAudio();

    }, [messages]);
    const [api, contextHolder] = notification.useNotification();
    const openNotification = (placement) => {
        api.info({
            message: "New Order",
            description: `New order has been received`,
            placement,
            onClick: () => {
                navigate(`/OrderPage`, { replace: true });
                audioRef.current.pause();
            },

        });
    };

    const location = useLocation();

    useEffect(() => {
        setCollapsed(prev => ({ ...prev, right: true }));
    }, [location.pathname]);

    const toggleCollapsed = useCallback((side) => {
        setCollapsed(prev => ({ ...prev, [side]: !prev[side] }));
    }, []);

    const handleMouseEnter = useCallback(() => {
        setIsHovering(true);
        setCollapsed(prev => ({ ...prev, left: false }));
    }, []);

    const handleMouseLeave = useCallback(() => {
        setIsHovering(false);
        setCollapsed(prev => ({ ...prev, left: true }));
    }, []);

    return (
        <ConfigProvider theme={themeConfig}>
            {contextHolder}
            <audio ref={audioRef} src="/assets/sound.mp3" />
            <Layout className="h-screen overflow-hidden">
                <Sider
                    collapsible
                    collapsed={collapsed.left && !isHovering}
                    onCollapse={() => toggleCollapsed('left')}
                    onMouseEnter={handleMouseEnter}
                    onMouseLeave={handleMouseLeave}
                    className="transition-all duration-300 ease-in-out"
                    trigger={null}
                >
                    <LeftMenuLayout collapsed={collapsed.left && !isHovering} />
                </Sider>
                <Layout>
                    <Header className="flex items-center justify-between px-4">
                        <HeaderLayout />
                    </Header>

                    <Layout className="overflow-hidden">
                        <Content
                            className="p-6 m-4 bg-white rounded-lg shadow-md overflow-y-auto h-[calc(100vh-112px)]">
                            <Outlet />
                        </Content>
                        {/*<Sider*/}
                        {/*    width={collapsed.right ? 80 : "20%"}*/}
                        {/*    className="bg-white m-4 rounded-lg shadow-md"*/}
                        {/*    collapsible*/}
                        {/*    collapsed={collapsed.right}*/}
                        {/*    reverseArrow*/}
                        {/*    collapsedWidth={80}*/}
                        {/*    trigger={null}*/}
                        {/*>*/}
                        {/*    <div className="p-4 text-center">*/}
                        {/*        <Button*/}
                        {/*            type="primary"*/}
                        {/*            onClick={() => toggleCollapsed('right')}*/}
                        {/*            icon={collapsed.right ? <LeftOutlined /> : <RightOutlined />}*/}
                        {/*        >*/}
                        {/*            {collapsed.right ? '' : 'Collapse'}*/}
                        {/*        </Button>*/}
                        {/*    </div>*/}
                        {/*    {!collapsed.right && <div className="p-4 text-gray-600">Right Sidebar Content</div>}*/}
                        {/*</Sider>*/}
                    </Layout>
                </Layout>
            </Layout>
        </ConfigProvider>
    );
};

export default DashboardLayout;