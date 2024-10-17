package com.friedchicken.pojo.vo.User;

import lombok.Builder;
import lombok.Data;

import java.io.Serializable;

@Data
@Builder
public class UserInfoVO implements Serializable {
    private String userId;
    private int birthYear;
    private double userWeight;
    private double userHeight;
}
