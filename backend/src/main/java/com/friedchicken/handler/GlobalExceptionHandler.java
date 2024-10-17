package com.friedchicken.handler;

import com.friedchicken.controller.AI.exception.ImageFailedUploadException;
import com.friedchicken.exception.InvalidInputException;
import com.friedchicken.exception.LoginException;
import com.friedchicken.result.Result;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Result<?>> handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((org.springframework.validation.FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        return new ResponseEntity<>(Result.error(errors.toString()), HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(LoginException.class)
    public ResponseEntity<Result<?>> handleSpecificException(LoginException ex) {
        return new ResponseEntity<>(Result.error(ex.getMessage()), HttpStatus.UNAUTHORIZED);
    }

    @ExceptionHandler(ImageFailedUploadException.class)
    public ResponseEntity<Result<?>> handleSpecificException(ImageFailedUploadException ex) {
        return new ResponseEntity<>(Result.error(ex.getMessage()), HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(NullPointerException.class)
    public ResponseEntity<Result<?>> handleNullPointerException(NullPointerException ex) {
        log.error("Null Pointer Exception occurred: {}", ex.getMessage());
        return new ResponseEntity<>(Result.error("An unexpected error occurred. Please try again later."), HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<Result<?>> handleIllegalArgumentException(IllegalArgumentException ex) {
        log.error("Illegal Argument Exception occurred: {}", ex.getMessage());
        return new ResponseEntity<>(Result.error("Invalid argument: " + ex.getMessage()), HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(org.apache.ibatis.reflection.ReflectionException.class)
    public ResponseEntity<Result<?>> handleReflectionException(org.apache.ibatis.reflection.ReflectionException ex) {
        log.error("Reflection Exception occurred in MyBatis: {}", ex.getMessage());
        return new ResponseEntity<>(Result.error("An error occurred while processing your request. Please check your input or try again later."), HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Result<?>> handleGenericException(Exception ex) {
        log.error("An unexpected error occurred: {}", ex.getMessage(), ex);
        return new ResponseEntity<>(Result.error("An unexpected error occurred. Please try again later."), HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @ExceptionHandler(InvalidInputException.class)
    public ResponseEntity<Result<?>> handleInvalidInputException(InvalidInputException ex) {
        log.error("Invalid input: {}", ex.getMessage());
        return new ResponseEntity<>(Result.error(ex.getMessage()), HttpStatus.BAD_REQUEST);
    }

}
