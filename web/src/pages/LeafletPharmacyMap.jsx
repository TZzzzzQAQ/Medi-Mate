import React, {useState, useEffect, useRef} from 'react';
import {MapContainer, TileLayer, Marker, Popup, useMap} from 'react-leaflet';
import {Icon} from 'leaflet';
import 'leaflet/dist/leaflet.css';
import {getPharmaciesAPI} from '@/api/user/pharmacy';
import {Spin} from 'antd';

function ChangeView({center, zoom}) {
    const map = useMap();
    map.setView(center, zoom);
    return null;
}

const LeafletPharmacyMap = ({onPharmaciesLoaded, currentIndex}) => {
    const [pharmacies, setPharmacies] = useState([]);
    const [loading, setLoading] = useState(true);
    const [center, setCenter] = useState([-36.8485, 174.7633]); // Default to Auckland
    const mapRef = useRef(null);

    useEffect(() => {
        const fetchPharmacies = async () => {
            try {
                const response = await getPharmaciesAPI();
                if (response.code === 1 && Array.isArray(response.data)) {
                    const validPharmacies = response.data.filter(pharmacy => {
                        const lat = parseFloat(pharmacy.latitude);
                        const lng = parseFloat(pharmacy.longitude);
                        return !isNaN(lat) && !isNaN(lng) && lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180;
                    });
                    setPharmacies(validPharmacies);
                    onPharmaciesLoaded(validPharmacies);
                    if (validPharmacies.length > 0) {
                        setCenter([parseFloat(validPharmacies[0].latitude), parseFloat(validPharmacies[0].longitude)]);
                    }
                }
            } catch (error) {
                console.error('Error fetching pharmacies:', error);
            } finally {
                setLoading(false);
            }
        };
        fetchPharmacies();
    }, [onPharmaciesLoaded]);

    useEffect(() => {
        if (pharmacies.length > 0 && currentIndex >= 0 && currentIndex < pharmacies.length) {
            const newCenter = [
                parseFloat(pharmacies[currentIndex].latitude),
                parseFloat(pharmacies[currentIndex].longitude)
            ];
            setCenter(newCenter);
        }
    }, [currentIndex, pharmacies]);

    if (loading) {
        return <Spin size="large"/>;
    }

    const customIcon = new Icon({
        iconUrl: 'https://unpkg.com/leaflet@1.7.1/dist/images/marker-icon.png',
        iconSize: [25, 41],
        iconAnchor: [12, 41],
    });

    return (
        <MapContainer
            center={center}
            zoom={18}
            style={{height: '100%', width: '100%'}}
            ref={mapRef}
        >
            <ChangeView center={center} zoom={13}/>
            <TileLayer
                url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
            />
            {pharmacies.map((pharmacy, index) => (
                <Marker
                    key={pharmacy.pharmacyId}
                    position={[parseFloat(pharmacy.latitude), parseFloat(pharmacy.longitude)]}
                    icon={customIcon}
                >
                    <Popup>
                        <div>
                            <h3>{pharmacy.pharmacyName}</h3>
                            <p>{pharmacy.pharmacyAddress}</p>
                        </div>
                    </Popup>
                </Marker>
            ))}
        </MapContainer>
    );
};

export default LeafletPharmacyMap;