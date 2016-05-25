//
//  NSString+AES.m
//  QooccHealth
//
//  Created by LiuYu on 15/5/28.
//  Copyright (c) 2015年 Juxi. All rights reserved.
//

#import "NSString+AES.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (AES)

// 加密
- (NSString *)encrypt:(NSString *)key {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (data == nil) { return nil; }
    
    NSData *encryptData = [data encrypt:key];
    return [encryptData base64EncodedStringWithOptions:0];
}

// 解密
- (NSString *)decrypt:(NSString *)key {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    if (data == nil) { return nil; }
    
    NSData *decryptData = [data decrypt:key];
    return [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
}

//
- (NSString*) hmacsha256:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [self cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC
                                          length:sizeof(cHMAC)];
    
    NSString *hash = [HMAC base64Encoding];
    return hash;
}
- (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {  value |= (0xFF & input[j]);  }  }  NSInteger theIndex = (i / 3) * 4;  output[theIndex + 0] = table[(value >> 18) & 0x3F];
        output[theIndex + 1] = table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6) & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0) & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

- (NSString*)test:(NSString *)key{
    NSString* data = self;
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *hash = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    NSString* hashStr = [[NSString alloc] initWithData:hash encoding:NSUTF8StringEncoding];
    NSString* s = [self base64forData:hash];
    return s;
}

@end
