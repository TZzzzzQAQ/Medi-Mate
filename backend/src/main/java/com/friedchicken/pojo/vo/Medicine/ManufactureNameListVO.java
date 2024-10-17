package com.friedchicken.pojo.vo.Medicine;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;
import java.util.List;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ManufactureNameListVO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    private List<String> manufacturerName;
}
