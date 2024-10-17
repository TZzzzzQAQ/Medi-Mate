package com.friedchicken.pojo.dto.User;

import lombok.Builder;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

@Data
@Builder
public class UserLoginDTO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    private String email;
    private String password;
}
