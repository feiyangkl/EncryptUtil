# EncryptUtil
# feiyangklDES

一行代码完成DES加密，加密模式 DES + CBC

## DEMO GIF

![Image text](https://github.com/feiyangkl/EncryptUtil/blob/master/EncryDemo/EncryDemo/Untitled.gif)

## DEMO 简介
```
最近项目中用到DES加密，在这里整理成篇，供大家参考阅读，在使用该demo过程中，你可能会遇到一些问题，首先你需要看一下下面的demo简介，看看该demo 是否适合你的项目。

项目中的DES加解密主要用在网络请求过程中对上传的参数进行加密，对从后台服务器获取的数据进行解密。

整体的加密流程为:

加密的过程: 参数字典 --> json字符串 --> base64加密后的字符串 --> DES加密后base64再加密 --> 输出最终加密后的字符串;

解密的过程： 

后台服务器获取加密的字符串 -->base64解密 --> DES解密后base64解密 --> json字符串 --> 数据字典;(与加密的过程相反)

网上对DES的详细介绍已经有很多，在这里不做赘述，如果你需要了解这些知识，google.
```

在这里感谢这些 blog 的作者,让我在开发过程中少走了很多弯路:

[http://www.open-open.com/lib/view/open1452738808948.html)

[https://my.oschina.net/jsan/blog/54385)

[http://blog.csdn.net/j_akill/article/details/44079597](http://blog.csdn.net/j_akill/article/details/44079597)

[http://blog.csdn.net/jbjwpzyl3611421/article/details/18256917)

[https://github.com/IMCCP/CCPAESEncode/blob/master/CCPAESEncode)

```
我们公司后台为JAVA,移动端有iOS与Android, 讨论后选择DES的加密模式为 DES + CBC (注意是否满足你的加密需求)。

为什么选择这种加密模式:


如果采用PKCS7Padding或者PKCS5Padding这种加密方式，末端添加的数据可能不固定，在解码后需要把末端多余的字符去掉，比较棘手。

如果不管补齐多少位，末端都是'\0',去掉的话比较容易操作。 最主要的是能使得

iOS/Android/PHP相互通信，也是加密过程中最难搞的地方，尤其需要开发者注意。


项目中用到了 google 的 base64 加解密库 GTMBase64，但是这个库已经有很多年没有更新 还是 MRC 开发模式，需要手动配置一下：

1.选择项目中的Targets，选中你所要操作的Target，

2.选Build Phases，在其中Complie Sources中选择需要ARC的文件双击，并在输入框中输入 -fno-objc-arc
```

## DEMO 使用示例
```
//加密

/// 加密
NSMutableDictionary *dic=[NSMutableDictionary dictionary];
[dic setValue:@"111111" forKey:@"password"];
[dic setValue:@"admin" forKey:@"userName"];

/*
加密{"userName":"admin","password":"111111"}和
{
"userName" : "admin",
"password" : "111111"
}
加密后结果是不一样的,一定要确定公司后台是怎么加密的,要不然有可能会错误
*/
NSString *jsonstr = [dic JSONString];
self.lb_show.text = [EncryptUtil encryptUseDES:jsonstr key:gkey];

//加密结果 iMXucxT4Z6v0ZILRJtUX1W/8KfR1wvqqdDxHiOdfTvkdVQQnJ7p1DdMPQXM60BwNHBdjhTqbnXIN
eEYVIHbb6w==

```
```
//解密

- (IBAction)clickDecodeBtn:(UIButton *)sender {

//上面加密的结果
NSString *AESString = @"iMXucxT4Z6v0ZILRJtUX1W/8KfR1wvqqdDxHiOdfTvkdVQQnJ7p1DdMPQXM60BwNHBdjhTqbnXIN
eEYVIHbb6w==";

///解密
self.lb_show.text = [EncryptUtil decryptUseDES:self.lb_show.text key:gkey];

解密结果:{"userName":"admin","password":"111111"}

}
```
```
java 
/**
* <li>
* 方法名称:encrypt</li> <li>
* 加密方法
* @param xmlStr
*            需要加密的消息字符串
* @return 加密后的字符串
*/
public static String encrypt(String xmlStr) {
byte[] encrypt = null;

try {
// 取需要加密内容的utf-8编码。
encrypt = xmlStr.getBytes("utf-8");
} catch (UnsupportedEncodingException e) {
e.printStackTrace();
}
// 取MD5Hash码，并组合加密数组
byte[] md5Hasn = null;
try {

//            md5Hash = EncryptUtil.MD5Hash(temp, 16, temp.length - 16);

md5Hasn = EncryptUtil.MD5Hash(encrypt, 0, encrypt.length);
} catch (Exception e) {
e.printStackTrace();
}
// 组合消息体
byte[] totalByte = EncryptUtil.addMD5(md5Hasn, encrypt);

// 取密钥和偏转向量
byte[] key = new byte[8];
byte[] iv = new byte[8];
getKeyIV(EncryptUtil.key, key, iv);



SecretKeySpec deskey = new SecretKeySpec(key, "DES");



IvParameterSpec ivParam = new IvParameterSpec(iv);

// 使用DES算法使用加密消息体
byte[] temp = null;
try {
temp = EncryptUtil.DES_CBC_Encrypt(totalByte, deskey, ivParam);
} catch (Exception e) {
e.printStackTrace();
}

// 使用Base64加密后返回
return new BASE64Encoder().encode(temp);
}


ios
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

```

```

java 解密
/**
* <li>
* 方法名称:encrypt</li> <li>
* 功能描述:
*
* <pre>
* 解密方法
* </pre>
*
* </li>
*
* @param xmlStr
*            需要解密的消息字符串
* @return 解密后的字符串
* @throws Exception
*/
public static String decrypt(String xmlStr) throws Exception {
// base64解码
BASE64Decoder decoder = new BASE64Decoder();
byte[] encBuf = null;
try {
encBuf = decoder.decodeBuffer(xmlStr);
} catch (IOException e) {
e.printStackTrace();
}

// 取密钥和偏转向量
byte[] key = new byte[8];
byte[] iv = new byte[8];
getKeyIV(EncryptUtil.key, key, iv);

SecretKeySpec deskey = new SecretKeySpec(key, "DES");
IvParameterSpec ivParam = new IvParameterSpec(iv);

// 使用DES算法解密
byte[] temp = null;
try {
temp = EncryptUtil.DES_CBC_Decrypt(encBuf, deskey, ivParam);
} catch (Exception e) {
e.printStackTrace();
}

// 进行解密后的md5Hash校验
byte[] md5Hash = null;
try {
md5Hash = EncryptUtil.MD5Hash(temp, 16, temp.length - 16);
} catch (Exception e) {
e.printStackTrace();
}

// 进行解密校检
for (int i = 0; i < md5Hash.length; i++) {
if (md5Hash[i] != temp[i]) {
// System.out.println(md5Hash[i] + "MD5校验错误。" + temp[i]);
throw new Exception("MD5校验错误。");
}
}

// 返回解密后的数组，其中前16位MD5Hash码要除去。
return new String(temp, 16, temp.length - 16, "utf-8");
}


ios 解密

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

```
项目中遇到的一些坑，在 DEMO 中都已经注释出来，写的比较清楚，如果该 DEMO 帮助了您，也希望能给个 star

鼓励一下，如果在使用中您有任何问题，可以在 github issues,我会尽自己能力给您答复 。




