import { useEffect } from 'react';
import { motion } from 'framer-motion';
import { SmileOutlined } from '@ant-design/icons';
import { notification } from "antd";
import useLogin from "@/hook/useLogin.jsx";

export default function TLogin() {
    const {
        email, setEmail,
        password, setPassword,
        error,
        isLoading,
        handleSubmit
    } = useLogin();

    const [api, contextHolder] = notification.useNotification();

    const openNotification = (message) => {
        api.open({
            message: 'Login Error',
            description: message,
            icon: <SmileOutlined style={{ color: '#f5222d' }} />,
        });
    };

    useEffect(() => {
        if (error) {
            openNotification(error);
        }
    }, [error]);

    return (
        <>
            {contextHolder}
            <div className="flex min-h-full flex-1 flex-col justify-center px-6 py-12 lg:px-8">
                <div className="sm:mx-auto sm:w-full sm:max-w-sm">
                    <h1 className="mt-6 text-center text-6xl font-extrabold text-gray-900 font-poppins">
                        MediMate
                    </h1>
                    <h2 className="mt-10 text-center text-2xl font-bold leading-7 tracking-tight text-gray-900">
                        Sign in to your account
                    </h2>
                </div>

                <motion.div
                    initial={{ opacity: 0, y: 50 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 0.5 }}
                    className="mt-10 sm:mx-auto sm:w-full sm:max-w-sm"
                >
                    <form onSubmit={handleSubmit} className="space-y-6">
                        <div>
                            <label htmlFor="email" className="block text-sm font-medium leading-6 text-gray-900">
                                Email address
                            </label>
                            <div className="mt-2">
                                <input
                                    id="email"
                                    name="email"
                                    type="email"
                                    required
                                    autoComplete="email"
                                    value={email}
                                    onChange={(e) => setEmail(e.target.value)}
                                    className="block w-full rounded-md border-0 px-3 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-black sm:text-sm sm:leading-6"
                                />
                            </div>
                        </div>

                        <div>
                            <div className="flex items-center justify-between">
                                <label htmlFor="password" className="block text-sm font-medium leading-6 text-gray-900">
                                    Password
                                </label>
                            </div>
                            <div className="mt-2">
                                <input
                                    id="password"
                                    name="password"
                                    type="password"
                                    required
                                    autoComplete="current-password"
                                    value={password}
                                    onChange={(e) => setPassword(e.target.value)}
                                    className="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-black sm:text-sm sm:leading-6 px-3"
                                />
                            </div>
                        </div>

                        <div>
                            <button
                                type="submit"
                                className="flex w-full justify-center rounded-md bg-black px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
                                disabled={isLoading}
                            >
                                {isLoading ? 'Signing In...' : 'Sign in'}
                            </button>
                        </div>
                    </form>

                    <p className="mt-10 text-center text-sm text-gray-500">
                        Forget password?{' '}
                        <a href="#" className="font-semibold leading-6 text-indigo-600 hover:text-indigo-500">
                            Ask manager for help
                        </a>
                    </p>
                </motion.div>
            </div>
        </>
    );
}