//
//  ActionHandler.m
//  FamilysHelper
//
//  Created by Owen on 15/7/7.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//

#import "ActionHandler.h"
#import "ActionConfig.h"
#import "TribeIndexModel.h"
#import "BangIndexController.h"
#import "AppDelegate.h"
#import "TopicDetailController.h"
#import "TopicModel.h"
#import "PersonController.h"
#import "BangBangActivityViewController.h"
#import "GoodsDetailViewController.h"
#import "GoodsModel.h"
#import "InviteViewController.h"
#import "ActivityViewController.h"
#import "RecommendViewController.h"
#import "ShareViewController.h"
#import "MoreInteractionViewController.h"
#import "WebViewController.h"
#import "ModuleModel.h"
#import "OrdeViewController.h"
#import "SetTopicViewController.h"
#import "QianDaoViewController.h"
#import "MemmberViewController.h"
#import "BangDetailController.h"
#import "ActivityMemberViewController.h"
#import "ActivityReplyController.h"
#import "BangListController.h"
#import "SelectTagsController.h"
#import "BangPublishController.h"
#import "PublishController.h"
#import "AddressBookController.h"
#import "HomeInfoController.h"
#import "GoodsModel.h"
#import "UserInfoViewController.h"
#import "ScanViewController.h"
#import "CXPhotoBrowser.h"
#import "MyYaoyouControllerViewController.h"
#import "MoreActivityViewController.h"
#import "SettingViewController.h"
#import "MyhudongController.h"
#import "AttestationControllerViewController.h"
#import "MyOrderViewController.h"
#import "MyYaoyouControllerViewController.h"
#import "ActivityModel.h"
#import "OrderModel.h"
#import "GoodsModel.h"
#import "MyCollectionController.h"
#import "MyRedPacketController.h"
#import "SelectTagsViewController.h"
#import "ActivityQianDaoViewController.h"
#import "AllChatController.h"
#import "TheEditController.h"
#import "ReturnOrderDetailController.h"

