package com.friedchicken.controller.user.exception;

import com.friedchicken.exception.LoginException;

/**
 * 登录失败
 */
public class LoginFailedException extends LoginException {
    public LoginFailedException(String msg) {
        super(msg);
    }
}
