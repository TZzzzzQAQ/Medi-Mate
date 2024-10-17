package com.friedchicken.service.exception;

public class NoCancelReasonException extends IllegalArgumentException {
    public NoCancelReasonException() {
    }

    public NoCancelReasonException(String message) {
        super(message);
    }
}
