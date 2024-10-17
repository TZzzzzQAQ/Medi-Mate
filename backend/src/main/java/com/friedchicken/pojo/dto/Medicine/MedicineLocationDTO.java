package com.friedchicken.pojo.dto.Medicine;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MedicineLocationDTO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    private String productId;
    private int pharmacyId;
}
