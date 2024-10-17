package com.friedchicken.pojo.vo.AI;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.friedchicken.pojo.vo.Medicine.MedicineComparisonVO;
import lombok.Data;

import java.io.Serializable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class ComparisonRequest implements Serializable {
    private List<MedicineComparisonVO>  comparisons;
}
