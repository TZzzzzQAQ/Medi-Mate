package com.friedchicken.controller.product;

import com.friedchicken.pojo.dto.Medicine.MedicineLocationDTO;
import com.friedchicken.pojo.dto.Medicine.MedicineModifyDTO;
import com.friedchicken.pojo.dto.Medicine.MedicinePageDTO;
import com.friedchicken.pojo.vo.Medicine.ManufactureNameListVO;
import com.friedchicken.pojo.vo.Medicine.MedicineDetailVO;
import com.friedchicken.pojo.vo.Medicine.MedicineListVO;
import com.friedchicken.pojo.vo.Medicine.MedicineLocationVO;
import com.friedchicken.result.PageResult;
import com.friedchicken.result.Result;
import com.friedchicken.service.ProductService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/products")
@Tag(name = "Product", description = "API for User to get products.")
@Slf4j
public class ProductController {

    @Autowired
    private ProductService productService;

    @GetMapping
    @Operation(summary = "Get Products list",
            description = "Retrieve a list of products with pagination and optional filtering by name, ID, or manufacture.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Products retrieved successfully.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = PageResult.class)))
    })
    public Result<PageResult<MedicineListVO>> getProducts(MedicinePageDTO medicinePageDTO) {

        log.info("User want to retrieve products by product name:{}", medicinePageDTO.getProductName());

        PageResult<MedicineListVO> pageResult = productService.getProductsByName(medicinePageDTO);

        return Result.success(pageResult);
    }

    @GetMapping("/productDetail")
    @Operation(summary = "Get Detail Products",
            description = "Retrieve a specific product.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Product retrieved successfully.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = MedicineDetailVO.class)))
    })
    public Result<MedicineDetailVO> getProduct(@RequestParam("productId") String productId) {
        log.info("User want to retrieve the specific product by product id:{}", productId);

        MedicineDetailVO medicineDetailVO = productService.getProductById(productId);

        return Result.success(medicineDetailVO);
    }

    @GetMapping("/allProductsDetail")
    @Operation(summary = "Get All Products list",
            description = "Retrieve a list of products with pagination and optional filtering by name, ID, or manufacture.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Products retrieved successfully.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = PageResult.class)))
    })
    public Result<PageResult<MedicineDetailVO>> getDetailProducts(MedicinePageDTO medicinePageDTO) {

        log.info("User want to retrieve products by product name or manufacturer name:{}", medicinePageDTO);

        PageResult<MedicineDetailVO> pageResult = productService.getDetailProductsByName(medicinePageDTO);

        return Result.success(pageResult);
    }

    @PutMapping("/changeProducts")
    @Operation(summary = "Modify products information.",
            description = "Modify products information.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Products modify successfully.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = MedicineDetailVO.class)))
    })
    public Result<MedicineDetailVO> changeProducts(@RequestBody MedicineModifyDTO medicineModifyDTO) {
        log.info("User want to change products information.{}", medicineModifyDTO);

        productService.updateProductInformation(medicineModifyDTO);

        return Result.success();
    }

    @GetMapping("/manufactureName")
    @Operation(summary = "Get all manufacture.",
            description = "Get all manufacture.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully get all manufacture name.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = ManufactureNameListVO.class)))
    })
    public Result<ManufactureNameListVO> getAllManufacture() {
        log.info("User want to get all manufacture name.");

        return Result.success(productService.getAllManufactureName());
    }

    @PostMapping("/productLocation")
    @Operation(summary = "Get a product's location.",
            description = "Get a product's detail location by product id and pharmacy id.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully get the detail location.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = MedicineLocationVO.class)))
    })
    public Result<MedicineLocationVO> getProductLocation(@RequestBody MedicineLocationDTO medicineLocationDTO) {
        log.info("User wants to get the product location.{}", medicineLocationDTO);

        MedicineLocationVO medicineLocationVO = productService.getProductLocation(medicineLocationDTO);

        return Result.success(medicineLocationVO);
    }
}