@implementation ActionHandler
#pragma mark -
- (NSDictionary*)actionDictionary
{
    if (_mergedDictionary == nil) {

        NSDictionary* dic = @{ ACTION_SHOW_LOGIN : [self wrapSelector:@selector(showLogin:)],
            ACTION_SHOW_BANGBANG_TOPICDETAIL : [self wrapSelector:@selector(showTopicDetail:)],
            ACTION_SHOW_PERSON_CENTER : [self wrapSelector:@selector(showPersonCenter:)],
            ACTION_SHOW_BANGBANG_BANGINDEX : [self wrapSelector:@selector(showBangIndex:)],
            ACTION_SHOW_BANGBANG_BANGPUBLISH : [self wrapSelector:@selector(showBangPublish:)],
            ACTION_SHOW_BANGBANG_BANGPUBLISH_TAG : [self wrapSelector:@selector(showBangPublishTag:)],
            ACTION_SHOW_BANGBANG_BANGLIST : [self wrapSelector:@selector(showBangList:)],
            ACTION_SHOW_BANGBANG_ACTIVITYDETAIL : [self wrapSelector:@selector(showActivtyDetail:)],
            ACTION_SHOW_BANGBANG_ACTIVITYDETAIL_MEMBER : [self wrapSelector:@selector(showActivtyMember:)],
            ACTION_SHOW_BANGBANG_ACTIVITYREPLY : [self wrapSelector:@selector(showActivtyReply:)],
            ACTION_SHOW_BANGBANG_GOODSDETAIL : [self wrapSelector:@selector(showGoodsDetail:)],
            ACTION_SHOW_BANGBANG_MEMBERLIST : [self wrapSelector:@selector(showMemberList:)],
            ACTION_SHOW_BANGBANG_BANGDETAIL : [self wrapSelector:@selector(showBangDetail:)],
            ACTION_SHOW_BANGBANG_FOLLOWTOPIC : [self wrapSelector:@selector(showFollowTopic:)],
            ACTION_SHOW_BANGBANG_QIANDAO : [self wrapSelector:@selector(showQiandao:)],
            ACTION_SHOW_HOME_PUBLISH : [self wrapSelector:@selector(showHomePublish:)],
            ACTION_SHOW_HOME_MSGDETAIL : [self wrapSelector:@selector(showHomeMsgDetail:)],
            ACTION_SHOW_HOME_ALLCHAT : [self wrapSelector:@selector(showHomeAllChat:)],
            ACTION_SHOW_PERSON_USERINFO : [self wrapSelector:@selector(showUserInfo:)],
            ACTION_SHOW_PERSON_SETTING : [self wrapSelector:@selector(showSetting:)],
            ACTION_SHOW_PERSON_MYINVITE : [self wrapSelector:@selector(showMyInvite:)],
            ACTION_SHOW_PERSON_MYORDER : [self wrapSelector:@selector(showMyOrder:)],
            ACTION_SHOW_PERSON_MYHUDONG : [self wrapSelector:@selector(showMyHudong:)],
            ACTION_SHOW_PERSON_ATTESTATION : [self wrapSelector:@selector(showAttestation:)],
            ACTION_SHOW_PERSON_CENTER_RETURNORDEL : [self wrapSelector:@selector(showReturnOrdel:)],
            ACTION_SHOW_SYSTEM_ADRESSBOOK : [self wrapSelector:@selector(showAddressBook:)],
            ACTION_SHOW_SYSTEM_INVITE : [self wrapSelector:@selector(showInvite:)],
            ACTION_SHOW_SYSTEM_ACTIVITY : [self wrapSelector:@selector(showActivity:)],
            ACTION_SHOW_SYSTEM_ACTIVITYQIANDAO : [self wrapSelector:@selector(showActivityQiandao:)],
            ACTION_SHOW_SYSTEM_RECOMMEND : [self wrapSelector:@selector(showRecommend:)],
            ACTION_SHOW_SYSTEM_SHARE : [self wrapSelector:@selector(showShare:)],
            ACTION_SHOW_SYSTEM_SCAN : [self wrapSelector:@selector(showScan:)],
            ACTION_SHOW_SYSTEM_SELECTTAGS :[self wrapSelector:@selector(showTags:)],
            ACTION_SHOW_SYSTEM_PhotoView : [self wrapSelector:@selector(showPhotoDetail:)],
            ACTION_SHOW_MORE_INTERACTION : [self wrapSelector:@selector(showMoreInteraction:)],
            ACTION_SHOW_MORE_ACTIVITY : [self wrapSelector:@selector(showMoreActivity:)],
            ACTION_SHOW_WEB_INFO : [self wrapSelector:@selector(showWebView:)],
            ACTION_SHOW_SHOP_ORDER : [self wrapSelector:@selector(showShopOrder:)],
            ACTION_SHOW_PERSON_MYCOLLECTION : [self wrapSelector:@selector(showMyCollection:)],
            ACTION_SHOW_PERSON_EDITCENTER  : [self wrapSelector:@selector(showEditCenter:)],
            ACTION_SHOW_PERSON_MYREDRACKET : [self wrapSelector:@selector(showMyRedPacket:)]
                               
        };
        _mergedDictionary = [[NSMutableDictionary alloc] initWithDictionary:[super actionDictionary]];
        [_mergedDictionary addEntriesFromDictionary:dic];
    }

    return _mergedDictionary;
}

- (void)showLogin:(id)context
{
}

- (void)showPersonCenter:(id)context
{

    NSDictionary* dic = (NSDictionary*)context;
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    PersonController* controller = [[PersonController alloc] init];
    controller.messageListner = pushController;
    controller.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:controller
                                                   animated:YES];
}

- (void)showEditCenter:(id)context

