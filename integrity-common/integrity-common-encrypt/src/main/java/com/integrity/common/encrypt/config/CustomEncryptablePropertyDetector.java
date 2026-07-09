package com.integrity.common.encrypt.config;

import com.ulisesbocchio.jasyptspringboot.EncryptablePropertyDetector;

public class CustomEncryptablePropertyDetector implements EncryptablePropertyDetector {
    /**
     * 探测字符串
     */
    private static final String FLAG_STR = "ENC(";

    /**
     * 是否可以解密【按照自定义 FLAG_STR 开头】
     *
     * @param property property
     * @return {@link Boolean}
     */
    @Override
    public boolean isEncrypted(String property) {
        if (null != property)
            return property.startsWith(FLAG_STR);
        return false;
    }

    /**
     * 截取除了标识后一位及倒数第二位字符串
     *
     * @param property property
     * @return {@link String}
     */
    @Override
    public String unwrapEncryptedValue(String property) {
        return property.substring(FLAG_STR.length(), property.length() - 1);
    }
}
