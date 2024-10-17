package com.friedchicken.controller.user.exception;

import com.friedchicken.exception.LoginException;

public class RegisterFailedException extends LoginException {
    public RegisterFailedException(String msg) {
        super(msg);
    }
}
