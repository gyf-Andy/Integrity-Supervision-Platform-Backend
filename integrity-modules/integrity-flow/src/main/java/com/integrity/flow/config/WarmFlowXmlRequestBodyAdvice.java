package com.integrity.flow.config;

import org.dromara.warm.flow.ui.dto.DefDto;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.MethodParameter;
import org.springframework.http.HttpInputMessage;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.RequestBodyAdvice;

import java.lang.reflect.Type;

/**
 * warm-flow save-xml / save-json 入参清洗。
 *
 * warm-flow 内部用 dom4j SAXReader 直接读取 xmlString.getBytes(UTF_8)，
 * 不处理 UTF-8 BOM(EF BB BF / U+FEFF) 与 prolog 之前的空白/换行，
 * 一旦前端传来带 BOM 或前导空白的 xml，就会报 "前言中不允许有内容"。
 *
 * 清洗规则：跳过开头的 BOM 与空白，直到遇到 '<' / '{' / '['。
 * 如果整个内容里根本没有合法起始字符(说明前端传的不是 xml/json)，
 * 则保留原值不处理 —— 让 warm-flow 自己报错，而不是被这里静默清空导致
 * "保存成功但什么都没改"。
 */
@RestControllerAdvice
public class WarmFlowXmlRequestBodyAdvice implements RequestBodyAdvice {

    private static final Logger log = LoggerFactory.getLogger(WarmFlowXmlRequestBodyAdvice.class);

    private static final char BOM = '\uFEFF';

    @Override
    public boolean supports(MethodParameter methodParameter, Type targetType,
                            Class<? extends HttpMessageConverter<?>> converterType) {
        return DefDto.class.isAssignableFrom(methodParameter.getParameterType());
    }

    @Override
    public HttpInputMessage beforeBodyRead(HttpInputMessage inputMessage, MethodParameter parameter,
                                           Type targetType, Class<? extends HttpMessageConverter<?>> converterType) {
        return inputMessage;
    }

    @Override
    public Object afterBodyRead(Object body, HttpInputMessage inputMessage, MethodParameter parameter,
                                Type targetType, Class<? extends HttpMessageConverter<?>> converterType) {
        if (body instanceof DefDto defDto) {
            String before = defDto.getXmlString();
            String after = clean(before);
            defDto.setXmlString(after);
            defDto.setJsonString(clean(defDto.getJsonString()));
            log.warn("save-xml 入参诊断: id={} xmlBeforeLen={} xmlAfterLen={}",
                    defDto.getId(),
                    before == null ? -1 : before.length(),
                    after == null ? -1 : after.length());
            log.warn("save-xml 入参诊断 cleanedXml: {}",
                    after == null ? "null" : (after.length() > 1000 ? after.substring(0, 1000) + "..." : after));
        }
        return body;
    }

    @Override
    public Object handleEmptyBody(Object body, HttpInputMessage inputMessage, MethodParameter parameter,
                                  Type targetType, Class<? extends HttpMessageConverter<?>> converterType) {
        return body;
    }

    private String clean(String value) {
        if (value == null || value.isEmpty()) {
            return value;
        }
        int len = value.length();
        int start = 0;
        // 先剥离所有 BOM
        while (start < len && value.charAt(start) == BOM) {
            start++;
        }
        // 再剥离空白/换行，直到遇到合法起始字符
        while (start < len) {
            char ch = value.charAt(start);
            if (ch == '<' || ch == '{' || ch == '[') {
                break;
            }
            start++;
        }
        // 关键：如果扫到结尾都没遇到合法起始字符，说明这段内容根本不是 xml/json，
        // 保留原值不动 —— 让 warm-flow 按原样处理(会抛解析异常)，而不是清空后让 saveXml 静默成功无操作。
        if (start >= len) {
            log.warn("warm-flow 入参不含合法起始字符 '<'/'{'/'['，可能是纯文本而非 xml，保留原值不清洗: [{}]",
                    value.length() > 200 ? value.substring(0, 200) + "..." : value);
            return value;
        }
        if (start > 0) {
            String stripped = value.substring(0, Math.min(start, 80))
                    .replace("\r", "\\r").replace("\n", "\\n");
            log.warn("warm-flow 入参包含前导内容，已剥离 {} 个字符，被剥离内容前 80 字符: [{}]",
                    start, stripped);
        }
        return value.substring(start).stripTrailing();
    }
}