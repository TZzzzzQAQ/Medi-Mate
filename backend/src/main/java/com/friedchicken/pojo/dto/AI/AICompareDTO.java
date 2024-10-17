package com.friedchicken.pojo.dto.AI;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AICompareDTO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    private String[] productId;
}
