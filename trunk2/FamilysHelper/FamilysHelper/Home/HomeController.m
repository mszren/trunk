//
//  HomeController.m
//  FamilysHelper
//
//  Created by 曹亮 on 14/11/5.
//  Copyright (c) 2014年 FamilyTree. All rights reserved.
//

#import "HomeController.h"
#import "CommunityController.h"
#import "FriendsController.h"
#import "ChatHomeController.h"
#import "PublishController.h"
#import "AddressBookController.h"
@interface HomeController () <UIScrollViewDelegate> {
    UIBarButtonItem* rightButton;
    UISegmentedControl* _seg;
    CommunityController* _community;
    FriendsController* _friend;
    ChatHomeController *_chat;
}

@end

@implementation HomeController
@synthesize messageListner;
- (void)viewDidLoad
{
    [super viewDidLoad];

    rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_edit"] style:UIBarButtonItemStylePlain target:self action:@selector(onrightButton:)];

    [self setLeftPersonAction];

    self.navigationItem.rightBarButtonItem = rightButton;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initializeNavTitleView];
}

- (void)onrightButton:(id)sender
{
    switch (_seg.selectedSegmentIndex) {
    case 0: {

        NSDictionary* dic = @{ ACTION_Controller_Name : _community,
            ACTION_Controller_Data : [NSString stringWithFormat:@"%d", 1] };
        [self RouteMessage:ACTION_SHOW_HOME_PUBLISH withContext:dic];
        break;
    }
    case 1: {
        NSDictionary* dic = @{ ACTION_Controller_Name : _friend,
            ACTION_Controller_Data : [NSString stringWithFormat:@"%d", 0] };
        [self RouteMessage:ACTION_SHOW_HOME_PUBLISH withContext:dic];
        break;
    }
    case 2: {
        NSDictionary* dic = @{ ACTION_Controller_Name : _chat };
        [self RouteMessage:ACTION_SHOW_SYSTEM_ADRESSBOOK withContext:dic];
        break;
    }

    default:
        break;
    }
}

/**
 *  初始化头部切换标签
 */
- (void)initializeNavTitleView
{
    _seg = [[UISegmentedControl alloc] initWithItems:@[ @"小区", @"亲友", @"消息" ]];
    _seg.segmentedControlStyle = UISegmentedControlStyleBar;
    _seg.tintColor = [UIColor whiteColor];
    _seg.frame = CGRectMake((SCREEN_WIDTH - SegWidth) / 2, 6, SegWidth, seghight);
    [_seg addTarget:self action:@selector(onSegmentedControlClick:) forControlEvents:UIControlEventValueChanged];
    _seg.selectedSegmentIndex = 0; //选中的分段的索引
    self.navigationItem.titleView = _seg;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setRedNavBg];
}

- (void)onSegmentedControlClick:(UISegmentedControl*)sender
{
    [self changePageAction:sender.selectedSegmentIndex];
    [self changeState:sender.selectedSegmentIndex];
}

/**
 *  更改右上角按钮状态
 *
 *  @param index <#index description#>
 */
- (void)changeState:(NSInteger)index
{
    _seg.selectedSegmentIndex = index;
    switch (index) {
    case 0:
        [rightButton setImage:[UIImage imageNamed:@"icon_edit"]];
        [rightButton setTitle:nil];
        break;
    case 1:
        [rightButton setImage:[UIImage imageNamed:@"icon_edit"]];
        [rightButton setTitle:nil];
        break;
    case 2:
        [rightButton setImage:nil];
        [rightButton setTitle:@"通讯录"];
        break;

    default:
        break;
    }
}

/**
 *  页面初始化
 *
 *  @return <#return value description#>
 */
- (id)init
{

    NSMutableArray* controllerArray = [[NSMutableArray alloc] init];
    _community = [[CommunityController alloc] init];
    _community.messageListner = self;
    [controllerArray addObject:_community];

    _friend = [[FriendsController alloc] init];
    _friend.messageListner = self;
    [controllerArray addObject:_friend];

    _chat = [[ChatHomeController alloc] init];
    _chat.messageListner = self;
    [controllerArray addObject:_chat];

    self = [self initWithItems:nil andControllers:controllerArray withHideBar:YES];

    if (self) {
    }
    return self;
}

#pragma mark
#pragma mark-- scroll delegate
- (void)scrollOffsetChanged:(CGPoint)offset
{
    [super scrollOffsetChanged:offset];
    int lpage = (int)offset.y / SCREEN_WIDTH;
    [self changeState:lpage];
}

#pragma mark -
#pragma mark TitleViewDelegate
- (void)changePageAction:(NSUInteger)aPage
{
    [self selectedChangedIndex:aPage];
}

@end
