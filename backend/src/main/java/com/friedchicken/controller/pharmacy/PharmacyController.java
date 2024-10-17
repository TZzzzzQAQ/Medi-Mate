package com.friedchicken.controller.pharmacy;

import com.friedchicken.pojo.entity.Pharmacy.Pharmacy;
import com.friedchicken.pojo.vo.Pharmacy.PharmacyInfoVO;
import com.friedchicken.result.Result;
import com.friedchicken.service.PharmacyService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/pharmacy")
@Slf4j
public class PharmacyController {

    @Autowired
    private PharmacyService pharmacyService;

    @GetMapping("/detailPharmacy")
    @Operation(summary = "Get All pharmacy.",
            description = "Retrieve a list of pharmacy.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Pharmacy retrieved successfully.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = Pharmacy.class)))
    })
    public Result<List<PharmacyInfoVO>> getAllPharmacy() {
        log.info("Some where want to get all pharmacy.");

        List<PharmacyInfoVO> pharmacyInfoVOList = pharmacyService.getAllPharmacy();

        return Result.success(pharmacyInfoVOList);
    }

}
