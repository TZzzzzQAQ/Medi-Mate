package com.friedchicken.controller.user.exception;

import com.friedchicken.exception.LoginException;

/**
 * 密码错误异常
 */
public class PasswordErrorException extends LoginException {

    public PasswordErrorException() {
    }

    public PasswordErrorException(String msg) {
        super(msg);
    }

}
