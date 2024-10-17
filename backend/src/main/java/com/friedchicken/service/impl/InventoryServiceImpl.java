package com.friedchicken.service.impl;

import com.friedchicken.mapper.InventoryMapper;
import com.friedchicken.pojo.dto.Inventory.DetailInventoryDTO;
import com.friedchicken.pojo.vo.Inventory.DetailInventoryVO;
import com.friedchicken.result.PageResult;
import com.friedchicken.service.InventoryService;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class InventoryServiceImpl implements InventoryService {

    @Autowired
    private InventoryMapper inventoryMapper;
//    @Autowired
//    private RedisTemplate<String, PageResult<DetailInventoryDTO>> redisTemplate;

    @Override
    public PageResult<DetailInventoryVO> getOnePharmacy(DetailInventoryDTO detailInventoryDTO) {

        PageHelper.startPage(detailInventoryDTO.getPage(), detailInventoryDTO.getPageSize());
        Page<DetailInventoryVO> page = inventoryMapper.getInventoryFromPharmacyId(detailInventoryDTO);

        return new PageResult<>(page.getTotal(), page.getResult());
    }
}
