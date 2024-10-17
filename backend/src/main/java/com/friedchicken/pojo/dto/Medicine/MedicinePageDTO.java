package com.friedchicken.pojo.dto.Medicine;

import lombok.Builder;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

@Data
@Builder
public class MedicinePageDTO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    private int page = 1;
    private int pageSize = 10;
    private String productName;
    private String manufacturerName;
}
