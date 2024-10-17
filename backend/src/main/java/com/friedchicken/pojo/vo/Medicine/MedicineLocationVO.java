package com.friedchicken.pojo.vo.Medicine;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MedicineLocationVO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    private String pharmacyName;
    private int stockQuantity;
    private String shelfNumber;
    private int shelfLevel;
}
