package com.friedchicken.pojo.dto.User;

import lombok.Builder;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

@Data
@Builder
public class UserInfoChangeDTO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    private String userId;
    private int birthYear;
    private double userWeight;
    private double userHeight;
}
