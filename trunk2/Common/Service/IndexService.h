//
//  FirstServe.h
//  Common
//
//  Created by zhouwengang on 15/5/26.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//

#import "BaseService.h"

@interface IndexService : BaseService
//APP首页
- (ASIHTTPRequest*)getFrontPageInfoV2:(NSInteger)userId onSuccess:(onSuccess)onSuccess;

//热门帮 换一组
- (ASIHTTPRequest*)changeOtherTribeFrontPageV2:(NSInteger)userId onSuccess:(onSuccess)onSuccess;

//App首页 更多
- (ASIHTTPRequest*)getMorePublishContentFrontPageV2:(NSInteger)type tags:(NSString *)tags title:(NSString *)title nextCursor:(NSInteger)nextCursor onSuccess:(onSuccess)onSuccess;

//推荐商家列表
- (ASIHTTPRequest*)getRecommendTribeGoodsList:(NSString*)mapX mapY:(NSString*)mapY nextCursor:(NSInteger)nextCursor onSuccess:(onSuccess)onSuccess;

//首页活动赚
- (ASIHTTPRequest*)getActivityListV6:(NSInteger)userid mid:(NSInteger)mid onSuccess:(onSuccess)onSuccess;

//首页推荐赚
- (ASIHTTPRequest*)getRecommendListV6:(NSInteger)userid mid:(NSInteger)mid onSuccess:(onSuccess)onSuccess;

//首页分享赚
- (ASIHTTPRequest*)getShareListV6:(NSInteger)userid mid:(NSInteger)mid onSuccess:(onSuccess)onSuccess;

- (ASIHTTPRequest*)getMoreGoodsFrontPageV2:(NSInteger)nextCursor onSuccess:(onSuccess)onSuccess;

- (ASIHTTPRequest*)newCountMoney:(NSInteger)user_id onSuccess:(onSuccess)onSuccess;
//热门活动
- (ASIHTTPRequest*)getHomePageActivity:(onSuccess)onSuccess;
//热门活动更多
- (ASIHTTPRequest*)getMoreBangActivityList:(NSInteger)nextCursor title:(NSString*)title userId:(NSString*)userId  nSuccess:(onSuccess)onSuccess;

- (ASIHTTPRequest*)getActivitySignInfo:(NSInteger)userId activityId:(NSInteger)activityId nextCursor:(NSInteger)nextCursor
                              onSuccess:(onSuccess)onSuccess;
+ (instancetype)shareInstance;
@end
