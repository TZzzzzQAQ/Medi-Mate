package com.friedchicken.pojo.vo.AI;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

@Data
public class AIcomparisonVO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    private ComparisonRequest comparisonRequest;
}

