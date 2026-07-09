package com.integrity.common.encrypt.config;

import com.integrity.common.encrypt.util.SM4Util;
import com.ulisesbocchio.jasyptspringboot.EncryptablePropertyDetector;
import com.ulisesbocchio.jasyptspringboot.EncryptablePropertyResolver;
import com.ulisesbocchio.jasyptspringboot.exception.DecryptionException;
import org.springframework.core.env.Environment;

import java.util.Optional;

public class CustomEncryptablePropertyResolver implements EncryptablePropertyResolver {
    private final EncryptablePropertyDetector detector;
    private final Environment environment;

    public CustomEncryptablePropertyResolver(EncryptablePropertyDetector detector, Environment environment) {
        this.detector = detector;
        this.environment = environment;
    }

    @Override
    public String resolvePropertyValue(String value) {
        return Optional.ofNullable(value).filter(detector::isEncrypted).map(resolvedValue -> {
            try {
                String unwrappedProperty = detector.unwrapEncryptedValue(value);
                return SM4Util.decryptEcb(unwrappedProperty, getSm4Key()).trim();
            } catch (Exception e) {
                throw new DecryptionException("Unable to Decrypt: " + value + ". Decryption of Properties failed, make sure encryption/decryption " + "passwords match", e);
            }
        }).orElse(value);
    }

    private String getSm4Key() {
        String key = environment.getProperty("integrity.encrypt.sm4-key");
        if (key == null || key.isBlank()) {
            key = environment.getProperty("INTEGRITY_ENCRYPT_KEY");
        }
        if (key == null || key.isBlank()) {
            key = System.getenv("INTEGRITY_ENCRYPT_KEY");
        }
        if (key == null || key.isBlank()) {
            throw new DecryptionException("Missing SM4 decrypt key. Configure integrity.encrypt.sm4-key or INTEGRITY_ENCRYPT_KEY.");
        }
        return key;
    }
}
