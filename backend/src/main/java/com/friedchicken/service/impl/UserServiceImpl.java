package com.friedchicken.service.impl;

import com.friedchicken.constant.JwtClaimsConstant;
import com.friedchicken.constant.MessageConstant;
import com.friedchicken.controller.user.exception.AccountNotFoundException;
import com.friedchicken.controller.user.exception.PasswordErrorException;
import com.friedchicken.controller.user.exception.RegisterFailedException;
import com.friedchicken.mapper.UserMapper;
import com.friedchicken.pojo.dto.User.*;
import com.friedchicken.pojo.entity.User.User;
import com.friedchicken.pojo.vo.User.UserGoogleVO;
import com.friedchicken.pojo.vo.User.UserLoginVO;
import com.friedchicken.properties.JwtProperties;
import com.friedchicken.service.UserService;
import com.friedchicken.utils.BCryptUtil;
import com.friedchicken.utils.JwtUtil;
import com.friedchicken.utils.RandomStringUtil;
import com.friedchicken.utils.UniqueIdUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Service
@Slf4j
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private UniqueIdUtil uniqueIdUtil;
    @Autowired
    private JwtProperties jwtProperties;
    @Autowired
    private StringRedisTemplate stringRedisTemplate;

    public UserLoginVO login(UserLoginDTO userLoginDTO) {
        String email = userLoginDTO.getEmail();
        String password = userLoginDTO.getPassword();

        User userByEmail = userMapper.getUserByEmail(email);
        if (userByEmail == null) {
            throw new AccountNotFoundException(MessageConstant.ACCOUNT_NOT_FOUND);
        }
        if (!userByEmail.getPassword().equals(password)) {
            throw new PasswordErrorException(MessageConstant.PASSWORD_ERROR);
        }

        Map<String, Object> claims = new HashMap<>();
        String token = generateUserLoginVO(userByEmail, claims);

        UserLoginVO userLoginVO = new UserLoginVO();
        BeanUtils.copyProperties(userByEmail, userLoginVO);
        userLoginVO.setToken(token);

        return userLoginVO;
    }

    @Override
    @Transactional
    public UserGoogleVO googleLogin(UserGoogleDTO userGoogleLoginDTO) {
        String email = userGoogleLoginDTO.getEmail();
        String googleId = userGoogleLoginDTO.getGoogleId();

        User user = userMapper.getUserByEmail(email);

        if (user == null) {
            user = User.builder()
                    .userId(uniqueIdUtil.generateUniqueId())
                    .password(BCryptUtil.hashPassword(RandomStringUtil.generateRandomString(16)))
                    .username(RandomStringUtil.generateRandomString(6))
                    .nickname(userGoogleLoginDTO.getNickname())
                    .build();
            BeanUtils.copyProperties(userGoogleLoginDTO, user);
            userMapper.register(user);
            userMapper.addUserInfo(user);
        } else if (!user.getGoogleId().equals(googleId)) {
            throw new PasswordErrorException(MessageConstant.PASSWORD_ERROR);
        } else {
            user.setNickname(userGoogleLoginDTO.getNickname());
            userMapper.update(user);
        }
        Map<String, Object> claims = new HashMap<>();
        String token = generateUserLoginVO(user, claims);
        return UserGoogleVO.builder()
                .userId(user.getUserId())
                .email(user.getEmail())
                .googleId(userGoogleLoginDTO.getGoogleId())
                .userPic(userGoogleLoginDTO.getUserPic())
                .username(user.getUsername())
                .nickname(userGoogleLoginDTO.getNickname())
                .token(token)
                .build();
    }

    private String generateUserLoginVO(User user, Map<String, Object> claims) {
        claims.put(JwtClaimsConstant.USER_ID, user.getUserId());
        claims.put(JwtClaimsConstant.USERNAME, user.getUsername());
        String token = JwtUtil.genToken(claims, jwtProperties.getUserTtl(), jwtProperties.getUserSecretKey());
        stringRedisTemplate.opsForValue().set(token, token, 30, TimeUnit.DAYS);
        return token;
    }

    @Override
    @Transactional
    public void register(UserRegisterDTO userRegisterDTO) {
        String email = userRegisterDTO.getEmail();

        User userByEmail = userMapper.getUserByEmail(email);
        if (userByEmail != null) {
            throw new RegisterFailedException(MessageConstant.ACCOUNT_ALREADY_EXIST);
        } else {
            User user = new User();
            BeanUtils.copyProperties(userRegisterDTO, user);
            user.setUserId(uniqueIdUtil.generateUniqueId());
            user.setUsername(RandomStringUtil.generateRandomString(6));
            userMapper.register(user);
            userMapper.addUserInfo(user);
        }
    }

    @Override
    public void updatePassword(UserChangePasswordDTO userChangePasswordDTO) {
        String email = userChangePasswordDTO.getEmail();
        User userByEmail = userMapper.getUserByEmail(email);
        if (userByEmail == null) {
            throw new AccountNotFoundException(MessageConstant.ACCOUNT_NOT_FOUND);
        }
        if (!userByEmail.getPassword().equals(userChangePasswordDTO.getOldPassword())) {
            throw new PasswordErrorException(MessageConstant.PASSWORD_ERROR);
        }
        userByEmail.setPassword(userChangePasswordDTO.getNewPassword());
        userMapper.update(userByEmail);

    }

    @Override
    public void updateNickname(UserChangeNickname userChangeNickname) {
        User user = new User();
        BeanUtils.copyProperties(user, userChangeNickname);
        userMapper.update(user);
    }
}
