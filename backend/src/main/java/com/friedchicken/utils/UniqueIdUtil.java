package com.friedchicken.utils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.IdGenerator;

@Component
public class UniqueIdUtil {

    private final IdGenerator idGenerator;

    @Autowired
    public UniqueIdUtil(IdGenerator idGenerator) {
        this.idGenerator = idGenerator;
    }

    public String generateUniqueId() {
        return idGenerator.generateId().toString();
    }
}

