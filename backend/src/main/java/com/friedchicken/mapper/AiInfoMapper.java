package com.friedchicken.mapper;

import com.friedchicken.pojo.entity.Medicine.Medicine;
import com.friedchicken.pojo.vo.Medicine.MedicineListVO;
import com.github.pagehelper.Page;
import org.apache.ibatis.annotations.Mapper;


import java.util.List;

@Mapper
public interface AiInfoMapper {

    Page<MedicineListVO> findByMultipleWords(String name);

    List<Medicine> findProductByIds(List<String> productId);
}
