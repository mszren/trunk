//
//  ActivityReplyController.m
//  FamilysHelper
//
//  Created by 我 on 15/7/6.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//

#import "ActivityReplyController.h"
#import "TribeService.h"
#import "PublishAlbumTopView.h"
#import "ZYQAssetPickerController.h"
#import "ActivityCommentViewController.h"
#import "OSSUnity.h"
#import "PathHelper.h"
#import "ImgModel.h"
#import "CommentModel.h"
#import "ActivityModel.h"
#import "UzysAssetsPickerController.h"

@interface ActivityReplyController () <UzysAssetsPickerControllerDelegate,PublishAlbumTopViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate,UITextViewDelegate>

@end

@implementation ActivityReplyController {
    UIBarButtonItem* _rightButton;
    UITextView* _textView;
    UILabel* _covertLabel;
    UIView* _backGroundView;
    PublishAlbumTopView* _publishAlbumTopView;
    NSMutableString* _arrResourceURL;
    ActivityCommentViewController *_activityComment;
    NSMutableArray *_arrImgs;
    NSMutableArray *_imagesUrl;
}

@synthesize messageListner;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setWhiteNavBg];
    [self initView];
}

- (void)initView
{
    _imagesUrl = [[NSMutableArray alloc]initWithCapacity:0];
    _rightButton = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(onrightButton:)];
    self.navigationItem.rightBarButtonItem = _rightButton;
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"发布评价";
    title.textColor = COLOR_RED_DEFAULT_78;
    title.font = [UIFont systemFontOfSize:17];
    self.navigationItem.titleView = title;

    self.view.backgroundColor = COLOR_RED_DEFAULT_BackGround;

    _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    _backGroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backGroundView];

    //输入框
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH, 80)];
    _textView.delegate = self;
    _textView.textColor = COLOR_GRAY_DEFAULT_OPAQUE_1f;
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.textAlignment = NSTextAlignmentLeft;
    [_backGroundView addSubview:_textView];

    _covertLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, SCREEN_WIDTH, 20)];
    _covertLabel.textColor = COLOR_DARKGRAY_DEFAULT;
    _covertLabel.font = [UIFont systemFontOfSize:13];
    _covertLabel.text = @"说点什么吧！";
    _covertLabel.textColor = COLOR_GRAY_DEFAULT_OPAQUE_7a;
    [_textView addSubview:_covertLabel];

    _publishAlbumTopView = [[PublishAlbumTopView alloc] initWithFrame:CGRectMake(0, 190, SCREEN_WIDTH, PublishImageTileHeight + 40)];
    _publishAlbumTopView.delegate = self;
    [_publishAlbumTopView setViewDefault];
    [self.view addSubview:_publishAlbumTopView];
}

