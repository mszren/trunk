//
//  AnswerView.m
//  FamilysHelper
//
//  Created by 我 on 15/7/1.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//

#import "AnswerView.h"
#import "TribeService.h"
#import "UIView+Toast.h"
#import "TopicModel.h"
#import "ImgModel.h"
#import "OSSUnity.h"
#import "PathHelper.h"

@implementation AnswerView {
    UITextField* _contentText;
    UIButton* _cancelButton;
    UIButton* _certainButton;
    UIButton* _addImageButton;
    UIView* _backGroundView;
    UITextView* _textView;
    UILabel* _covertLabel;
    NSMutableString* _leaveWords;
    UIImage* _imageUrl;
    NSString* _images;
    NSArray* _imagesArry;
    UIScrollView* _scrollView;
    UIImageView* tempImageView;
    
    NSMutableArray *_arrImgs;
    PublishAlbumTopView* _publishAlbumTopView;
    NSString *_imagePath;
}
@synthesize messageListner;
- (id)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        [self registerForKeyboardNotifications];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 325, SCREEN_WIDTH, 325)];
        _backGroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backGroundView];

        //输入框
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH, 80)];
        _textView.delegate = self;
        _textView.textColor = COLOR_GRAY_DEFAULT_OPAQUE_1f;
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.textAlignment = NSTextAlignmentLeft;
        [_backGroundView addSubview:_textView];

        _covertLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, SCREEN_WIDTH, 20)];
        _covertLabel.textColor = COLOR_DARKGRAY_DEFAULT;
        _covertLabel.font = [UIFont systemFontOfSize:15];
        _covertLabel.text = @"请输入内容";
        _covertLabel.textColor = COLOR_GRAY_DEFAULT_OPAQUE_7a;
        [_textView addSubview:_covertLabel];

        //灰线
        UILabel* grayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, SCREEN_WIDTH - 20, 1)];
        grayLabel.backgroundColor = COLOR_RED_DEFAULT_BackGround;
        [_backGroundView addSubview:grayLabel];

        _publishAlbumTopView = [[PublishAlbumTopView alloc] initWithFrame:CGRectMake(0, 91, SCREEN_WIDTH, PublishImageTileHeight + 40)];
        _publishAlbumTopView.delegate = self;
        [_publishAlbumTopView setViewDefault];
        [_backGroundView addSubview:_publishAlbumTopView];

        _certainButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _certainButton.frame = CGRectMake(10, 210, SCREEN_WIDTH - 20, 40);
        _certainButton.backgroundColor = COLOR_GRAY_DEFAULT_107;
        [_certainButton setTitle:@"提交" forState:UIControlStateNormal];
        _certainButton.layer.cornerRadius = 8;
        _certainButton.clipsToBounds = YES;
        _certainButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_certainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_certainButton addTarget:self action:@selector(onBtnCertain:) forControlEvents:UIControlEventTouchUpInside];
        [_backGroundView addSubview:_certainButton];

        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(10, 265, SCREEN_WIDTH - 20, 40);
        _cancelButton.backgroundColor = COLOR_RED_DEFAULT_8d;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _cancelButton.layer.cornerRadius = 8;
        _cancelButton.clipsToBounds = YES;
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(onBtnCancel:) forControlEvents:UIControlEventTouchUpInside];
        [_backGroundView addSubview:_cancelButton];
    }
    return self;
}

- (void)onBtnCertain:(UIButton*)sender
{

    if ([_textView.text isEqualToString:@""]) {
        
        [ToastManager showToast:@"请输入内容" withTime:Toast_Hide_TIME];
        return;
    }
    _arrImgs = [[NSMutableArray alloc] initWithCapacity:0];
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
        
        _imagePath = path;
    }
    
    
    if (_arrImgs.count == 0) {
        _images = @"";
        [self answer];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[OSSUnity shareInstance] uploadFiles:_arrImgs
                        withTargetSubPath:OSSMessagePath
                                withBlock:^(NSArray* arrStatus) {
                                    NSMutableString* _arrResourceURL = [[NSMutableString alloc] initWithCapacity:0];
                                    for (int i = 0; i < _arrImgs.count; i++) {
                                        ImgModel* model = _arrImgs[i];
                                            [_arrResourceURL appendFormat:@"%@|%d", model.imagename,i];
                                    }
                                    
                                  _images = [NSString stringWithString:_arrResourceURL];
                                  [self answer];

     
    }];
    [_textView resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self MessageRoutable];
    [self removeFromSuperview];
    
  
}

