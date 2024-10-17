package com.friedchicken.aspect;

import com.friedchicken.annotation.AutoFillDateTime;
import com.friedchicken.constant.AutoFillConstant;
import com.friedchicken.enumeration.OperationType;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;

import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;

import java.lang.reflect.Method;
import java.time.LocalDateTime;

@Aspect
@Component
@Slf4j
public class DateTimeAspect {

    @Pointcut("@annotation(com.friedchicken.annotation.AutoFillDateTime)")
    public void annotateMethod() {
    }


    @Before("annotateMethod()")
    public void autoFill(JoinPoint joinPoint) {
        log.info("Start autoFill");
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        AutoFillDateTime autoFill = signature.getMethod().getAnnotation(AutoFillDateTime.class);
        OperationType type = autoFill.value();

        Object[] args = joinPoint.getArgs();
        if (args == null || args.length == 0) {
            return;
        }
        Object entity = args[0];

        if (type == OperationType.UPDATE) {
            try {
                Method setUpdateTime = entity.getClass().getDeclaredMethod(AutoFillConstant.SET_UPDATED_AT, LocalDateTime.class);

                setUpdateTime.invoke(entity, LocalDateTime.now());
            } catch (Exception e) {
                throw new RuntimeException(e);
            }

        } else if (type == OperationType.INSERT) {
            try {
                Method setUpdateTime = entity.getClass().getDeclaredMethod(AutoFillConstant.SET_CREATED_AT, LocalDateTime.class);
                Method setCreateTime = entity.getClass().getDeclaredMethod(AutoFillConstant.SET_UPDATED_AT, LocalDateTime.class);

                setCreateTime.invoke(entity, LocalDateTime.now());
                setUpdateTime.invoke(entity, LocalDateTime.now());
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }
    }
}