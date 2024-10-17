import {useState} from 'react';
import {useNavigate} from 'react-router-dom';
import {sendUserDataAPI} from "@/api/user/user.jsx";
import {setUserToken} from "@/utils/index.jsx";

function useLogin() {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');

    const [error, setError] = useState('');
    const [isLoading, setIsLoading] = useState(false);

    const navigate = useNavigate();

    const handleSubmit = async (e) => {
        e.preventDefault();

        setError('');
        setIsLoading(true);

        try {
            const response = await sendUserDataAPI({email, password});
            if (response.data.token) {
                setUserToken(response.data.token);
                navigate('/analytics');
            } else {
                setError('Login failed');
            }
        } catch (err) {
            console.error('Login error:', err);
            setError(err.response?.data?.message || 'Login failed, try again');
        } finally {
            setIsLoading(false);
        }
    };

    return {
        email, setEmail,
        password, setPassword,
        error, setError,
        isLoading, setIsLoading,
        handleSubmit,
    };
}

export default useLogin;
