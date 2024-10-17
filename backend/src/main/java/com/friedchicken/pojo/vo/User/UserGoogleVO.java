package com.friedchicken.pojo.vo.User;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UserGoogleVO implements Serializable {
    private String userId;
    private String email;
    private String googleId;
    private String username;
    private String nickname;
    private String userPic;
    private String token;
}
