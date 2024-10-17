package com.friedchicken.service.exception;

public class NoProductException extends IllegalArgumentException {
    public NoProductException(String message) {
        super(message);
    }
}
