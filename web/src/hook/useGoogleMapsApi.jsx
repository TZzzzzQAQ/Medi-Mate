// src/hook/useGoogleMapsApi.jsx
import { useState, useEffect } from 'react';
import { GOOGLE_MAPS_API_KEY } from '@/../config.js';

let isScriptLoaded = false;

const useGoogleMapsApi = () => {
    const [isLoaded, setIsLoaded] = useState(false);

    useEffect(() => {
        if (isScriptLoaded) {
            setIsLoaded(true);
            return;
        }

        const script = document.createElement('script');
        script.src = `https://maps.googleapis.com/maps/api/js?key=${GOOGLE_MAPS_API_KEY}&libraries=places`;
        script.async = true;
        script.defer = true;
        script.onload = () => {
            isScriptLoaded = true;
            setIsLoaded(true);
        };
        document.head.appendChild(script);

        return () => {
            document.head.removeChild(script);
        };
    }, []);

    return isLoaded;
};

export default useGoogleMapsApi;