{
    
    NSDictionary* dic = (NSDictionary*)context;
    
    NSDictionary *dictionary = [dic objectForKey:ACTION_Controller_Data];
    
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    
    TheEditController* theEditController =
    
    [[TheEditController alloc] init];
    
    theEditController.messageListner = pushController;
    
    theEditController.hidesBottomBarWhenPushed = YES;
    
    theEditController.flag=[dictionary objectForKey:@"flag"];
    
    theEditController.oldText=[dictionary objectForKey:@"oldText"];
    
    [pushController.navigationController pushViewController:theEditController
     
                                                   animated:YES];
    
}



- (void)showTopicDetail:(id)context
{

    NSDictionary* dic = (NSDictionary*)context;
    TopicModel* topicModel = (TopicModel*)[dic objectForKey:ACTION_Controller_Data];
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];

    TopicDetailController* topicVc = [[TopicDetailController alloc] init];
    topicVc.tribeId = topicModel.tribeld;
    topicVc.publishID = topicModel.publishId;
    topicVc.messageListner = topicVc;
    topicVc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:topicVc animated:YES];
}

- (void)showActivtyDetail:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    NSInteger activityId = [[dic objectForKey:ACTION_Controller_Data] integerValue];
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    BangBangActivityViewController* activityVC =
        [[BangBangActivityViewController alloc] initWithActivityID:activityId];
    activityVC.messageListner = pushController;
    activityVC.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:activityVC
                                                   animated:YES];
}

- (void)showActivtyReply:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    NSInteger activityId = [[dic objectForKey:ACTION_Controller_Data] integerValue];
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    ActivityReplyController* replyVC =
        [[ActivityReplyController alloc] init];
    replyVC.messageListner = pushController;
    replyVC.activityId = activityId;
    replyVC.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:replyVC
                                                   animated:YES];
}

- (void)showActivtyMember:(id)context
{

    NSDictionary* dic = (NSDictionary*)context;
    NSInteger activityId =
        [[dic objectForKey:ACTION_Controller_Data] integerValue];
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];

    ActivityMemberViewController* memberVC =
        [[ActivityMemberViewController alloc] init];
    memberVC.activityID = activityId;
    memberVC.messageListner = pushController;
    memberVC.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:memberVC
                                                   animated:YES];
}

- (void)showGoodsDetail:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    GoodsModel* goodsModel = [dic objectForKey:ACTION_Controller_Data];
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    NSInteger goodsID = goodsModel.goodsId;
    NSString* shopName = goodsModel.shopName;
    NSInteger shopId = goodsModel.shopId;
    NSString* goodsName = goodsModel.goodsName;
    GoodsDetailViewController* goodsVC =
        [[GoodsDetailViewController alloc] initWithGoodsID:goodsID
                                                  shopName:shopName
                                                    shopID:shopId
                                                 goodsName:goodsName];
    goodsVC.messageListner = pushController;
    goodsVC.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:goodsVC animated:YES];
}

- (void)showMemberList:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    NSInteger tribeID = [[dic objectForKey:ACTION_Controller_Data] integerValue];
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    MemmberViewController* memberVC =
        [[MemmberViewController alloc] init];
    memberVC.tribeID = tribeID;
    memberVC.messageListner = pushController;
    memberVC.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:memberVC animated:YES];
}

- (void)showBangDetail:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    NSInteger tribeID = [[dic objectForKey:ACTION_Controller_Data] integerValue];
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    BangDetailController* detailVC =
        [[BangDetailController alloc] init];
    detailVC.shopId = tribeID;
    detailVC.messageListner = pushController;
    detailVC.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:detailVC animated:YES];
}

- (void)showFollowTopic:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    SetTopicViewController* setTopicVC =
        [[SetTopicViewController alloc] init];
    setTopicVC.messageListner = pushController;
    setTopicVC.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:setTopicVC animated:YES];
}

