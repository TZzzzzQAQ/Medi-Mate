import {useState, useCallback} from 'react';
import {useNavigate} from 'react-router-dom';
import {Button} from 'antd';
import {LeftOutlined, RightOutlined} from '@ant-design/icons';
import {getImagePath, getGoogleMapsUrl} from '../utils/utils';
import LeafletPharmacyMap from './LeafletPharmacyMap';

const Pharmacies = () => {
    const navigate = useNavigate();
    const [currentIndex, setCurrentIndex] = useState(0);
    const [pharmacies, setPharmacies] = useState([]);

    const handlePharmaciesLoaded = useCallback((loadedPharmacies) => {
        setPharmacies(loadedPharmacies);
    }, []);

    const handleViewInventory = () => {
        if (pharmacies[currentIndex]) {
            navigate(`/pharmacies/inventory/${pharmacies[currentIndex].pharmacyId}`);
        }
    };

    const handleNext = useCallback(() => {
        if (pharmacies.length > 0) {
            setCurrentIndex((prevIndex) => (prevIndex + 1) % pharmacies.length);
        }
    }, [pharmacies.length]);

    const handlePrevious = useCallback(() => {
        if (pharmacies.length > 0) {
            setCurrentIndex((prevIndex) => (prevIndex - 1 + pharmacies.length) % pharmacies.length);
        }
    }, [pharmacies.length]);

    return (
        <div className="relative w-full h-full">
            <div className="absolute inset-0 z-0">
                <LeafletPharmacyMap
                    onPharmaciesLoaded={handlePharmaciesLoaded}
                    currentIndex={currentIndex}
                />
            </div>

            {pharmacies[currentIndex] && (
                <div
                    className="absolute top-4 left-1/2 transform -translate-x-1/2 w-11/12 md:w-3/4 lg:w-1/2 bg-white rounded-xl shadow-lg overflow-hidden transition-all duration-300 ease-in-out z-10">
                    <div className="flex p-4 items-center">
                        <Button icon={<LeftOutlined/>} onClick={handlePrevious} className="mr-2"/>
                        <div className="flex-grow flex items-center">
                            <img
                                src={getImagePath(pharmacies[currentIndex].pharmacyName)}
                                alt={pharmacies[currentIndex].pharmacyName}
                                className="w-1/4 h-32 object-cover rounded-lg mr-4"
                            />
                            <div className="w-3/4">
                                <div className="text-xl text-indigo-500 font-semibold">
                                    {pharmacies[currentIndex].pharmacyName}
                                </div>
                                <a
                                    href={getGoogleMapsUrl(pharmacies[currentIndex].pharmacyAddress)}
                                    target="_blank"
                                    rel="noopener noreferrer"
                                    className="mt-2 block text-gray-500 text-base hover:text-indigo-600 transition duration-150 ease-in-out"
                                >
                                    {pharmacies[currentIndex].pharmacyAddress}
                                </a>
                                <button
                                    onClick={handleViewInventory}
                                    className="mt-4 w-full px-4 py-2 border border-transparent text-base font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-400 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition duration-150 ease-in-out"
                                >
                                    View Inventory
                                </button>
                            </div>
                        </div>
                        <Button icon={<RightOutlined/>} onClick={handleNext} className="ml-2"/>
                    </div>
                </div>
            )}
        </div>
    );
};

export default Pharmacies;