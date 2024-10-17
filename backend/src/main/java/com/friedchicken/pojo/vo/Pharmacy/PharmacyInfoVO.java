package com.friedchicken.pojo.vo.Pharmacy;

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
public class PharmacyInfoVO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    private String pharmacyId;
    private String pharmacyName;
    private String latitude;
    private String longitude;
    private String pharmacyAddress;
}
