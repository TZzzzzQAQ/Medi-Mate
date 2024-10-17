package com.friedchicken.pojo.dto.AI;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;
import java.net.URL;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AIimageDTO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    @NotBlank
    private URL url;
}
