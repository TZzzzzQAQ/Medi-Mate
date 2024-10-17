package com.friedchicken.service;

import com.friedchicken.pojo.dto.AI.AICompareDTO;
import com.friedchicken.pojo.dto.AI.AIimageDTO;
import com.friedchicken.pojo.vo.AI.AIcomparisonVO;
import com.friedchicken.pojo.vo.AI.AItextVO;
import com.friedchicken.pojo.vo.Medicine.MedicineListVO;
import com.friedchicken.result.PageResult;

public interface AiService {
    AItextVO handlerText(String message);

    AItextVO analyzeImageUrl(AIimageDTO aiimageDTO);

    PageResult<MedicineListVO> analyzeImage(byte[] imageData);

    AIcomparisonVO compareImage(AICompareDTO aiCompareDTO);
}
