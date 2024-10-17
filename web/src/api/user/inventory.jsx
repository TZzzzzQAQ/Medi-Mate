import { requestInventory } from "@/axios/requestInventory";

export function getInventoryAPI(pharmacyId, page, pageSize,productName) {
    return requestInventory({
        method: 'POST',
        data: {
            pharmacyId,
            page,
            pageSize,
            productName
        }
    });
}