package com.friedchicken.service;

import com.friedchicken.pojo.dto.User.*;
import com.friedchicken.pojo.vo.User.UserGoogleVO;
import com.friedchicken.pojo.vo.User.UserLoginVO;


public interface UserService {
    UserLoginVO login(UserLoginDTO userLoginDTO);

    void register(UserRegisterDTO userRegisterDTO);

    UserGoogleVO googleLogin(UserGoogleDTO userGoogleLoginDTO);

    void updatePassword(UserChangePasswordDTO userChangePasswordDTO);

    void updateNickname(UserChangeNickname userChangeNickname);
}
