//
//  TopicDetailCell.h
//  FamilysHelper
//
//  Created by Owen on 15/6/8.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicModel.h"
#import "CommentModel.h"
typedef void (^BlockRefresh)(void);
@interface TopicDetailCell : UITableViewCell <MessageRoutable>
@property (nonatomic, assign) NSInteger tribeID;
@property (nonatomic, strong) UIButton* btnReplyNum;
@property (nonatomic, strong) UIButton* btnPraise;
@property (nonatomic, strong) BlockRefresh refreshload;
@property (nonatomic,assign) NSInteger floorNum;;

- (void)bindTopic:(TopicModel*)model;
- (void)bindComment:(CommentModel*)model;
@end
