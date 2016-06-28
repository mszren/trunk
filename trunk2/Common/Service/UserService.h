//
//  UserService.h
//  Common
//
//  Created by Owen on 15/5/21.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//

#import "BaseService.h"

@interface UserService : BaseService

+ (UserService*)shareInstance;
- (ASIHTTPRequest*)LoginBy:(NSString*)username password:(NSString*)password
                 OnSuccess:(onSuccess)onSuccess;
- (ASIHTTPRequest*)getMyOrderList:(NSInteger)userId payStatus:(NSString*)payStatus nextCursor:(NSInteger)nextCursor OnSuccess:(onSuccess)onSuccess;

- (ASIHTTPRequest*)getTribeInterActionByUserId:(NSInteger)userId typeId:(NSInteger)typeId
                                         title:(NSString*)title
                                    nextCursor:(NSInteger)nextCursor
                                     OnSuccess:(onSuccess)onSuccess;

- (ASIHTTPRequest*)addRecommendBrokerNew:(NSInteger)userId brokerName:(NSString*)brokerName brokerPhone:(NSString*)brokerPhone cardId:(NSString*)cardId
                               OnSuccess:(onSuccess)onSuccess;
- (ASIHTTPRequest*)getRecommendBrokerdatailNew:(NSInteger)userId OnSuccess:(onSuccess)onSuccess;

- (ASIHTTPRequest*)deleteMyOrder:(NSString *)orderNum  OnSuccess:(onSuccess)onSuccess;

/**
 *  我的收藏
 *
 *  @param userId     用户id
 *  @param nextCursor 分页参数
 *  @param title 检索条件
 *  @param type 检索类型（1：互动 2：活动 3：商品）
 *  @param callback   回调函数
 */
- (ASIHTTPRequest*)getMyCollectList:(NSString*)title type:(NSInteger)type nextCursor:(NSInteger)nextCursor userId:(NSInteger)userId OnSuccess:(onSuccess)onSuccess;

- (ASIHTTPRequest*)getNewMyGetRedPacket:(NSInteger)userId nextCursor:(NSInteger)nextCursor OnSuccess:(onSuccess)onSuccess;
- (ASIHTTPRequest*)getNewMyFaSongRedPacket:(NSInteger)userId nextCursor:(NSInteger)nextCursor OnSuccess:(onSuccess)onSuccess;

- (ASIHTTPRequest*)getMyYaoyou:(NSInteger)userId OnSuccess:(onSuccess)onSuccess;
- (ASIHTTPRequest*)deleteMyCollect:(NSString *)collectId  OnSuccess:(onSuccess)onSuccess;
- (ASIHTTPRequest*)getRefundInfoByMobile:(NSString *)orderId  OnSuccess:(onSuccess)onSuccess;
@end