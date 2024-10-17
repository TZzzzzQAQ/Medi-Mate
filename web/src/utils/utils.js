export const getImagePath = (pharmacyName) => {
    const nameMap = {
        'MediMate Albany': 'Albany.jpg',
        'MediMate Mount Albert': 'Albert.jpg',
        'MediMate CBD': 'CBD.jpg',
        'MediMate Manakau': 'Manakau.jpg',
        'MediMate NewMarket': 'NewMarket.jpg'
    };
    return `assets/images/${nameMap[pharmacyName] || 'default.jpg'}`;
};

export const getGoogleMapsUrl = (address) => {
    return `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(address)}`;
};