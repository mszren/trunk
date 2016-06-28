//
//  SystemService.h
//  Common
//
//  Created by 我 on 15/6/19.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//

#import "BaseService.h"

@interface SystemService : BaseService

//登陆
- (ASIHTTPRequest*)loginWithUserName:(NSString*)username pwd:(NSString*)password onSuccess:(onSuccess)onSuccess;

- (ASIHTTPRequest*)findpass:(NSString*)username num:(NSString*)num pwd:(NSString*)password onSuccess:(onSuccess)onSuccess;

- (ASIHTTPRequest*)userRegister:(NSString*)username pwd:(NSString*)password nickname:(NSString*)nickname num:(NSString*)num face:(NSString*)face onSuccess:(onSuccess)onSuccess;

- (ASIHTTPRequest*)editpass:(NSInteger)userId oldpass:(NSString*)oldpass newpass:(NSString*)newpass onSuccess:(onSuccess)onSuccess;

- (ASIHTTPRequest*)completePersonInfoNew:(NSInteger)userId nickname:(NSString*)nickname birthday:(NSString*)birthday sex:(NSString*)sex face:(NSString*)face cityId:(NSString*)cityId communityId:(NSString*)communityId signature:(NSString*)signature address:(NSString*)address onSuccess:(onSuccess)onSuccess;

- (ASIHTTPRequest*)getUserInfoNew:(NSInteger)userId uid:(NSString*)uid onSuccess:(onSuccess)onSuccess;

- (ASIHTTPRequest*)getNewIndentifyCode:(NSString*)username onSuccess:(onSuccess)onSuccess;

- (ASIHTTPRequest*)checkNumNew:(NSString*)username num:(NSString*)num onSuccess:(onSuccess)onSuccess;
- (ASIHTTPRequest*)getNewAllcommunityInfo:(onSuccess)onSuccess;
- (ASIHTTPRequest*)getNewAllCityInfo:(onSuccess)onSuccess;

- (ASIHTTPRequest*)getResetCode:(NSString*)username onSuccess:(onSuccess)onSuccess;

- (ASIHTTPRequest*)addFamilyNew:(NSInteger)userId num:(NSString*)num onSuccess:(onSuccess)onSuccess;

+ (instancetype)shareInstance;

@end
