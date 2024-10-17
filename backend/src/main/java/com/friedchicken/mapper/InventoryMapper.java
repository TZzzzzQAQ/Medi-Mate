package com.friedchicken.mapper;

import com.friedchicken.pojo.dto.Inventory.DetailInventoryDTO;
import com.friedchicken.pojo.vo.Inventory.DetailInventoryVO;
import com.github.pagehelper.Page;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface InventoryMapper {

    Page<DetailInventoryVO> getInventoryFromPharmacyId(DetailInventoryDTO detailInventoryDTO);
}
