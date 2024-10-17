package com.friedchicken.controller.user;

import com.friedchicken.pojo.dto.User.UserInfoChangeDTO;
import com.friedchicken.pojo.vo.User.UserInfoVO;
import com.friedchicken.service.UserInfoService;
import com.friedchicken.result.Result;
import com.friedchicken.pojo.dto.User.UserInfoDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/userinfo")
@Tag(name = "User Info", description = "API for User information operations")
@Slf4j
public class UserInfoController {

    @Autowired
    private UserInfoService userInfoService;

    @GetMapping
    @Operation(summary = "Get User Info by User ID",
            description = "Retrieve user information by user ID.",
            security = @SecurityRequirement(name = "bearerAuth"))
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "User information retrieved successfully.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = UserInfoVO.class)))
    })
    public Result<UserInfoVO> getUserInfo(
            @Parameter(description = "UserInfoDTO", required = true) UserInfoDTO userInfoDTO) {

        log.info("Getting user information from userId: {}", userInfoDTO.getUserId());

        return Result.success(userInfoService.getUserInfo(userInfoDTO));
    }

    @PutMapping("/updateUserInfo")
    @Operation(summary = "Change User detail information.",
            description = "Change User detail information by user ID.",
            security = @SecurityRequirement(name = "bearerAuth"))
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "User information changed successfully.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = UserInfoVO.class)))
    })
    public Result<UserInfoVO> changeUserInfo(
            @Parameter(description = "UserInfoDTO", required = true)
            @Valid @RequestBody UserInfoChangeDTO userInfoChangeDTO
    ) {
        log.info("Changing userInfoVO information from userId: {}", userInfoChangeDTO.getUserId());

        UserInfoVO userInfoVO = userInfoService.changeUserInfo(userInfoChangeDTO);

        return Result.success(userInfoVO);
    }
}
