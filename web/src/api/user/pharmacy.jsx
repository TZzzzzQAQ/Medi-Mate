import { requestPharmacy } from "@/axios/requestPharmacy.jsx";

export function getPharmaciesAPI() {
    return requestPharmacy({
        method: 'GET',
        url: "/detailPharmacy"
    });
}

