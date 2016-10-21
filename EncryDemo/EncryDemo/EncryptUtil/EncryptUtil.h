//
//  EncryptUtil.h
//  text
//
//  Created by feiyangkl on 16/9/27.
//  Copyright © 2016年 feiyangkl. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <CommonCrypto/CommonCryptor.h>
@interface EncryptUtil : NSObject


/// 加密方法
+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;

/// 解密方法
+ (NSString *) decryptUseDES:(NSString *)plainText key:(NSString *)key;
/************************************************************************
 函数名称 : + (NSString*)dictionaryToJson:(NSDictionary *)dic;
 函数描述 : 将字典转换成字符串
 输入参数 : (NSDictionary *)dic  字典
 返回参数 : 字符串
 **********************************************************************
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

/************************************************************************
 函数名称 : + (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
 函数描述 : 将json字符串转换成字典
 输入参数 : (NSString *)jsonString  Json格式的字符串
 返回参数 : 字典
 **********************************************************************
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
