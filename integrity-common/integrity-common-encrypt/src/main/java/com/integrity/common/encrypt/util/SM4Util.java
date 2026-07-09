package com.integrity.common.encrypt.util;


import org.apache.commons.codec.binary.Hex;
import org.bouncycastle.jce.provider.BouncyCastleProvider;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.security.Security;

public final class SM4Util {
    static {
        Security.addProvider(new BouncyCastleProvider());
    }
    private static final String ENCODING = "UTF-8";
    public static final String ALGORITHM_NAME = "SM4";
    // 加密算法/分组加密模式/分组填充方式
    // PKCS5Padding-以8个字节为一组进行分组加密
    // 不填充时将PKCS5Padding改为NoPadding
    public static final String ALGORITHM_NAME_ECB_PADDING = "SM4/ECB/PKCS5Padding";
    // 128-32位16进制；256-64位16进制
    public static final int DEFAULT_KEY_SIZE = 128;
    private static final int SM4_KEY_HEX_LENGTH = 32;

    /**
     * 生成ECB暗号
     * @explain ECB模式（电子密码本模式：Electronic codebook）
     * @param algorithmName 算法名称
     * @param mode 模式
     * @param key 秘钥
     * @return
     * @throws Exception
     */
    private static Cipher generateEcbCipher(String algorithmName, int mode, byte[] key) throws Exception {
        Cipher cipher = Cipher.getInstance(algorithmName, BouncyCastleProvider.PROVIDER_NAME);
        Key sm4Key = new SecretKeySpec(key, ALGORITHM_NAME);
        cipher.init(mode, sm4Key);
        return cipher;
    }

    /**
     * @explain 加密模式：ECB
     *          密文长度不固定，需要手动将其固定在16的整数倍上（字节）
     *  16进制密钥（忽略大小写）
     * @param paramStr 待加密字符串（16进制）
     * @return 返回16进制的加密字符串
     * @throws Exception
     */
    public static String encryptEcb(String paramStr, String hexKey) throws Exception {
        String cipherText = "";
        // 将秘钥和待加密字符串转为byte[]
        validateHexKey(hexKey);
        byte[] keyData = hexStrToBytes(hexKey);
        byte[] srcData = pad(paramStr); // 将待加密字符串补充到16的整数倍，再转为byte[]，具体方法见下文
        // 加密后得到的数组
        Cipher cipher = generateEcbCipher(ALGORITHM_NAME_ECB_PADDING, Cipher.ENCRYPT_MODE, keyData);
        byte[] cipherArray = cipher.doFinal(srcData);
        cipherText = bytesToHexString(cipherArray,0,cipherArray.length);
        return cipherText;
    }



    /**
     * sm4解密
     * @explain 解密模式：采用ECB
     * hexKey 16进制密钥
     * @param cipherText 16进制的加密字符串（忽略大小写）
     * @return 解密后的字符串
     * @throws Exception
     */
    public static String decryptEcb(String cipherText, String hexKey) throws Exception {
        // 用于接收解密后的字符串
        String decryptStr = "";
        // 将秘钥和待加密字符串转为byte[]
        validateHexKey(hexKey);
        byte[] keyData = hexStrToBytes(hexKey);
        byte[] cipherData = pad(cipherText);
        // 解密
        Cipher cipher = generateEcbCipher(ALGORITHM_NAME_ECB_PADDING, Cipher.DECRYPT_MODE, keyData);
        byte[] srcData = cipher.doFinal(cipherData);
        decryptStr = bytesToHexString(srcData,0,srcData.length);
        //将16进制的字符串转为字符串返回
        return convertString(decryptStr);
    }

    private static void validateHexKey(String hexKey) {
        if (hexKey == null || hexKey.length() != SM4_KEY_HEX_LENGTH || !hexKey.matches("[0-9a-fA-F]+")) {
            throw new IllegalArgumentException("SM4 key must be a 32-character hex string.");
        }
    }



    // 将16进制字符串转为byte[]
    public static byte[] hexStrToBytes(String hexStr) {
        String t = hexStr;
        if (t.length() % 2 == 1) {
            t = "0" + hexStr;
        }
        byte[] bytes = new byte[t.length() / 2];
        for (int i = 0; i < t.length(); i += 2) {
            bytes[i / 2] = (byte) Integer.parseInt(t.substring(i, i + 2), 16);
        }
        return bytes;
    }



    public static String bytesToHexString(byte[] src, int start, int end) {
        StringBuilder stringBuilder = new StringBuilder("");
        if (src == null || src.length <= 0) {
            return null;
        }
        for (int i = start; i < end; i++) {
            int v = src[i] & 0xFF;
            String hv = Integer.toHexString(v);
            if (hv.length() < 2) {
                stringBuilder.append(0);
            }
            stringBuilder.append(hv);
        }
        return stringBuilder.toString().toUpperCase();
    }


    public static byte[] pad(String arg_text) {
        byte[] encrypt = hexStrToBytes(arg_text);
        int len = encrypt.length % 16;
        if (len != 0) {
            len = 16 - (encrypt.length % 16);
            for (int i = 0;i<len;i++){
                arg_text = arg_text+"00";
            }
        }
        return hexStrToBytes(arg_text);
    }

    /**
     * 字符串的16进制转String
     * @param codkey 字符串的16进制
     * @return
     * @throws Exception
     */
    public static String  convertString(String codkey) throws Exception{
        byte[] bytes = Hex.decodeHex(codkey.toCharArray());
        String stringValue = new String(bytes, StandardCharsets.UTF_8);
        return stringValue;
    }
}
