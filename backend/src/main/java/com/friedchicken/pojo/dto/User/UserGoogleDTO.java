package com.friedchicken.pojo.dto.User;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserGoogleDTO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    @NotBlank(message = "Email is mandatory.")
    @Email(message = "Email should be valid.")
    private String email;

    @NotBlank(message = "GoogleId is mandatory.")
    private String googleId;

    @NotBlank(message = "Username is mandatory.")
    private String nickname;

    @NotBlank(message = "UserPic is mandatory.")
    private String userPic;
}
