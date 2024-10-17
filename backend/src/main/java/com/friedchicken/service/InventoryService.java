package com.friedchicken.service;

import com.friedchicken.pojo.dto.Inventory.DetailInventoryDTO;
import com.friedchicken.pojo.vo.Inventory.DetailInventoryVO;
import com.friedchicken.result.PageResult;

public interface InventoryService {
    PageResult<DetailInventoryVO> getOnePharmacy(DetailInventoryDTO detailInventoryDTO);
}
