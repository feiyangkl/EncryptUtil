//
//  EncryptUtil.m
//  text
//
//  Created by lanxum on 16/9/27.
//  Copyright © 2016年 lanxum. All rights reserved.
//

#import "EncryptUtil.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

#import <CommonCrypto/CommonDigest.h>

#define gkey            @"LmMGStGtOpF4xNyvYt54EQ=="

@implementation EncryptUtil

/// 加密方法
+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    /// 转换成data
    NSData* plainTextdata = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger plainTextdatLength = [plainTextdata length];
    /// 将data数据MD5加密
    unsigned char digest[16];
    CC_MD5([plainTextdata bytes],(CC_LONG) plainTextdatLength, digest);

    
    // 总长度 MD5 + plainText
    NSUInteger plainTextBufferTotalSize  = 16 +plainTextdatLength;
    
    
    // 将plainText 转换成bytes
    Byte *testByte = (Byte *)[plainTextdata bytes];

    // 定义totalByte
    Byte totalByte[plainTextBufferTotalSize];
    
    
    for (int i = 0; i < plainTextBufferTotalSize; ++i) {
        if (i<16) {
            totalByte[i] =digest[i];
        }else{
            totalByte[i] =testByte[i - 16];
        }
    }
    
    /// 将key base64 编码
    NSData *baseKey = [GTMBase64 decodeString:key];
    Byte *buf = (Byte *)[baseKey bytes];
    
    Byte key1[8];
    Byte iv2[8];
    for (int i = 0; i < 8; i++) {

        key1[i] = buf[i];
    }
    //    // 后8位为iv向量
    for (int i = 0; i < 8 ; i++) {
        iv2[i] = buf[i + 8];
    }
    
    NSString *ciphertext = nil;
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          key1,
                                          kCCKeySizeDES,
                                          iv2,
                                          totalByte,
                                          plainTextBufferTotalSize,
                                          buffer,
                                          1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [[NSString alloc] initWithData:[GTMBase64 encodeData:data] encoding:NSUTF8StringEncoding];
    }
    return ciphertext;
}

/// 解密方法
+ (NSString *) decryptUseDES:(NSString *)plainText key:(NSString *)key {
    
    
    // plainTextData转换 base64
    NSData *BasePlainTextData = [GTMBase64 decodeString:plainText];
    // 将BasePlainTextDatabase64转换为byte数组
    Byte *BasePlainTextDataByte = (Byte *)[BasePlainTextData bytes];
    
    // 将key base64解码
    NSData *baseKey = [GTMBase64 decodeString:key];
    // 将key 转换成 byte数组
    Byte *buf = (Byte *)[baseKey bytes];
    
    // 定义key iv byte数组
    Byte keyByte[8];
    Byte ivByte[8];
    for (int i = 0; i < 8; i++) {
        keyByte[i] = buf[i];
    }
    //    // 后8位为iv向量
    for (int i = 0; i < 8 ; i++) {
        ivByte[i] = buf[i + 8];
    }
    
    /// 返回值长度
    size_t bufferSize = BasePlainTextData.length;
    
    // 字符串长度比较长 返回值给大点
    unsigned char buffer[1024];
    memset(buffer,0,sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          keyByte,
                                          kCCKeySizeDES,
                                          ivByte,
                                          BasePlainTextDataByte,
                                          bufferSize,
                                          buffer,
                                          1024,
                                          &numBytesEncrypted);
    
    
    NSData *resultdata;
    if (cryptStatus == kCCSuccess) {
        
        resultdata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
    }
    
    
    Byte *resultByte = (Byte *)[resultdata bytes];
    
    
    // 返回数组长度 减去MD5加密的16
    size_t returnLength = resultdata.length - 16;
    /// 定义
    Byte decryptionByte[returnLength];
    
    for (int i = 0; i < returnLength; ++i) {
        decryptionByte[i] = resultByte[i+16];
    }
    
    /// md5 校验
    //    unsigned char digest[16];
    //    CC_MD5(decryptionByte,returnLength, digest);
    //    NSData *md5data = [NSData dataWithBytes:digest length:16];
    
    // 进行解密校检
    //    Byte *md5bte= (Byte *)[md5data bytes];
    
    //    for (int i = 0; i < 40; i++) {
    //
    //
    //        if (md5bte[i] !=decryptionByte[i] ) {
    //            // System.out.println(md5Hash[i] + "MD5校验错误。" + temp[i]);
    //            //            throw new Exception("MD5校验错误。");
    //
    //            NSLog(@"c1111uowu");
    //        }else{
    //            NSLog(@"cuowu");
    //        }
    //    }
    
    
    NSData *namedata = [[NSData alloc] initWithBytes:decryptionByte length:returnLength];
    
    NSString *str = [[NSString alloc] initWithData:namedata encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
    
    return str;
    
}







+ (NSString*)dictionaryToJson:(NSMutableDictionary *)dic {
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    
    return dic;
    
}


+(NSString *)getDataStringWithLength:(int)length with :(unsigned char*)digest{
    
    NSMutableString *output = [NSMutableString stringWithCapacity:length * 2];
    
    unsigned char byte[length];
    for(int i = 0; i < length; i++){
        
        byte[i] =(char)digest[i];
        
        [ output appendFormat:@"%d",(char)byte[i]];
        
    }
    
    return output.copy;
}


@end
