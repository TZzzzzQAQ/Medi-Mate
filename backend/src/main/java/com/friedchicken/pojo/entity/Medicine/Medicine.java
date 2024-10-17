package com.friedchicken.pojo.entity.Medicine;

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
public class Medicine implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    private String productId;
    private String productName;
    private String productPrice;
    private String manufacturerName;
    private String generalInformation;
    private String warnings;
    private String commonUse;
    private String ingredients;
    private String directions;
    private String imageSrc;
    private String summary;
}