- (void)showQiandao:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    NSInteger tribeID = [[dic objectForKey:ACTION_Controller_Data] integerValue];
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    QianDaoViewController* qiandaoVC =
        [[QianDaoViewController alloc] init];
    qiandaoVC.tribeID = tribeID;
    qiandaoVC.messageListner = pushController;
    qiandaoVC.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:qiandaoVC animated:YES];
}

- (void)showBangList:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    BangListController* revc = [[BangListController alloc] init];
    revc.messageListner = pushController;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}

- (void)showBangIndex:(id)context
{

    NSDictionary* dic = (NSDictionary*)context;
    NSDictionary* dict = [dic objectForKey:ACTION_Controller_Data];
    NSInteger tribeId =  [[dict objectForKey:BANGBANG_INDEX_TRIBEID] integerValue];
    NSInteger selectIndex = [[dict objectForKey:BANGBANG_INDEX_SELECTINDEX] integerValue];
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];

    BangIndexController* revc = [[BangIndexController alloc] init];
    revc.messageListner = pushController;
    revc.tribeID = tribeId;
    revc.selectIndex = selectIndex;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}

- (void)showBangPublish:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    TribeModel* tribeModel = [dic objectForKey:ACTION_Controller_Data];
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    BangPublishController* revc = [[BangPublishController alloc] init];
    revc.messageListner = pushController;
    revc.tribeModel = tribeModel;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}

- (void)showBangPublishTag:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    TribeModel* tribeModel = [dic objectForKey:ACTION_Controller_Data];
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    SelectTagsController* revc = [[SelectTagsController alloc] init];
    revc.messageListner = pushController;
    revc.tagsList = tribeModel.tagsList;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}

- (void)showHomePublish:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    NSInteger msg_Type = [[dic objectForKey:ACTION_Controller_Data] integerValue];
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    PublishController* revc = [[PublishController alloc] init];
    revc.messageListner = pushController;
    revc.msg_Type = msg_Type;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}

- (void)showHomeMsgDetail:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    MsgModel* model = [dic objectForKey:ACTION_Controller_Data];
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    HomeInfoController* revc = [[HomeInfoController alloc] init];
    revc.messageListner = pushController;
    revc.msgModel = model;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}

-(void)showHomeAllChat:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    MsgModel* model = [dic objectForKey:ACTION_Controller_Data];
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    AllChatController* revc = [[AllChatController alloc] init];
    revc.messageListner = pushController;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}

- (void)showUserInfo:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    NSString* phone = [dic objectForKey:ACTION_Controller_Data];
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    UserInfoViewController* revc = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
    revc.messageListner = pushController;
    revc.phone = phone;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}
- (void)showSetting:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    SettingViewController* revc = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    revc.messageListner = pushController;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}

- (void)showMyOrder:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    MyOrderViewController* revc = [[MyOrderViewController alloc] init];
    revc.messageListner = pushController;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}
- (void)showMyInvite:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    MyYaoyouControllerViewController* revc = [[MyYaoyouControllerViewController alloc] initWithNibName:@"MyYaoyouControllerViewController" bundle:nil];
    revc.messageListner = pushController;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}

- (void)showMyHudong:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    MyhudongController* revc = [[MyhudongController alloc] init];
    revc.messageListner = pushController;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}
- (void)showMyCollection:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    MyCollectionController* revc = [[MyCollectionController alloc] init];
    revc.messageListner = pushController;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}

- (void)showMyRedPacket:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    MyRedPacketController* revc = [[MyRedPacketController alloc] init];
    revc.messageListner = pushController;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}

- (void)showAttestation:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    AttestationControllerViewController* revc = [[AttestationControllerViewController alloc] init];
    revc.messageListner = pushController;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}

-(void)showReturnOrdel:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    NSString *orderId = [dic objectForKey:ACTION_Controller_Data];
    ReturnOrderDetailController* revc = [[ReturnOrderDetailController alloc] init];
    revc.messageListner = pushController;
    revc.orderID = orderId;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}

- (void)showAddressBook:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];

    AddressBookController* revc = [[AddressBookController alloc] init];
    revc.messageListner = pushController;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}

