package com.friedchicken.service;

import com.friedchicken.pojo.dto.Medicine.MedicineLocationDTO;
import com.friedchicken.pojo.dto.Medicine.MedicineModifyDTO;
import com.friedchicken.pojo.dto.Medicine.MedicinePageDTO;
import com.friedchicken.pojo.vo.Medicine.ManufactureNameListVO;
import com.friedchicken.pojo.vo.Medicine.MedicineDetailVO;
import com.friedchicken.pojo.vo.Medicine.MedicineListVO;
import com.friedchicken.pojo.vo.Medicine.MedicineLocationVO;
import com.friedchicken.result.PageResult;

public interface ProductService {

    PageResult<MedicineListVO> getProductsByName(MedicinePageDTO medicinePageDTO);

    MedicineDetailVO getProductById(String productId);

    PageResult<MedicineDetailVO> getDetailProductsByName(MedicinePageDTO medicinePageDTO);

    void updateProductInformation(MedicineModifyDTO medicineModifyDTO);

    ManufactureNameListVO getAllManufactureName();

    MedicineLocationVO getProductLocation(MedicineLocationDTO medicineLocationDTO);
}
