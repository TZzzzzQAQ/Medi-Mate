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
public class UserLoginVO implements Serializable {
    private String userId;
    private String username;
    private String nickname;
    private String email;
    private String userPic;
    private String token;
}
