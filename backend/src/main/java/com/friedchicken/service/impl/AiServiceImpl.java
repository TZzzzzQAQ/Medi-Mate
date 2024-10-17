package com.friedchicken.service.impl;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.friedchicken.constant.MessageConstant;
import com.friedchicken.controller.AI.exception.UnrecognizedMedicineException;
import com.friedchicken.mapper.AiInfoMapper;
import com.friedchicken.pojo.dto.AI.AICompareDTO;
import com.friedchicken.pojo.dto.AI.AIimageDTO;
import com.friedchicken.pojo.entity.Medicine.Medicine;
import com.friedchicken.pojo.entity.Medicine.MedicineInfo;
import com.friedchicken.pojo.vo.AI.AIcomparisonVO;
import com.friedchicken.pojo.vo.AI.AItextVO;
import com.friedchicken.pojo.vo.Medicine.MedicineListVO;
import com.friedchicken.properties.OpenAIProperties;
import com.friedchicken.result.PageResult;
import com.friedchicken.service.AiService;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.ai.model.Media;
import org.springframework.ai.openai.OpenAiChatModel;
import org.springframework.ai.openai.OpenAiChatOptions;
import org.springframework.ai.openai.api.OpenAiApi;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.util.MimeTypeUtils;

import java.util.Arrays;
import java.util.List;
import java.util.concurrent.TimeUnit;

@Slf4j
@Service
public class AiServiceImpl implements AiService {

    @Autowired
    private OpenAIProperties openAIProperties;
    @Autowired
    private AiInfoMapper aiInfoMapper;
    @Autowired
    private RedisTemplate<String, PageResult<MedicineListVO>> redisTemplate;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public AItextVO handlerText(String message) {
        UserMessage userMessage = new UserMessage(message);

        ChatResponse chatResponse = getAiClass(userMessage, openAIProperties.getJsonSchemaForSummary());
        String requestContent = chatResponse.getResults().get(0).getOutput().getContent();
        String summary;
        try {
            JsonNode jsonNode = objectMapper.readTree(requestContent);
            summary = jsonNode.get("summary").asText();
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
        return AItextVO.builder()
                .text(summary)
                .build();
    }

    @Override
    public AItextVO analyzeImageUrl(AIimageDTO aiimageDTO) {
        UserMessage userMessage = new UserMessage(
                "Tell my the text on this picture. Please be more specific and comprehensive according to the description."
                , List.of(new Media(MimeTypeUtils.IMAGE_JPEG, aiimageDTO.getUrl())));

        ChatResponse chatResponse = getAiClass(userMessage, openAIProperties.getJsonSchemaForAnalyse());
        String requestContent = chatResponse.getResults().get(0).getOutput().getContent();

        return AItextVO.builder()
                .text(requestContent)
                .build();
    }

    @Override
    public PageResult<MedicineListVO> analyzeImage(byte[] imageData) {
        Resource imageResource = new ByteArrayResource(imageData);

        UserMessage userMessage = new UserMessage(
                "Tell me the main name of this medicine."
                , List.of(new Media(MimeTypeUtils.IMAGE_PNG, imageResource)));

        ChatResponse chatResponse = getAiClass(userMessage, openAIProperties.getJsonSchemaForKeywords());
        String requestContent = chatResponse.getResults().get(0).getOutput().getContent();

        MedicineInfo medicineInfo;
        try {
            medicineInfo = objectMapper.readValue(requestContent, MedicineInfo.class);
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
        String name = medicineInfo.getName();

        if (name == null || name.isEmpty()) {
            throw new UnrecognizedMedicineException(MessageConstant.UNRECOGNIZED_MEDICINE);
        }

        List<String> keywords = Arrays.asList(name.split("\\s+"));

        String cacheKey = "medicine_search:" + String.join("_", keywords);

        PageResult<MedicineListVO> cachedResult = redisTemplate.opsForValue().get(cacheKey);

        if (cachedResult == null) {
            PageHelper.startPage(1, 100);
            Page<MedicineListVO> page = aiInfoMapper.findByMultipleWords(name);

            cachedResult = new PageResult<>(page.getTotal(), page.getResult());

            redisTemplate.opsForValue().set(cacheKey, cachedResult, 10, TimeUnit.MINUTES);
        }

        return cachedResult;
    }

    @Override
    public AIcomparisonVO compareImage(AICompareDTO aiCompareDTO) {
        List<Medicine> medicineList = aiInfoMapper.findProductByIds(Arrays.stream(aiCompareDTO.getProductId()).toList());

        UserMessage userMessage = new UserMessage(
                "You are a professional pharmacist. I will give you a set of drug information, please summarize briefly the differences between them.The information returned is mainly the differences."
                        + medicineList.toString());

        ChatResponse chatResponse = getAiClass(userMessage, openAIProperties.getJsonSchemaForComparison());
        String requestContent = chatResponse.getResults().get(0).getOutput().getContent();
        AIcomparisonVO aicomparisonVO = new AIcomparisonVO();
        try {
            aicomparisonVO = objectMapper.readValue(requestContent, AIcomparisonVO.class);
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }

        return aicomparisonVO;
    }

    private ChatResponse getAiClass(UserMessage userMessage, String format) {
        OpenAiApi openAiApi = new OpenAiApi(openAIProperties.getApiKey());
        OpenAiChatOptions openAiChatOptions = OpenAiChatOptions.builder()
                .withModel(openAIProperties.getModel())
                .withTemperature(openAIProperties.getTemperature())
                .withMaxTokens(10000)
                .withResponseFormat(new OpenAiApi.ChatCompletionRequest.ResponseFormat(
                        OpenAiApi.ChatCompletionRequest.ResponseFormat.Type.JSON_SCHEMA, format))
                .build();
        OpenAiChatModel openAiChatModel = new OpenAiChatModel(openAiApi, openAiChatOptions);

        return openAiChatModel.call(new Prompt(userMessage));
    }
}
