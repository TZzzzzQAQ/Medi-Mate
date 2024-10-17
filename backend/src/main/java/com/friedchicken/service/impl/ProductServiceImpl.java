package com.friedchicken.service.impl;

import com.friedchicken.mapper.ProductMapper;
import com.friedchicken.pojo.dto.Medicine.MedicineLocationDTO;
import com.friedchicken.pojo.dto.Medicine.MedicineModifyDTO;
import com.friedchicken.pojo.dto.Medicine.MedicinePageDTO;
import com.friedchicken.pojo.vo.Medicine.ManufactureNameListVO;
import com.friedchicken.pojo.vo.Medicine.MedicineDetailVO;
import com.friedchicken.pojo.vo.Medicine.MedicineListVO;
import com.friedchicken.pojo.vo.Medicine.MedicineLocationVO;
import com.friedchicken.result.PageResult;
import com.friedchicken.service.ProductService;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.concurrent.TimeUnit;


@Service
@Slf4j
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductMapper productMapper;
    @Autowired
    private AiServiceImpl aiServiceImpl;
    @Autowired
    private RedisTemplate<String, PageResult<MedicineListVO>> pageResultRedisTemplate;
    @Autowired
    private RedisTemplate<String, MedicineDetailVO> medicineDetailRedisTemplate;

    @Override
    public PageResult<MedicineListVO> getProductsByName(MedicinePageDTO medicinePageDTO) {
        String cacheKey = medicinePageDTO.toString();
        PageResult<MedicineListVO> cachedResult = pageResultRedisTemplate.opsForValue().get(cacheKey);

        if (cachedResult == null) {
            PageHelper.startPage(medicinePageDTO.getPage(), medicinePageDTO.getPageSize());
            Page<MedicineListVO> page = productMapper.getProducts(medicinePageDTO);

            cachedResult = new PageResult<>(page.getTotal(), page.getResult());

            pageResultRedisTemplate.opsForValue().set(cacheKey, cachedResult, 10, TimeUnit.MINUTES);
        }

        return cachedResult;
    }

    @Override
    @Transactional
    public MedicineDetailVO getProductById(String productId) {
        MedicineDetailVO productInRedis = medicineDetailRedisTemplate.opsForValue().get(productId);
        if (productInRedis != null) {
            return productInRedis;
        }
        MedicineDetailVO productById = productMapper.getProductById(productId);
        if (productById.getSummary() == null) {
            String text = aiServiceImpl.handlerText("You are a professional pharmacist, give me a brief summary."
                    + productById.toString()).getText();
            productById.setSummary(text);
            productMapper.updateProductById(productById);
        }
        medicineDetailRedisTemplate.opsForValue().set(productId, productById, 10, TimeUnit.MINUTES);
        return productById;
    }

    @Override
    public PageResult<MedicineDetailVO> getDetailProductsByName(MedicinePageDTO medicinePageDTO) {
        PageHelper.startPage(medicinePageDTO.getPage(), medicinePageDTO.getPageSize());
        Page<MedicineDetailVO> page = productMapper.getDetailProducts(medicinePageDTO);

        return new PageResult<>(page.getTotal(), page.getResult());
    }

    @Override
    public void updateProductInformation(MedicineModifyDTO medicineModifyDTO) {
        MedicineDetailVO medicineDetailVO = new MedicineDetailVO();
        BeanUtils.copyProperties(medicineModifyDTO, medicineDetailVO);
        productMapper.updateProductById(medicineDetailVO);
    }

    @Override
    public ManufactureNameListVO getAllManufactureName() {
        return ManufactureNameListVO.builder().manufacturerName(productMapper.getAllManufactureName()).build();
    }

    @Override
    public MedicineLocationVO getProductLocation(MedicineLocationDTO medicineLocationDTO) {
        return productMapper.getProductLocation(medicineLocationDTO);
    }
}