- (void)showInvite:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];

    InviteViewController* revc = [[InviteViewController alloc] init];
    revc.messageListner = pushController;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}

- (void)showActivity:(id)context
{

    NSDictionary* dic = (NSDictionary*)context;
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    ActivityViewController* revc = [[ActivityViewController alloc] init];
    revc.messageListner = pushController;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}

-(void)showActivityQiandao:(id)context
{
    
    NSDictionary* dic = (NSDictionary*)context;
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    NSInteger activityId = [[dic objectForKey:ACTION_Controller_Data] integerValue];
    ActivityQianDaoViewController* revc = [[ActivityQianDaoViewController alloc] init];
    revc.messageListner = pushController;
    revc.activityID = activityId;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}

- (void)showRecommend:(id)context
{

    NSDictionary* dic = (NSDictionary*)context;
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    RecommendViewController* revc = [[RecommendViewController alloc] init];
    revc.messageListner = pushController;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}

- (void)showShare:(id)context
{

    NSDictionary* dic = (NSDictionary*)context;
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    ShareViewController* revc = [[ShareViewController alloc] init];
    revc.messageListner = pushController;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}

- (void)showScan:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    ScanViewController* revc = [[ScanViewController alloc] init];
    revc.messageListner = pushController;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}

-(void)showTags:(id)context{
    
    NSDictionary* dic = (NSDictionary*)context;
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    SelectTagsViewController* revc = [[SelectTagsViewController alloc] init];
    revc.messageListner = pushController;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
    
}

- (void)showPhotoDetail:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    NSDictionary* dataDic = [dic objectForKey:ACTION_Controller_Data];
    NSInteger aIndex = [[dataDic objectForKey:@"index"] integerValue];
    id<CXPhotoBrowserDelegate, CXPhotoBrowserDataSource> cell = [dataDic objectForKey:@"dataSource"];
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    CXPhotoBrowser* revc = [[CXPhotoBrowser alloc] initWithDataSource:cell delegate:cell];
    revc.wantsFullScreenLayout = YES;
    [revc setInitialPageIndex:aIndex];
    revc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [pushController presentViewController:revc animated:YES completion:^{
        
    }];
}

- (void)showMoreInteraction:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    MoreInteractionViewController* revc = [[MoreInteractionViewController alloc] init];
    revc.messageListner = pushController;
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}
- (void)showMoreActivity:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    NSString* moreType = [dic objectForKey:ACTION_Controller_Data];
    MoreActivityViewController* revc = [[MoreActivityViewController alloc] init];
    revc.messageListner = pushController;
    revc.hidesBottomBarWhenPushed = YES;
    revc.moreType=moreType;
    [pushController.navigationController pushViewController:revc animated:YES];
}

- (void)showShopOrder:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    OrderModel* orderModel = [dic objectForKey:ACTION_Controller_Data];
    OrdeViewController* revc = [[OrdeViewController alloc] initWithOrdelModel:orderModel];
    revc.hidesBottomBarWhenPushed = YES;
    revc.messageListner = pushController;
    [pushController.navigationController pushViewController:revc animated:YES];
}

- (void)showWebView:(id)context
{
    NSDictionary* dic = (NSDictionary*)context;
    UIViewController* pushController = [dic objectForKey:ACTION_Controller_Name];
    WebViewController* revc = [[WebViewController alloc] init];
    revc.messageListner = pushController;
    id isToRoot = [dic objectForKey:ACTION_Controller_IsToRoot];
    if (isToRoot) {
        [revc setBackToRoot:isToRoot];
    }
    revc.titleName = [dic objectForKey:ACTION_Web_Title];
    revc.detailUrl = [dic objectForKey:ACTION_Web_URL];
    revc.flag = [dic objectForKey:ACTION_Web_flag];
    revc.hidesBottomBarWhenPushed = YES;
    [pushController.navigationController pushViewController:revc animated:YES];
}

@end
