package com.friedchicken.controller.inventory;

import com.friedchicken.pojo.dto.Inventory.DetailInventoryDTO;
import com.friedchicken.pojo.vo.Inventory.DetailInventoryVO;
import com.friedchicken.result.PageResult;
import com.friedchicken.result.Result;
import com.friedchicken.service.InventoryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/inventory")
@Tag(name = "Inventory", description = "API for Staff to get inventory corresponding results.")
@Slf4j
public class InventoryController {

    @Autowired
    private InventoryService inventoryService;

    @PostMapping("/detailInventory")
    @Operation(summary = "Get one pharmacy's inventory.",
            description = "Get one pharmacy's inventory.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Retrieved one pharmacy's inventory successfully.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = PageResult.class)))
    })
    public Result<PageResult<DetailInventoryVO>> getOnePharmacy(@RequestBody DetailInventoryDTO detailInventoryDTO) {
        log.info("Staff want to get one pharmacy's inventory.{}", detailInventoryDTO);

        PageResult<DetailInventoryVO> detailInventoryVOPageResult = inventoryService.getOnePharmacy(detailInventoryDTO);

        return Result.success(detailInventoryVOPageResult);
    }
}
