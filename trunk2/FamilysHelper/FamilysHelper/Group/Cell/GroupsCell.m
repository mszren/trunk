//
//  GroupsCell.m
//  FamilysHelper
//
//  Created by 曹亮 on 15/3/17.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//

#import "BadgeView.h"
#import "GroupsCell.h"
#import "GroupModel.h"

@interface GroupsCell () <EGOImageViewDelegate>

@end

@implementation GroupsCell

#pragma mark
#pragma mark-- init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setViewDefault
{

    headImg = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"pic_default_40x40"] delegate:self];
    headImg.layer.cornerRadius = 8.0f;
    headImg.layer.masksToBounds = YES;
    headImg.frame = CGRectMake(TableLeftSpaceWidth, TableTopSpaceWidth, TableCellLeftImgWidth, TableCellLeftImgWidth);
    headImg.userInteractionEnabled = YES;
    [self.contentView addSubview:headImg];

    nickNameLab = [[UILabel alloc] init];
    nickNameLab.backgroundColor = [UIColor clearColor];
    nickNameLab.text = @"亲友群";
    nickNameLab.font = TableCellTitleFont;
    nickNameLab.textColor = TableCellTitleColor;
    nickNameLab.textAlignment = NSTextAlignmentLeft;
    nickNameLab.frame = CGRectMake(TableLeftSpaceWidth + TableCellLeftImgWidth + TableLeftImageSpaceWidth, TableTopSpaceWidth, 250, 25);
    [self.contentView addSubview:nickNameLab];

    lastMessageContentLab = [[UILabel alloc] init];
    lastMessageContentLab.backgroundColor = [UIColor clearColor];
    lastMessageContentLab.text = @"我的一度亲友";
    lastMessageContentLab.textAlignment = NSTextAlignmentLeft;
    lastMessageContentLab.frame = CGRectMake(TableLeftSpaceWidth + TableCellLeftImgWidth + TableLeftImageSpaceWidth, TableTopSpaceWidth + 25, SCREEN_WIDTH - (TableLeftSpaceWidth + TableCellLeftImgWidth + TableLeftImageSpaceWidth + 10), 20);
    lastMessageContentLab.font = TableCellDescFont;
    lastMessageContentLab.textColor = TableCellDescColor;
    [self.contentView addSubview:lastMessageContentLab];

    badgeView = [[BadgeView alloc] init];
    badgeView.frame = CGRectMake(SCREEN_WIDTH - TableRightSpaceWidth - 65, TableTopSpaceWidth, 20, 20);
    __unsafe_unretained BadgeView* blockBadgeView = badgeView;
    badgeView.setBadgeStyle = ^{
        blockBadgeView.bgImg.frame = CGRectMake(0, 0, 15, 15);
        blockBadgeView.numLab.frame = blockBadgeView.bgImg.frame;
        blockBadgeView.numLab.font = TableCellTimeFont;
    };
    [self.contentView addSubview:badgeView];

    redPacketLab = [[UILabel alloc] init];
    redPacketLab.backgroundColor = [UIColor clearColor];
    redPacketLab.text = @"群红包";
    redPacketLab.font = TableCellDescFont;
    redPacketLab.textColor = HomeNavBarBgColor;
    redPacketLab.textAlignment = NSTextAlignmentRight;
    redPacketLab.frame = CGRectMake(SCREEN_WIDTH - TableRightSpaceWidth - 50, TableTopSpaceWidth - 3, 50, 25);
    [self.contentView addSubview:redPacketLab];
}

- (void)setViewData:(GroupModel*)aModel
{
    [headImg setImageURL:[AppImageUtil getImageURL:aModel.groupLogo Size:headImg.frame.size]];
    nickNameLab.text = aModel.groupName;
    lastMessageContentLab.text = aModel.groupDescription;

    if (aModel.count.integerValue) {
        [badgeView setBadgeNum:aModel.count.integerValue];
        redPacketLab.hidden = NO;
    }
    else {
        redPacketLab.hidden = YES;
        badgeView.hidden = YES;
    }
}

- (void)cancelAllBtnImageLoad
{
    [headImg cancelImageLoad];
}

- (void)loadHeadImg:(GroupModel*)aModel
{
    [headImg setImageURL:[AppImageUtil getImageURL:aModel.groupImageUrl Size:headImg.frame.size]];
}

#pragma mark -
#pragma mark EGOImageViewDelegate
- (void)imageViewLoadedImage:(EGOImageView*)imageView
{
    imageView.contentMode = UIViewContentModeScaleAspectFit;
}
- (void)imageViewFailedToLoadImage:(EGOImageView*)imageView error:(NSError*)error
{
    imageView.contentMode = UIViewContentModeScaleAspectFit;
}

@end
