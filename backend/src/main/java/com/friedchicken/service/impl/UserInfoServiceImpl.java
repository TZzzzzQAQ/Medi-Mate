package com.friedchicken.service.impl;

import com.friedchicken.mapper.UserInfoMapper;
import com.friedchicken.pojo.dto.User.UserInfoChangeDTO;
import com.friedchicken.pojo.dto.User.UserInfoDTO;
import com.friedchicken.pojo.vo.User.UserInfoVO;
import com.friedchicken.service.UserInfoService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserInfoServiceImpl implements UserInfoService {

    private static final Logger log = LoggerFactory.getLogger(UserInfoServiceImpl.class);
    @Autowired
    private UserInfoMapper userInfoMapper;

    @Override
    public UserInfoVO getUserInfo(UserInfoDTO userInfoDTO) {
        return userInfoMapper.getUserByUserId(userInfoDTO.getUserId());
    }

    @Override
    public UserInfoVO changeUserInfo(UserInfoChangeDTO userInfoChangeDTO) {
        String userId = userInfoChangeDTO.getUserId();
        userInfoMapper.updateUserInfo(userInfoChangeDTO);
        return userInfoMapper.getUserByUserId(userInfoChangeDTO.getUserId());
    }

}