-(void)answer{
    
    if (_typeId == 1) {
        
        //评论互动
        [[TribeService shareInstance] discussInterBy:[CurrentAccount currentAccount].uid
                                             content:_textView.text
                                            hudongId:_hudongId
                                             tribeId:_tribeId
                                              typeId:_typeId
                                              images:_images
                                           OnSuccess:^(DataModel* dataModel) {
                                               
                                               if (dataModel.code == 202) {
                                                   if (_typeId == 1) {
                                                       [ToastManager showToast:@"评论互动成功" withTime:Toast_Hide_TIME];
                                                       
                                                   }else
                                                       [ToastManager showToast:dataModel.error withTime:Toast_Hide_TIME];
                                                   
                                               }
                                               
                                           }];
    }
    else if (_typeId == 2) {
        
        //回复评论
        [[TribeService shareInstance] replyDiscussBy:[CurrentAccount currentAccount].uid
                                             content:_textView.text
                                            parentId:_parenteld
                                             tribeId:_tribeId
                                              typeId:_typeId
                                           publishId:_hudongId
                                              images:_images
                                           OnSuccess:^(DataModel* dataModel) {
                                               
                                               
                                               if (dataModel.code == 202) {
                                                   [ToastManager showToast:@"回复评论成功" withTime:Toast_Hide_TIME];
                                               }
                                               else {
                                                   [ToastManager showToast:dataModel.error withTime:Toast_Hide_TIME];
                                               }
                                               
                                           }];
    }
    
}

- (void)MessageRoutable
{
    
        CommentModel* commodel = [[CommentModel alloc] init];
        commodel.commentContentInfo = _textView.text;
        commodel.commentCreateTime = [NSDate currentTimeByJava];
        commodel.commentFace = [CurrentAccount currentAccount].face;
        commodel.commentNickName = [CurrentAccount currentAccount].nickname;
        commodel.commentTip = @"0.00";
        commodel.commentfloorNum = _floorNum;
        commodel.contentHeight = 30;
        commodel.commentUserId = [CurrentAccount currentAccount].uid;
        commodel.face = [CurrentAccount currentAccount].face;
        commodel.imagePath = _imagePath;
        if (_imagePath) {
            commodel.imageHeight = 244;
        }
        if (_typeId == 2) {
            
            commodel.replyNickName = _replyCommentModel.commentNickName;
            commodel.replyContentInfo = _replyCommentModel.commentContentInfo;
//            commodel.replyCreateTime = _replyCommentModel.commentCreateTime;
            commodel.replyFloorNum = _replyCommentModel.commentfloorNum;
            commodel.replyUserId = [NSString stringWithFormat:@"%d",_replyCommentModel.userId];
            commodel.replyContentHeight = 90;
        }else{
            
            commodel.replyContentHeight = 0;
            commodel.replyUserId = @"";
        }
    
        [messageListner RouteMessage:NOTIFICATION_ANSWER withContext:@{ NOTIFICATION_DATA : commodel }];
 
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
    picker.maximumNumberOfSelectionPhoto = 1;
    picker.delegate = self;
    
    [self.window.rootViewController presentViewController:picker
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

- (void)onBtnCancel:(UIButton*)sender
{

    [_textView resignFirstResponder];

    self.hidden = YES;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark
#pragma mark-- UITextViewDelegate

- (void)textViewDidChange:(UITextView*)textView
{
    _textView.text = textView.text;
    if (_textView.text.length == 0) {
        _covertLabel.text = @"请输入内容";
    }
    else {
        _covertLabel.text = @"";
    }
    [_leaveWords stringByAppendingString:_textView.text];
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

#pragma mark
#pragma mark-- NSNotificationCenter

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notify
{

    [UIView animateWithDuration:0.25
                     animations:^{

                         self.frame = CGRectMake(0, -120, SCREEN_WIDTH, SCREEN_HEIGHT);
                     }];
}

- (void)keyboardWillHidden:(NSNotification*)notify
{

    [UIView animateWithDuration:0.25
                     animations:^{
                         self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                     }];
}

@end
