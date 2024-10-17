package com.friedchicken.service.impl;

import com.friedchicken.mapper.PharmacyMapper;
import com.friedchicken.pojo.vo.Pharmacy.PharmacyInfoVO;
import com.friedchicken.service.PharmacyService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
public class PharmacyServiceImpl implements PharmacyService {

    @Autowired
    private PharmacyMapper pharmacyMapper;

    @Override
    public List<PharmacyInfoVO> getAllPharmacy() {

        return pharmacyMapper.getAllPharmacy();
    }
}
