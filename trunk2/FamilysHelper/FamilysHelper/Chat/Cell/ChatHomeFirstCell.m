//
//  ChatHomeFirstCell.m
//  FamilysHelper
//
//  Created by 曹亮 on 15/3/16.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//

#import "ChatHomeFirstCell.h"

#import "AllChatController.h"
#import "InterestGroupController.h"


@implementation ChatHomeFirstCell

@synthesize  messageListner;
#pragma mark
#pragma mark -- init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setViewDefault
{
    UIView * allChatView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, TableChatHomeCellHeight)];
    
    UIImageView * allChatImg = [[UIImageView alloc] initWithFrame:CGRectMake(TableLeftSpaceWidth,  TableTopSpaceWidth, TableCellLeftImgWidth, TableCellLeftImgWidth)];
    allChatImg.image = [UIImage imageNamed:@"allChatBtn.png"];
    allChatImg.userInteractionEnabled = YES;
    [allChatView addSubview:allChatImg];
    
    UILabel * allChatLab1 = [[UILabel alloc] init];
    allChatLab1.backgroundColor = [UIColor clearColor];
    allChatLab1.text = @"大家聊";
    allChatLab1.font = TableCellTitleFont;
    allChatLab1.textColor = TableCellTitleColor;
    allChatLab1.textAlignment = NSTextAlignmentLeft;
    allChatLab1.frame = CGRectMake(TableLeftSpaceWidth + TableCellLeftImgWidth+TableLeftImageSpaceWidth, TableTopSpaceWidth, 100, 25);
    [allChatView addSubview:allChatLab1];
    
    UILabel * allChatLab2 = [[UILabel alloc] init];
    allChatLab2.backgroundColor = [UIColor clearColor];
    allChatLab2.text = @"畅聊，想说就说";
    allChatLab2.textAlignment = NSTextAlignmentLeft;
    allChatLab2.frame = CGRectMake(TableLeftSpaceWidth + TableCellLeftImgWidth+TableLeftImageSpaceWidth, TableTopSpaceWidth+25, 100, 20);
    allChatLab2.font = TableCellDescFont;
    allChatLab2.textColor = TableCellDescColor;
    [allChatView addSubview:allChatLab2];
    [self addSubview:allChatView];
    
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allChatAction:)];
    [allChatView addGestureRecognizer:tap1];
    
    UIImageView * lineImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unitylineVertical.png"]];
    lineImg.frame = CGRectMake(SCREEN_WIDTH/2, 7, 1, TableChatHomeCellHeight-15);
    [self addSubview:lineImg];
    
    UIView * interestGroupView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, TableChatHomeCellHeight)];
    
    UIImageView * interestGroupImg = [[UIImageView alloc] initWithFrame:CGRectMake(TableLeftSpaceWidth,  TableTopSpaceWidth, TableCellLeftImgWidth, TableCellLeftImgWidth)];
    interestGroupImg.image = [UIImage imageNamed:@"interestGroupBtn.png"];
    interestGroupImg.userInteractionEnabled = YES;
    [interestGroupView addSubview:interestGroupImg];
    
    UILabel * interestGroup1 = [[UILabel alloc] init];
    interestGroup1.backgroundColor = [UIColor clearColor];
    interestGroup1.text = @"兴趣群";
    interestGroup1.font = TableCellTitleFont;
    interestGroup1.textColor = TableCellTitleColor;
    interestGroup1.textAlignment = NSTextAlignmentLeft;
    interestGroup1.frame = CGRectMake(TableLeftSpaceWidth + TableCellLeftImgWidth+TableLeftImageSpaceWidth, TableTopSpaceWidth, 100, 25);
    [interestGroupView addSubview:interestGroup1];
    
    UILabel * interestGroup2 = [[UILabel alloc] init];
    interestGroup2.backgroundColor = [UIColor clearColor];
    interestGroup2.text = @"寻找小伙伴";
    interestGroup2.textAlignment = NSTextAlignmentLeft;
    interestGroup2.frame = CGRectMake(TableLeftSpaceWidth + TableCellLeftImgWidth+TableLeftImageSpaceWidth, TableTopSpaceWidth+25, 100, 20);
    interestGroup2.font = TableCellDescFont;
    interestGroup2.textColor = TableCellDescColor;
    [interestGroupView addSubview:interestGroup2];
    [self addSubview:interestGroupView];
    
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(interestGroupAction:)];
    [interestGroupView addGestureRecognizer:tap2];

}

#pragma mark
#pragma mark -- btn action
- (void) allChatAction:(id) sender
{
 
    [self.messageListner RouteMessage:ACTION_SHOW_HOME_ALLCHAT withContext:@{ACTION_Controller_Name:messageListner}];
}
- (void) interestGroupAction:(id) sender
{
    InterestGroupController * controller = [[InterestGroupController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.chatHomeController.navigationController pushViewController:controller animated:YES];
}


@end
