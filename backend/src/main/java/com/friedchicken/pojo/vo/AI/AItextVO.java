package com.friedchicken.pojo.vo.AI;

import lombok.Builder;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

@Data
@Builder
public class AItextVO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    private String text;
}
