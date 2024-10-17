package com.friedchicken.service.exception;

public class NoQuantityException extends IllegalArgumentException {
    public NoQuantityException(String message) {
        super(message);
    }
}
