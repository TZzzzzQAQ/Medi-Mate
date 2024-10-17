package com.friedchicken.result;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PageResult<T> implements Serializable {

    private long total; // 总记录数

    private List<T> records; // 当前页数据集合

}