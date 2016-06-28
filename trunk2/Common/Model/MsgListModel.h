//
//  MsgListModel.h
//  Common
//
//  Created by Owen on 15/5/27.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgListModel : NSObject<NSCoding>
@property (nonatomic,assign) float count;
@property (nonatomic,assign) float mybanlance;
@property (nonatomic,strong) NSString * payType;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSMutableArray* lcdList;

+(MsgListModel *)JsonParse:(NSDictionary *)dic;
@end