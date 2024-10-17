package com.friedchicken.pojo.dto.AI;

import jakarta.validation.constraints.NotBlank;
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
public class AItextDTO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    @NotBlank
    private String message;
}
