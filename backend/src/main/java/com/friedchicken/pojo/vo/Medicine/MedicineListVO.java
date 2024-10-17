package com.friedchicken.pojo.vo.Medicine;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class MedicineListVO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    private String productId;
    private String productName;
    private String productPrice;
    private String imageSrc;
}