- (void)onrightButton:(UIBarButtonItem*)sender
{
    
    if (_publishAlbumTopView.dataList.count == 0) {
        [ToastManager showToast:@"请选择要上传的图片！" withTime:Toast_Hide_TIME];
        return;
    }
    if (_textView.text.length == 0) {
        [ToastManager showToast:@"请选择输入内容！" withTime:Toast_Hide_TIME];
        return;
    }
    
    _arrImgs = [[NSMutableArray alloc] initWithCapacity:0];
    [_imagesUrl removeAllObjects];
    for (int i = 0; i < [_publishAlbumTopView.dataList count]; i++) {
        ALAsset* asset = _publishAlbumTopView.dataList[i];
        UIImage* tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        NSData* editImageData = UIImageJPEGRepresentation(tempImg, 0.8f);
        
        NSString* name = [NSString stringWithFormat:@"%@.jpg", [NSDate currentTimeByJava]];
        NSString* path = [[PathHelper cacheDirectoryPathWithName:MSG_Img_Dir_Name] stringByAppendingPathComponent:name];
        [editImageData writeToFile:path atomically:YES];
        ImgModel* model = [[ImgModel alloc] init];
        model.sort = i;
        model.imgpath = path;
        [_arrImgs addObject:model];
        
        ActivityModel *activityModel = [[ActivityModel alloc]init];
        activityModel.imagePath = path;
        [_imagesUrl addObject:activityModel];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[OSSUnity shareInstance] uploadFiles:_arrImgs
                        withTargetSubPath:OSSMessagePath
                                withBlock:^(NSArray* arrStatus) {
                                    _arrResourceURL = [[NSMutableString alloc] initWithCapacity:0];
                                    for (int i = 0; i < _arrImgs.count; i++) {
                                        ImgModel* model = _arrImgs[i];
                                        if (i == _arrImgs.count - 1)
                                            [_arrResourceURL appendFormat:@"%@|%d", model.imagename,i];
                                        else
                                            [_arrResourceURL appendFormat:@"%@|%d,", model.imagename,i];
                                    }
                            
                                    [[TribeService shareInstance] publishActivityReply:[CurrentAccount currentAccount].uid
                                                                         reply_content:_textView.text
                                                                           activity_id:_activityId
                                                                                images:_arrResourceURL
                                                                             OnSuccess:^(DataModel* dataModel) {
                                                                                 NSInteger result = dataModel.code;
                                                                                 if (202 == result) {
                                                                                     [ToastManager showToast:@"发布成功" withTime:Toast_Hide_TIME];
                                                                                     [self RouteMessage];
                                                                                     
                                                                                 }
                                                                                 else if (500 == result) {
                                                                                     [ToastManager showToast:@"数据解析错误" withTime:Toast_Hide_TIME];
                                                                                 }
                                                                                 else if (10004 == result) {
                                                                                     [ToastManager showToast:@"登录超时，请重新登录" withTime:Toast_Hide_TIME];
                                                                                 }
                                                                                 else {
                                                                                     [ToastManager showToast:@"网络超时" withTime:Toast_Hide_TIME];
                                                                                 }
                                                                                     
                                                                                 
                                                                             }];
                                }];
    [self RouteMessage];
    [self.navigationController popViewControllerAnimated:YES];
}


//路由调用刷新
- (void)RouteMessage{
    
    CommentModel *commentModel = [[CommentModel alloc]init];
    commentModel.face = [CurrentAccount currentAccount].face;
    commentModel.createTime = [NSDate currentTimeByJava];
    commentModel.replyContent = _textView.text;
    commentModel.imageList = _imagesUrl;
    commentModel.hitNum = 0;
    commentModel.commentNum = 0;
    [self RouteMessage:NOTIFICATION_BANGBANG_ACTIVITYREPLY withContext:@{ NOTIFICATION_DATA : commentModel }];
}

#pragma mark -
#pragma mark PublishAlbumTopViewDelegate

- (void)showPickImgs:(NSMutableArray*)dataList
{
    
#if 0
    UzysAppearanceConfig *appearanceConfig = [[UzysAppearanceConfig alloc] init];
    appearanceConfig.finishSelectionButtonColor = [UIColor blueColor];
    appearanceConfig.assetsGroupSelectedImageName = @"checker.png";
    appearanceConfig.cellSpacing = 1.0f;
    appearanceConfig.assetsCountInALine = 5;
    [UzysAssetsPickerController setUpAppearanceConfig:appearanceConfig];
#endif
    UzysAssetsPickerController* picker = [[UzysAssetsPickerController alloc] init];
    picker.maximumNumberOfSelectionVideo = 0;
    picker.maximumNumberOfSelectionPhoto = 3 - dataList.count;
    picker.delegate = self;
    
    [self presentViewController:picker
                       animated:YES
                     completion:^{
                         
                     }];
}

#pragma mark - UzysAssetsPickerControllerDelegate methods
- (void)uzysAssetsPickerController:(UzysAssetsPickerController*)picker didFinishPickingAssets:(NSArray*)assets
{
    
    if ([[assets[0] valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]) //Photo
    {
        [_publishAlbumTopView addImgUrls:assets];
    }
}

- (void)uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController*)picker
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:NSLocalizedStringFromTable(@"已经超出上传图片数量！", @"UzysAssetsPickerController", nil)
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark
#pragma mark-- UITextViewDelegate

- (void)textViewDidChange:(UITextView*)textView
{
    _textView.text = textView.text;
    if (_textView.text.length == 0) {
        _covertLabel.text = @"说点什么吧！";
    }
    else {
        _covertLabel.text = @"";
    }
}

- (void)textViewDidBeginEditing:(UITextView*)textView
{
    _textView = textView;
}

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {

        [_textView resignFirstResponder];
        return NO;
    }

    return YES;
}


- (void)onBack
{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
