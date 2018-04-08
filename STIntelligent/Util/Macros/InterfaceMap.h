//
//  InterfaceMap.h
//  HangZhouSchool
//
//  Created by admin on 16/1/31.
//  Copyright © 2016年 步晓虎. All rights reserved.
//

#ifndef InterfaceMap_h
#define InterfaceMap_h

//#define SocketUrl(userId) [NSString stringWithFormat:@"ws://116.231.119.53:8092/ggtRest/orderConnect/Owner/%@",userId]

//00800005  网站介绍
//00800006  公司介绍
//00800007  法律声明

#define BaseRequestHost @"http://www.airtu.me/RabbitServer/"

//获取token
#define KURL_TokenGet @"api/Token?%@"

//获取验证码
#define KURL_CodeGet @"api/Account?%@"

//登录
#define KURL_Login @"api/Account?%@"

//帮助列表
#define KURL_HelpList @"api/Other?%@"

//社区相关
#define KURL_CommunityAbout @"api/Community?%@"

//社区添加
#define KURL_AddCommunity @"api/User?%@"

//注册
//#define KURL_Regist @"/ECPartyRest/rest/AppUserRest/register"

//社区开门
#define KURL_CommunityDoor @"api/Door?%@"

//临时开门
#define KURL_TemporaryInvitation @"api/Invitation?%@"

//副卡开门
#define KURL_ViceCardInvitation @"api/OfficialAuthorization?%@"

//萤石子账号tokenGet
#define KURL_YSTokenGet @"api/YS7?%@"

//场景相关
#define KURL_Scene @"api/Scene?%@"

//猫眼添加
#define KURL_MaoYanAdd @"api/Equipment?%@"

//上传推送id
#define KURL_PushUpdate @"api/Client?%@"

//消息接口
#define KURL_MessageList @"api/Message?%@"

#endif /* InterfaceMap_h */
