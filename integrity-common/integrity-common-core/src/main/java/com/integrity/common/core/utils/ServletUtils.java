package com.integrity.common.core.utils;

import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.http.MediaType;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import com.alibaba.fastjson2.JSON;
import com.integrity.common.core.constant.Constants;
import com.integrity.common.core.constant.HttpStatus;
import com.integrity.common.core.text.Convert;
import com.integrity.common.core.web.domain.AjaxResult;
import reactor.core.publisher.Mono;

/**
 * Servlet工具类
 *
 * @author Integrity-Supervision-Platform
 */
public class ServletUtils
{
    /**
     * 获取String参数
     */
    public static String getParameter(String name)
    {
        HttpServletRequest request = getRequest();
        return request == null ? null : request.getParameter(name);
    }

    /**
     * 获取Boolean参数
     */
    public static Boolean getParameterToBool(String name)
    {
        return Convert.toBool(getParameter(name));
    }

    /**
     * 获取request
     */
    public static HttpServletRequest getRequest()
    {
        ServletRequestAttributes attributes = getRequestAttributes();
        return attributes == null ? null : attributes.getRequest();
    }

    /**
     * 获取response
     */
    public static HttpServletResponse getResponse()
    {
        ServletRequestAttributes attributes = getRequestAttributes();
        return attributes == null ? null : attributes.getResponse();
    }

    /**
     * 获取请求属性
     */
    public static ServletRequestAttributes getRequestAttributes()
    {
        return (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
    }

    /**
     * 将字符串渲染到客户端
     */
    public static void renderString(HttpServletResponse response, String string)
    {
        try
        {
            response.setStatus(HttpStatus.SUCCESS);
            response.setContentType(MediaType.APPLICATION_JSON_VALUE);
            response.setCharacterEncoding(Constants.UTF8);
            response.getWriter().print(string);
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
    }

    /**
     * 获取所有请求参数
     */
    public static Map<String, String[]> getParamMap(HttpServletRequest request)
    {
        return request == null ? Collections.emptyMap() : request.getParameterMap();
    }

    /**
     * 获取请求头
     */
    public static String getHeader(HttpServletRequest request, String name)
    {
        String value = request == null ? null : request.getHeader(name);
        return StringUtils.isEmpty(value) ? StringUtils.EMPTY : urlDecode(value);
    }

    /**
     * 获取所有请求头
     */
    public static Map<String, String> getHeaders(HttpServletRequest request)
    {
        if (request == null)
        {
            return Collections.emptyMap();
        }
        Map<String, String> map = new HashMap<>();
        Enumeration<String> enumeration = request.getHeaderNames();
        while (enumeration.hasMoreElements())
        {
            String key = enumeration.nextElement();
            map.put(key, request.getHeader(key));
        }
        return map;
    }

    /**
     * 内容编码
     */
    public static String urlEncode(String str)
    {
        return URLEncoder.encode(str, StandardCharsets.UTF_8);
    }

    /**
     * 内容解码
     */
    public static String urlDecode(String str)
    {
        return URLDecoder.decode(str, StandardCharsets.UTF_8);
    }

    /**
     * Gateway响应写出
     */
    public static Mono<Void> webFluxResponseWriter(ServerHttpResponse response, String msg)
    {
        return webFluxResponseWriter(response, msg, HttpStatus.ERROR);
    }

    /**
     * Gateway响应写出
     */
    public static Mono<Void> webFluxResponseWriter(ServerHttpResponse response, String msg, int code)
    {
        response.setStatusCode(org.springframework.http.HttpStatus.OK);
        response.getHeaders().setContentType(MediaType.APPLICATION_JSON);
        byte[] bytes = JSON.toJSONBytes(AjaxResult.error(code, msg));
        DataBuffer buffer = response.bufferFactory().wrap(bytes);
        return response.writeWith(Mono.just(buffer));
    }
}
