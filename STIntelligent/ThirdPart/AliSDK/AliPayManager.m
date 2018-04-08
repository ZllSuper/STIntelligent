//
//  AliPayManager.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/10/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "AliPayManager.h"

@implementation AliPayManager

- (void)alipayAuthLogin:(CompletionBlock)complete
{
    NSString *pid = @"2088621902822206";
    NSString *appID = @"2017081008125988";
//    NSString *rsaPrivateKey = @"MIIEpAIBAAKCAQEAt/q8E3LHR8G1RYCKazDEdsZ3MbJ3Y7btoajazCjMUWOCQTOGL+XOTyOcb1wB8KucPFD/R94WLb4jDpthBPAHWR4As/zpeJRHNlFU0mzXiyrSjlAP0/TmcLjedDOI4UpWJzKDWLih5B4SD6ZO7mKy+PsLtmnqUtCv2aiAZagIKDX33zxiau4sdVdC/Hu4Zl3QXCXoGQg8kvhJwXH03MIiVPEUBOTNf8zM0cT0V+DEqitAa98cBx4tiwG0pfSCbMvcHJaSHaEyLlwO0kLYCK24VOTVOAF1sjRQ2JoF7zfyiPCuqSqSKwQ792WTaG7FKZIAYY4EmpDZxI60kB82cFkTgQIDAQABAoIBAQCS+4giaYJ3+3Pc0PLE7DMpSSmU1KW5Tj3O913F2ZpSM5Ouj4FW5tvKMgManIEYS6IINhWczvsdFFhhpRT/otvcALJDGX1UzfGOna+MZVRWZKHO/HuItJEd4TQn1bw3cPIfYqW4zdjYrIV1Z0KMBOJDNB2JYFjKTNsQoyPhEzthE1G7gj6VS1NiRoAn6KzUn0lvkjBW+FX/JDBfWXXx4KrA/x2RbzuszfYO1bfmuVwv7dPaayVjwmuDoTbGtdVd57CVXTA9GZwNHTOI6tDWGliURjj4Pr4TvVWerP9rB9yamAAvUicdvh6a5tQq9FP+eTpuIXGWuhqrLI17SQZDhhghAoGBAOB2381r7bmwepSroYAs/T3kYj5yAKO/0ScffzuzcB7rdmSMc4YhWtQ4bbZ/kZmRzmibwMDWy2qhd8WBBhRsUa9HR/bTEyav7tFM0H+DviMgjrDWNt7cjZQPG5TZ7a7IVdN3UHnfJ7z2jC/z/1Qaggxs786xvQfxRfOvo9mjomGVAoGBANHTxb48VcPqac6QfS4ixJv6etIVDsoaV4N3ABWpoBqebCa9fKVpaLdSR3R3o6wrX2V3yBGZQEXtxPyNKTM4++OQqSkXtyjEpHLLtzMhXK6RVEmvmllBQqx+2V1l8wyO9G+wiPe0OYe7FvrpEKQZtJq/FFwa0XxGHGw7bCscWcc9AoGAaylVf4TfYZ9XZlLqL39LB5lZLebPV13kRIFNBPuNs7VGOIq1PHwAGQE3n8EXifGKUXbKd0YUpzufKrOGa4mrFbs6KCRtKDMmGNZLVBVZWPvaI6KhX5R8IwtzZ4UDbEZIc0SrLwPSvOwX0WzzoPtmyvfXJR7F2FzfwI9B8k2k4GECgYBqsTAfZzaFBDEA49+DEhK+7UJ+iE6Y3YQaSOw2F6ZdYqjDmh5DTbH9ZU0IH72N0hAT3DBTIoXYCOrdMDn+3b7XG7uoNXLgu/ySkpt42EH0Udl2DmCBefmZFHcaUrifbiFEmZNLwMxwA+XPd6sKhjebaAXGP6y9cDkLn7uEwEm2UQKBgQDJP7g4sQgG/pPwUBEwR3JjY4YJe+v5tEMf7Lv7t5w1ml9BSaCDyd3e+sRdynJuLv3rLLv67DvlfJkko50NRFXMkPmV1GBe5IutzH1KeswLzE4a15SDoJorXcL9FwUTp/pw2pvTtiu63qrUTWlOIBljh/qAZauKdB8veyxYEC6/Mg==";
    NSString *rsaPrivateKey = @"MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC3+rwTcsdHwbVFgIprMMR2xncxsndjtu2hqNrMKMxRY4JBM4Yv5c5PI5xvXAHwq5w8UP9H3hYtviMOm2EE8AdZHgCz/Ol4lEc2UVTSbNeLKtKOUA/T9OZwuN50M4jhSlYnMoNYuKHkHhIPpk7uYrL4+wu2aepS0K/ZqIBlqAgoNfffPGJq7ix1V0L8e7hmXdBcJegZCDyS+EnBcfTcwiJU8RQE5M1/zMzRxPRX4MSqK0Br3xwHHi2LAbSl9IJsy9wclpIdoTIuXA7SQtgIrbhU5NU4AXWyNFDYmgXvN/KI8K6pKpIrBDv3ZZNobsUpkgBhjgSakNnEjrSQHzZwWROBAgMBAAECggEBAJL7iCJpgnf7c9zQ8sTsMylJKZTUpblOPc73XcXZmlIzk66PgVbm28oyAxqcgRhLogg2FZzO+x0UWGGlFP+i29wAskMZfVTN8Y6dr4xlVFZkoc78e4i0kR3hNCfVvDdw8h9ipbjN2NishXVnQowE4kM0HYlgWMpM2xCjI+ETO2ETUbuCPpVLU2JGgCforNSfSW+SMFb4Vf8kMF9ZdfHgqsD/HZFvO6zN9g7Vt+a5XC/t09prJWPCa4OhNsa11V3nsJVdMD0ZnA0dM4jq0NYaWJRGOPg+vhO9VZ6s/2sH3JqYAC9SJx2+Hprm1Cr0U/55Om4hcZa6GqssjXtJBkOGGCECgYEA4HbfzWvtubB6lKuhgCz9PeRiPnIAo7/RJx9/O7NwHut2ZIxzhiFa1Dhttn+RmZHOaJvAwNbLaqF3xYEGFGxRr0dH9tMTJq/u0UzQf4O+IyCOsNY23tyNlA8blNntrshV03dQed8nvPaML/P/VBqCDGzvzrG9B/FF86+j2aOiYZUCgYEA0dPFvjxVw+ppzpB9LiLEm/p60hUOyhpXg3cAFamgGp5sJr18pWlot1JHdHejrCtfZXfIEZlARe3E/I0pMzj745CpKRe3KMSkcsu3MyFcrpFUSa+aWUFCrH7ZXWXzDI70b7CI97Q5h7sW+ukQpBm0mr8UXBrRfEYcbDtsKxxZxz0CgYBrKVV/hN9hn1dmUuovf0sHmVkt5s9XXeREgU0E+42ztUY4irU8fAAZATefwReJ8YpRdsp3RhSnO58qs4ZriasVuzooJG0oMyYY1ktUFVlY+9ojoqFflHwjC3NnhQNsRkhzRKsvA9K87BfRbPOg+2bK99clHsXYXN/Aj0HyTaTgYQKBgGqxMB9nNoUEMQDj34MSEr7tQn6ITpjdhBpI7DYXpl1iqMOaHkNNsf1lTQgfvY3SEBPcMFMihdgI6t0wOf7dvtcbu6g1cuC7/JKSm3jYQfRR2XYOYIF5+ZkUdxpSuJ9uIUSZk0vAzHAD5c93qwqGN5toBcY/rL1wOQufu4TASbZRAoGBAMk/uDixCAb+k/BQETBHcmNjhgl76/m0Qx/su/u3nDWaX0FJoIPJ3d76xF3Kcm4u/essu/rsO+V8mSSjnQ1EVcyQ+ZXUYF7ki63MfUp6zAvMThrXlIOgmitdwv0XBROn+nDam9O2K7reqtRNaU4gGWOH+oBlq4p0Hy97LFgQLr8y";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    
    //生成 auth info 对象
    APAuthV2Info *authInfo = [APAuthV2Info new];
    authInfo.pid = pid;
    authInfo.appID = appID;
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"STAliAuth";
    
    // 将授权信息拼接成字符串
    NSString *authInfoStr = [authInfo description];
    
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:rsaPrivateKey];
    signedString = [signer signString:authInfoStr withRSA2:YES];
    
    // 将签名成功字符串格式化为订单字符串,请严格按照该格式
    authInfoStr = [NSString stringWithFormat:@"%@&sign=%@&sign_type=%@", authInfoStr, signedString, @"RSA2"];
    [[AlipaySDK defaultService] auth_V2WithInfo:authInfoStr
                                         fromScheme:appScheme
                                           callback:complete];

}

@end
