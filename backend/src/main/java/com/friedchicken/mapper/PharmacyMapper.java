package com.friedchicken.mapper;

import com.friedchicken.pojo.vo.Pharmacy.PharmacyInfoVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface PharmacyMapper {
    List<PharmacyInfoVO> getAllPharmacy();
}
