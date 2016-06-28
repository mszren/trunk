//
//  MsgCell.m
//  FamilysHelper
//
//  Created by Owen on 15/5/28.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//

#import "MsgCell.h"
#import <CoreText/CoreText.h>
#import "ImgModel.h"
#import "HomeService.h"
#import "UserInfoViewController.h"
#import "CXPhotoBrowser.h"

@interface MsgCell () <EGOImageViewDelegate, CXPhotoBrowserDataSource, CXPhotoBrowserDelegate> {
    MsgModel* _msgModel;
    NSInteger _msg_type;
    NSMutableArray* _imgsList;
    ASIFormDataRequest* request;
}

@end

@implementation MsgCell
@synthesize messageListner;

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)bindMsgModel:(MsgModel*)model type:(NSInteger)msg_type
{

    _msgModel = model;
    _msg_type = msg_type;
    _imgsList = [NSMutableArray arrayWithCapacity:0];
    [_v_jianxi setBackgroundColor:BGViewGray];
    [_lbl_NickName setText:_msgModel.nickname];
    [_lbl_Content setText:_msgModel.content];
    [_lbl_createTime setText:[NSDate daySinceTimeInterval:_msgModel.createTime.doubleValue / 1000.0f]];
    [_btn_zan setTitle:[NSString stringWithFormat:@"%ld", (long)_msgModel.hotNum] forState:UIControlStateNormal];
    [_btn_coment setTitle:[NSString stringWithFormat:@"%ld", (long)_msgModel.replyCommentNumber] forState:UIControlStateNormal];
    if (_msgModel.face == nil || [@"" isEqualToString:_msgModel.face]) {
        [_iv_Face setImage:[UIImage imageNamed:@"ic_face"]];
    }
    else {
        [_iv_Face setImageURL:[AppImageUtil getImageURL:_msgModel.face Size:_iv_Face.frame.size]];
    }
    if (_msgModel.imgList) {

        if (_msgModel.imgList.count > 0) {
            ImgModel* img = _msgModel.imgList[0];
            if (![img.imgpath isEqualToString:@""] && img.imgpath ) {
                [_iv_img1 setImage:[[UIImage alloc] initWithContentsOfFile:img.imgpath]];
            }
            else
                [_iv_img1 setImageURL:[AppImageUtil getImageURL:img.imagename Size:_iv_img1.frame.size]];
            [_iv_img1 setHidden:NO];
        }
        else
            [_iv_img1 setHidden:YES];

        if (_msgModel.imgList.count > 1) {
            ImgModel* img = _msgModel.imgList[1];
            if (![img.imgpath isEqualToString:@""] && img.imgpath) {
                [_iv_img2 setImage:[[UIImage alloc] initWithContentsOfFile:img.imgpath]];
            }
            else
                [_iv_img2 setImageURL:[AppImageUtil getImageURL:img.imagename Size:_iv_img2.frame.size]];
            [_iv_img2 setHidden:NO];
        }
        else
            [_iv_img2 setHidden:YES];

        if (_msgModel.imgList.count > 2) {
            ImgModel* img = _msgModel.imgList[2];
            if (![img.imgpath isEqualToString:@""] && img.imgpath) {
                [_iv_img3 setImage:[[UIImage alloc] initWithContentsOfFile:img.imgpath]];
            }
            else
                [_iv_img3 setImageURL:[AppImageUtil getImageURL:img.imagename Size:_iv_img3.frame.size]];
            [_iv_img3 setHidden:NO];
        }
        else
            [_iv_img3 setHidden:YES];
    }
}
// 自绘分割线
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);

    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0xE2 / 255.0f green:0xE2 / 255.0f blue:0xE2 / 255.0f alpha:0.75].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 1, rect.size.width, 1));
}
- (void)initView:(NSInteger)from_type
{
    if (from_type == 1) {
        [_v_jianxi setHidden:YES];
    }
    else {
        [_btn_coment setHidden:YES];
    }
    _iv_Face.delegate = self;
    _iv_Face.layer.cornerRadius = _iv_Face.bounds.size.width / 2;
    _iv_Face.clipsToBounds = YES;
    _iv_Face.tag = 0;

    _iv_img1.delegate = self;
    _iv_img1.tag = 1;
    _iv_img2.delegate = self;
    _iv_img2.tag = 2;
    _iv_img3.delegate = self;
    _iv_img3.tag = 3;

    [_btn_zan.layer setBorderWidth:1.0];
    [_btn_zan.layer setBorderColor:BGViewGray.CGColor];
    _btn_zan.layer.cornerRadius = 5;
    _btn_zan.clipsToBounds = YES;
    [_btn_zan addTarget:self action:@selector(dianZanAction:) forControlEvents:UIControlEventTouchUpInside];

    [_btn_coment.layer setBorderWidth:1.0];
    [_btn_coment.layer setBorderColor:BGViewGray.CGColor];
    _btn_coment.layer.cornerRadius = 5;
    _btn_coment.clipsToBounds = YES;
}

/**
 *  点赞
 *
 *  @param sender <#sender description#>
 */
