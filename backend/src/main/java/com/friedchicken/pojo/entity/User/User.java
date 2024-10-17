package com.friedchicken.pojo.entity.User;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class User implements Serializable {
    private String userId;
    private String username;
    private String email;
    private String password;
    private String googleId;
    private String nickname;
    private String userPic;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
