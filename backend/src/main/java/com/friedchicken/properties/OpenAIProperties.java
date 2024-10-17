package com.friedchicken.properties;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@ConfigurationProperties(prefix = "spring.ai.openai")
@Data
public class OpenAIProperties {
    private String apiKey;
    private String url = "https://api.openai.com";
    private String model = "gpt-4o-mini";
    private Float temperature = 0.7F;
    private String jsonSchemaForKeywords = """
            {
                "type": "object",
                "properties": {
                    "name": {
                        "type": "string",
                        "description": "The main name of the product. Including the brand. If you cannot identify any drug, return an empty name. "
                    }
                },
                "required": ["name"],
                "additionalProperties": false
            }
            """;
    private String jsonSchemaForSummary = """
            {
                "type": "object",
                "properties": {
                    "summary": {
                        "type": "string",
                        "description": "A brief summary of the information from a professional pharmacist."
                    }
                },
                "required": ["summary"],
                "additionalProperties": false
            }
            """;
    private String jsonSchemaForAnalyse = """
            {
                "type": "object",
                "properties": {
                    "name": {
                        "type": "string",
                        "description": "The name of the product"
                    },
                    "description": {
                        "type": "string",
                        "description": "The general description of the product"
                    },
                    "commonUse": {
                        "type": "string",
                        "description": "The common use of the product"
                    },
                    "sideEffects": {
                        "type": "string",
                        "description": "The side effect of the product"
                    }
                },
                "required": ["name", "description", "commonUse", "sideEffects"],
                "additionalProperties": false
            }
            """;
    private String jsonSchemaForComparison = """
            {
               "type":"object",
               "properties":{
                  "comparisonRequest":{
                     "type":"object",
                     "properties":{
                        "comparisons":{
                           "type":"array",
                           "items":{
                              "type":"object",
                              "properties":{
                                 "productId": {
                                    "type": "string",
                                    "description": "The product ID of the product which is unique for each product. Just return the original one."
                                    },
                                 "productName": {
                                    "type": "string",
                                    "description": "The name of the product. Just return the original one."
                                    },
                                 "warnings": {
                                    "type": "string",
                                    "description": "The warnings of the product. Just return the original one."
                                    },
                                 "commonUse": {
                                    "type": "string",
                                    "description": "Different common use from other products provided to you."
                                    },
                                 "imageSrc": {
                                    "type": "string",
                                    "description": "The image of the product. Just return the original one."
                                    },
                                 "difference": {
                                    "type": "string",
                                    "description": "The difference of the product."
                                     },
                                 "productPrice": {
                                    "type": "string",
                                    "description": "The price of the product."
                                     }
                              },
                              "required":[
                                 "productId",
                                 "commonUse",
                                 "warnings",
                                 "productName",
                                 "imageSrc",
                                 "difference",
                                 "productPrice"
                              ],
                              "additionalProperties": false
                           }
                        },
                        "comparisonCriteria":{
                           "type":"array",
                           "items":{
                              "type":"string",
                              "enum":[
                                 "generalInformation",
                                 "warnings",
                                 "commonUse",
                                 "ingredients",
                                 "directions"
                              ],
                              "description":"Criteria to be used for comparison"
                           }
                        }
                     },
                     "required":[
                        "comparisons",
                        "comparisonCriteria"
                     ],
                     "additionalProperties": false
                  }
               },
               "required": ["comparisonRequest"],
                "additionalProperties": false
            }
            """;
//    private String jsonSchemaForComparison = """
//            {
//               "type":"object",
//               "properties":{
//                  "comparisonRequest":{
//                     "type":"object",
//                     "properties":{
//                        "comparisons":{
//                           "type":"array",
//                           "items":{
//                              "type":"object",
//                              "properties":{
//                                 "productId": {
//                                    "type": "string",
//                                    "description": "The product ID of the product which is unique for each product. Just return the original one."
//                                    },
//                                 "productName": {
//                                    "type": "string",
//                                    "description": "The name of the product. Just return the original one."
//                                    },
//                                 "generalInformation": {
//                                    "type": "string",
//                                    "description": "Different general Information from other products provided to you."
//                                    },
//                                 "warnings": {
//                                    "type": "string",
//                                    "description": "The warnings of the product. Just return the original one."
//                                    },
//                                 "commonUse": {
//                                    "type": "string",
//                                    "description": "Different common use from other products provided to you."
//                                    },
//                                 "ingredients": {
//                                    "type": "string",
//                                    "description": "Different ingredients from other products provided to you."
//                                    },
//                                 "directions": {
//                                    "type": "string",
//                                    "description": "The directions of the product. Just return the original one."
//                                    },
//                                 "imageSrc": {
//                                    "type": "string",
//                                    "description": "The image of the product. Just return the original one."
//                                    }
//                              },
//                              "required":[
//                                 "productId",
//                                 "generalInformation",
//                                 "commonUse",
//                                 "ingredients",
//                                 "directions",
//                                 "warnings",
//                                 "productName",
//                                 "imageSrc"
//                              ],
//                              "additionalProperties": false
//                           }
//                        },
//                        "comparisonCriteria":{
//                           "type":"array",
//                           "items":{
//                              "type":"string",
//                              "enum":[
//                                 "generalInformation",
//                                 "warnings",
//                                 "commonUse",
//                                 "ingredients",
//                                 "directions"
//                              ],
//                              "description":"Criteria to be used for comparison"
//                           }
//                        }
//                     },
//                     "required":[
//                        "comparisons",
//                        "comparisonCriteria"
//                     ],
//                     "additionalProperties": false
//                  }
//               },
//               "required": ["comparisonRequest"],
//                "additionalProperties": false
//            }
//            """;
}
