//
//  APISDK+Index.h
//  Common
//
//  Created by Owen on 15/5/25.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//

#import "NetConnection.h"

@interface IndexAPI : NetConnection

+ (ASIHTTPRequest*)getRecommendTribeGoodsList:(NSString*)mapX mapY:(NSString*)mapY nextCursor:(NSInteger)nextCursor callback:(NetConnBlock)callback;

+ (ASIHTTPRequest*)getFrontPageInfoV2:(NSInteger)userId callback:(NetConnBlock)callback;

+ (ASIHTTPRequest*)changeOtherTribeFrontPageV2:(NSInteger)userId callback:(NetConnBlock)callback;

+ (ASIHTTPRequest*)getMorePublishContentFrontPageV2:(NSInteger)type tags:(NSString *)tags title:(NSString *)title nextCursor:(NSInteger)nextCursor callback:(NetConnBlock)callback;

+ (ASIHTTPRequest*)getMoreGoodsFrontPageV2:(NSInteger)nextCursor callback:(NetConnBlock)callback;

+ (ASIHTTPRequest*)getActivityListV6:(NSInteger)userId mid:(NSInteger)mid
                            callback:(NetConnBlock)callback;

+ (ASIHTTPRequest*)getRecommendListV6:(NSInteger)userId mid:(NSInteger)mid
                             callback:(NetConnBlock)callback;

+ (ASIHTTPRequest*)getShareListV6:(NSInteger)user_id mid:(NSInteger)mid
                         callback:(NetConnBlock)callback;
+ (ASIHTTPRequest*)newCountMoney:(NSInteger)user_id callback:(NetConnBlock)callback;

+ (ASIHTTPRequest*)getHomePageActivity:(NetConnBlock)callback;

+ (ASIHTTPRequest*)getMoreBangActivityList:(NSInteger)nextCursor title:(NSString*)title userId:(NSString*)userId callback:(NetConnBlock)callback;
+ (ASIHTTPRequest*)getActivitySignInfo:(NSInteger)userId activityId:(NSInteger)activityId nextCursor:(NSInteger)nextCursor
                              callback:(NetConnBlock)callback;
@end
