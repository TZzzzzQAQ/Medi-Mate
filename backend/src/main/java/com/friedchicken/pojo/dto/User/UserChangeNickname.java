package com.friedchicken.pojo.dto.User;

import java.io.Serial;
import java.io.Serializable;

public class UserChangeNickname implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    private String nickname;
    private String userId;
}
