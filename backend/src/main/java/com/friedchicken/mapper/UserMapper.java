package com.friedchicken.mapper;

import com.friedchicken.annotation.AutoFillDateTime;
import com.friedchicken.enumeration.OperationType;
import com.friedchicken.pojo.entity.User.User;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface UserMapper {

    @Select("select * from user where email = #{email}")
    User getUserByEmail(String email);

    @AutoFillDateTime(OperationType.INSERT)
    void register(User user);

    void update(User user);

    void addUserInfo(User user);

    @Select("select * from user where user_id = #{userId};")
    User getUserByUserId(String userId);
}
