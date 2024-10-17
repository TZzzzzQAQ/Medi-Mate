package com.friedchicken.pojo.dto.User;

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
public class UserChangePasswordDTO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    private String email;
    private String oldPassword;
    private String newPassword;
    private String nickname;
}