- (void)dianZanAction:(id)sender
{
    if (_msg_type == 4) {
        //大家聊点赞
        [self requestListMethod];
    }
    else {
        //亲友小区点赞
        [[HomeService shareInstance] priseLifeCircle:1302
                                      life_circle_id:_msgModel.lifeCircleId
                                                type:_msg_type
                                           onSuccess:^(DataModel* dataModel) {
                                               if (dataModel.code == 202) {
                                                   _msgModel.hotNum++;
                                                   [_btn_zan setTitle:[NSString stringWithFormat:@"%ld", (long)_msgModel.hotNum] forState:UIControlStateNormal];
                                                   [_btn_zan setNeedsDisplay];
                                                   [ToastManager showToast:@"点赞成功" withTime:Toast_Hide_TIME];
                                               }
                                               else
                                                   [ToastManager showToast:dataModel.error withTime:Toast_Hide_TIME];

                                           }];
    }
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

#define MSG_IMAGE_INDEX_USER_PHOTO 0
#define MSG_IMAGE_INDEX_CONTEXT_PHOTO1 1
#define MSG_IMAGE_INDEX_CONTEXT_PHOTO2 2
#define MSG_IMAGE_INDEX_CONTEXT_PHOTO3 3
- (void)imageViewDidTouched:(EGOImageView*)imageView
{
    
    switch (imageView.tag) {
    case MSG_IMAGE_INDEX_USER_PHOTO: {
        [messageListner RouteMessage:ACTION_SHOW_PERSON_USERINFO withContext:@{ ACTION_Controller_Name : messageListner, ACTION_Controller_Data : _msgModel.phone }];
        break;
    }
    case MSG_IMAGE_INDEX_CONTEXT_PHOTO1:
        [self showImgs:0];
        break;
    case MSG_IMAGE_INDEX_CONTEXT_PHOTO2:
        [self showImgs:1];
        break;
    case MSG_IMAGE_INDEX_CONTEXT_PHOTO3:
        [self showImgs:2];
        break;
    default:
        break;
    }
}


- (void)showImgs:(NSUInteger)aIndex
{
    [_imgsList removeAllObjects];
    for (int i = 0; i < _msgModel.imgList.count; i++) {
        ImgModel* model = [_msgModel.imgList objectAtIndex:i];
        CXPhoto* photo = [[CXPhoto alloc] initWithURL:[NSURL URLWithString:getOriginalImage(model.imagename)]];

        [_imgsList addObject:photo];
    }

    [self RouteMessage:ACTION_SHOW_SYSTEM_PhotoView
           withContext:@{ ACTION_Controller_Name : messageListner,
               ACTION_Controller_Data : @{ @"index" : [NSString stringWithFormat:@"%ld", (long)aIndex], @"dataSource" : self } }];
}


#pragma mark -
#pragma mark CXPhotoBrowserDataSource
- (NSUInteger)numberOfPhotosInPhotoBrowser:(CXPhotoBrowser*)photoBrowser
{
    return _imgsList.count;
}
- (id<CXPhotoProtocol>)photoBrowser:(CXPhotoBrowser*)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < _imgsList.count)
        return [_imgsList objectAtIndex:index];
    return nil;
}
#pragma mark -
#pragma mark CXPhotoBrowserDelegate
- (void)photoBrowser:(CXPhotoBrowser*)photoBrowser didChangedToPageAtIndex:(NSUInteger)index
{
}

- (void)photoBrowser:(CXPhotoBrowser*)photoBrowser didFinishLoadingWithCurrentImage:(UIImage*)currentImage
{
}

- (BOOL)supportReload
{
    return NO;
}

#pragma mark -
#pragma mark private Method
- (void)requestListMethod
{
    if ([NetManage isNetworkReachable]) {
        request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:praiseTalk]];
        [request buildRequestHeaders];
        [request addPostValue:@([CurrentAccount currentAccount].uid) forKey:@"userId"];
        [request addPostValue:[NSString stringWithFormat:@"%ld", (long)_msgModel.lifeCircleId] forKey:@"talkId"];
        request.delegate = self;
        request.timeOutSeconds = HTTP_TIMEOUT;
        [request setDidFinishSelector:@selector(GetListResult:)];
        [request setDidFailSelector:@selector(GetListErr:)];
        [request startAsynchronous];
    }
    else {
        [ToastManager showToast:Toast_NetWork_Bad withTime:Toast_Hide_TIME];
    }
}
- (void)GetListErr:(ASIHTTPRequest*)request
{
    [ToastManager showToast:Toast_NetWork_Bad withTime:Toast_Hide_TIME];
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate
- (void)GetListResult:(ASIHTTPRequest*)lrequest
{
    NSData* data = [lrequest responseData];
    NSError* error = nil;
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"str=%@", str);
    NSDictionary* totlaDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary* arr = [totlaDic objectForKey:@"o"];
    NSString* result = [arr objectForKey:@"result"];
    if ([@"ok" isEqualToString:result]) {
         _msgModel.hotNum++;
        [_btn_zan setTitle:[NSString stringWithFormat:@"%ld", (long)_msgModel.hotNum] forState:UIControlStateNormal];
        [_btn_zan setNeedsDisplay];
        [ToastManager showToast:@"点赞成功" withTime:Toast_Hide_TIME];
    }
    else if ([@"already" isEqualToString:result]) {
        [ToastManager showToast:@"已经点赞过了，不能再点" withTime:Toast_Hide_TIME];
    }
}

#pragma mark RouteMessage Delegate
IMPLEMENT_MESSAGE_ROUTABLE

@end