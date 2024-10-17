package com.friedchicken.pojo.dto.User;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Builder;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

@Data
@Builder
public class UserRegisterDTO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    @NotBlank(message = "Email is mandatory.")
    @Email(message = "Email should be valid.")
    private String email;

    @NotBlank(message = "Password is mandatory.")
    @Size(min = 10,max = 100,message = "Password must be between 10 and 100 characters")
    private String password;
}
