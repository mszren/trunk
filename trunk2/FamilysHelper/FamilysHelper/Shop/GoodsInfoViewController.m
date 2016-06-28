//
//  DetailViewController.m
//  FamilysHelper
//
//  Created by zhouwengang on 15/6/18.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//
#import "GoodsInfoViewController.h"
#import "TribeModel.h"
#import "ShopsService.h"
#import "ShopsService.h"
#import "BuyView.h"
#import "TagModel.h"
#import "TribeService.h"
#import "UIView+Toast.h"
#import "OrderModel.h"
#import "MsgListModel.h"
#import "OrdeViewController.h"
#import "BangIndexController.h"
#import "CXPhotoBrowser.h"

@interface GoodsInfoViewController () <UIScrollViewDelegate, UIWebViewDelegate, EGOImageViewDelegate,CXPhotoBrowserDelegate,CXPhotoBrowserDataSource> {

    EGOImageView* _shopImage;
    float _contentHight;
    BOOL _imageLoad;
    BOOL _webLoad;
}
@property (nonatomic, strong) GoodsModel* goods;

@property (nonatomic, strong) DataModel* dataModel;
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, strong) UIButton* islikeButton;
@property (nonatomic, strong) UILabel* islikeLabel;
@property (nonatomic, strong) BuyView* buyView;
@property (nonatomic, strong) MsgListModel* msglistModel;
@property (nonatomic, strong) EGOImageView* goodsImage;
@property (nonatomic, strong) UIView* backGroundView;
@property (nonatomic, strong) UILabel* descripeLabel;
@property (nonatomic, strong) UILabel* cellLabel;
@property (nonatomic, strong) EGOImageView* shopImage;
@property (nonatomic, strong) UILabel* shopNameLabel;
@property (nonatomic, strong) UILabel* addressLabel;
@property (nonatomic, strong) UIView* shopDetailView;
@property (nonatomic,strong) UILabel *tribeCount;
@property (nonatomic, strong) UIImageView* typeImage;
@property (nonatomic,strong)MBProgressHUD *hud;
@end


@implementation GoodsInfoViewController {
     BOOL iFinishGoods;
     BOOL iFinishBuy;
    ASIHTTPRequest *_goodsRequest;
    ASIHTTPRequest *_buyRequest;
    ASIHTTPRequest *_saveGoodsOrderRequest;
    ASIHTTPRequest *_addCollectRequest;
    ASIHTTPRequest *_likeRefreshRequest;
    ASIHTTPRequest *_addLikeRequest;

    NSMutableArray *_imgsList;
    CXPhotoBrowser *_browser;
}

@synthesize messageListner;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_RED_DEFAULT_BackGround;
    _imageLoad = NO;
    _webLoad = NO;

    [self initView];
    [self loadData:NO];
}

- (void)initView
{

    _browser = [[CXPhotoBrowser alloc]initWithDataSource:self delegate:self];
    _browser.wantsFullScreenLayout = YES;
    _imgsList = [[NSMutableArray alloc]initWithCapacity:0];
    
    _scrollView = [[UIScrollView alloc]
        initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TopBarHeight - 64)];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = YES;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = COLOR_RED_DEFAULT_BackGround;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];

    _buyView = [[BuyView alloc]
        initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TopBarHeight - 64, SCREEN_WIDTH, 44)];
    [_buyView.byButton addTarget:self
                          action:@selector(onBtnBuy:)
                forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_buyView];

    _goodsImage = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"pic_default_320x215"]];
    _goodsImage.delegate = self;
    _goodsImage.tag = 101;
    [_goodsImage setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 215)];
    _goodsImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapImage:)];
    [_goodsImage addGestureRecognizer:tapImage];

    _islikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _islikeButton.frame = CGRectMake(SCREEN_WIDTH - 49, 166, 34, 34);
    [_goodsImage addSubview:_islikeButton];

    [_islikeButton setImage:[UIImage imageNamed:@"ic_like_normal"]
                   forState:UIControlStateNormal];
    [_islikeButton setImage:[UIImage imageNamed:@"ic_like_selected"]
                   forState:UIControlStateSelected];

    [_islikeButton addTarget:self
                      action:@selector(onBtnLike:)
            forControlEvents:UIControlEventTouchUpInside];

    _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 215, SCREEN_WIDTH, 147)];
    _backGroundView.backgroundColor = COLOR_RED_DEFAULT_BackGround;

    // goodsView
    UIView* goodsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 75)];
    goodsView.backgroundColor = [UIColor whiteColor];
    [_backGroundView addSubview:goodsView];

    _descripeLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 39)];
    _descripeLabel.textAlignment = NSTextAlignmentCenter;
    _descripeLabel.font = [UIFont systemFontOfSize:13];
    _descripeLabel.numberOfLines = 0;
    _descripeLabel.textColor = COLOR_GRAY_DEFAULT_30;
    [goodsView addSubview:_descripeLabel];

    //灰线
    UILabel* grayLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH - 20, 1)];
    grayLabel.backgroundColor = COLOR_RED_DEFAULT_BackGround;
    [goodsView addSubview:grayLabel];

    UIImageView* sellImage = [[UIImageView alloc]
        initWithFrame:CGRectMake(SCREEN_WIDTH / 4 - 20, 50, 12, 12)];
    sellImage.image = [UIImage imageNamed:@"ic_sale"];
    [goodsView addSubview:sellImage];

    _cellLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 4, 50, 80, 15)];
    _cellLabel.font = [UIFont systemFontOfSize:12];
    _cellLabel.textColor = COLOR_GRAY_DEFAULT_185;

    [goodsView addSubview:_cellLabel];

    UIImageView* islikeImage = [[UIImageView alloc]
        initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 10, 50, 13, 12)];
    islikeImage.image = [UIImage imageNamed:@"ic_like"];
    [goodsView addSubview:islikeImage];

    _islikeLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 33, 50, 70, 15)];

    _islikeLabel.font = [UIFont systemFontOfSize:12];
    _islikeLabel.textColor = COLOR_GRAY_DEFAULT_185;
    [goodsView addSubview:_islikeLabel];

    UIButton* saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(SCREEN_WIDTH - 50, 47, 40, 20);
    [saveButton setTitle:@"收藏" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:10];
    saveButton.layer.borderWidth = 0.8;
    saveButton.layer.cornerRadius = 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef borderColorRef = CGColorCreate(colorSpace, (CGFloat[]){ 0.9, 0, 0, 1 });
    CGColorSpaceRelease(colorSpace);
    saveButton.layer.borderColor = borderColorRef;
    CGColorRelease(borderColorRef);
    [saveButton setTitleColor:RedColor1 forState:UIControlStateNormal];
    [saveButton addTarget:self
                   action:@selector(onBtnSave:)
         forControlEvents:UIControlEventTouchUpInside];
    [goodsView addSubview:saveButton];

    // shopDetailView
    _shopDetailView =
        [[UIView alloc] initWithFrame:CGRectMake(0, 85, SCREEN_WIDTH, 62)];
    _shopDetailView.backgroundColor = [UIColor whiteColor];
    [_backGroundView addSubview:_shopDetailView];

    _shopDetailView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapShopView =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(onTapShopView:)];
    [_shopDetailView addGestureRecognizer:tapShopView];

    _shopImage = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"pic_default_40x40"]];
    _shopImage.frame = CGRectMake(10, 10, 42, 42);
    _shopImage.layer.cornerRadius = _shopImage.bounds.size.width / 2;
    _shopImage.clipsToBounds = YES;
    [_shopDetailView addSubview:_shopImage];

    _shopNameLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(61, 13, SCREEN_WIDTH - 100, 15)];

    _shopNameLabel.font = [UIFont systemFontOfSize:15];
    _shopNameLabel.textColor = COLOR_GRAY_DEFAULT_30;
    [_shopDetailView addSubview:_shopNameLabel];
    
    _tribeCount = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 13, 60, 15)];
    _tribeCount.font = [UIFont systemFontOfSize:15];
    _tribeCount.textAlignment = NSTextAlignmentRight;
    _tribeCount.textColor = COLOR_GRAY_DEFAULT_122;
    [_shopDetailView addSubview:_tribeCount];

    UIImageView* addressImage =
        [[UIImageView alloc] initWithFrame:CGRectMake(61, 40, 9, 9)];
    addressImage.image = [UIImage imageNamed:@"ic_address"];
    [_shopDetailView addSubview:addressImage];

    _addressLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(75, 36, 100, 15)];
    _addressLabel.font = [UIFont systemFontOfSize:12];
    _addressLabel.textColor = COLOR_GRAY_DEFAULT_122;
    [_shopDetailView addSubview:_addressLabel];

    _typeImage = [[UIImageView alloc] initWithFrame:CGRectMake(200, 40, 9, 9)];
    _typeImage.image = [UIImage imageNamed:@"ic_label"];
    [_shopDetailView addSubview:_typeImage];

    UIImageView* backImage = [[UIImageView alloc]

        initWithFrame:CGRectMake(SCREEN_WIDTH - 17, 28, 7, 11)];
    backImage.image = [UIImage imageNamed:@"ic_arrow"];
    [_shopDetailView addSubview:backImage];

    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 157, SCREEN_WIDTH, 0)];
    _webView.delegate = self;
    [_webView setScalesPageToFit:NO];
    [_webView setUserInteractionEnabled:NO];
}

-(void)loadData:(BOOL)iRefresh{
     _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadGoods:iRefresh];
    [self loadBuy:iRefresh];
}

- (void)loadGoods:(BOOL)iRefresh
{

    if (!iRefresh) {
        _goods = [AppCache loadCache:[NSString stringWithFormat:@"%@%ld", CACHE_SHOP_GOODSINFO, (long)_goodsId]];
    }
    if (_goods && !iRefresh) {
        iFinishGoods = YES;
        [self bindData];
        return;
    }
    
   
    if (_goodsRequest) {
        [_goodsRequest cancel];
    }
    _goodsRequest = [[ShopsService shareInstance] getGoodsInfoV2:_goodsId
                                                          userId:[CurrentAccount currentAccount].uid
                                                       OnSuccess:^(DataModel* dataModel) {
                                                           if (dataModel.code == 200) {
                                                               _dataModel = dataModel;
                                                               _goods = _dataModel.data;
                                                               [AppCache saveCache:[NSString stringWithFormat:@"%@%ld", CACHE_SHOP_GOODSINFO, (long)_goodsId] Data:_goods];
                                                               iFinishGoods = YES;
                                                               [self bindData];
                                                           }

                                                       }];
}

- (void)loadBuy:(BOOL)iRefresh
{
    if (!iRefresh) {
        _msglistModel = [AppCache loadCache:[NSString stringWithFormat:@"%@%ld", CACHE_SHOP_BUY, (long)_goodsId]];
    }
    if (_msglistModel && !iRefresh) {
        iFinishBuy = YES;
        [self bindData];
        return;
    }

    if (_buyRequest) {
        [_buyRequest cancel];
    }
    _buyRequest = [[ShopsService shareInstance] getCouldUseBangBiCountV2:_goodsId
                                                                  userId:[CurrentAccount currentAccount].uid
                                                               onSuccess:^(DataModel* dataModel) {
                                                                   if (dataModel.code == 200) {

                                                                       _msglistModel = dataModel.data;
                                                                       [AppCache saveCache:[NSString stringWithFormat:@"%@%ld", CACHE_SHOP_BUY, (long)_goodsId] Data:_msglistModel];
                                                                       iFinishBuy = YES;
                                                                       [self bindData];
                                                                   }

                                                               }];
}

- (void)bindData
{
    if (iFinishBuy && iFinishGoods) {
        
        _buyView.banBiLabel.text = [NSString stringWithFormat:@"可以使用帮币%.2f", _msglistModel.count];
        float price = _goods.goodsPrice;
        _buyView.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", price];

        [_goodsImage setImageURL:[AppImageUtil getImageURL:_goods.goodsimage Width:_goodsImage.frame.size.width]];

        if (_goods.islike == 0) {
            _islikeButton.selected = NO;
        }
        else {
            _islikeButton.selected = YES;
        }

        _descripeLabel.text = _goods.goodstitle;

        _cellLabel.text =
            [NSString stringWithFormat:@"销售%ld件", (long)_goods.sellnum];

        _islikeLabel.text =
            [NSString stringWithFormat:@"喜欢%ld人", (long)_goods.likeCount];

        [_shopImage setImageURL:[AppImageUtil getImageURL:_goods.shopimage Size:_shopImage.frame.size]];

        _addressLabel.frame = CGRectMake(75, 36, _goods.shopAddress.length * 9, 15);
        _addressLabel.text = _goods.shopAddress;
        _shopNameLabel.text = _shopName;
        _tribeCount.text = [NSString stringWithFormat:@"人数:%ld",(long)_goods.tribeMemberCount];
        

        _typeImage.frame = CGRectMake(_addressLabel.bounds.size.width + 70, 40, 9, 9);
        NSInteger position = 0;
        for (NSInteger i = 0; i < _goods.tags.count; i++) {

            TagModel* tag = [_goods.tags objectAtIndex:i];
            NSString* strTagName = [NSString stringWithFormat:@"#%@#", tag.tagsName];
            CGRect labelRect = [strTagName boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 10) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)attributes:[NSDictionary dictionaryWithObject:FONT_SIZE_14 forKey:NSFontAttributeName] context:nil];

            UILabel* lblTag = [[UILabel alloc] init];
            lblTag.tag = i;
            lblTag.userInteractionEnabled = YES;
            lblTag.frame = CGRectMake(position + _addressLabel.bounds.size.width + 82, 36, labelRect.size.width, 15);
            lblTag.textAlignment = NSTextAlignmentLeft;
            lblTag.text = strTagName;
            lblTag.font = FONT_SIZE_12;
            [lblTag setTextColor:[self getColor:tag.tagsColor]];

            position += lblTag.frame.size.width + 5 - 10;

            [_shopDetailView addSubview:lblTag];
        }

        if (![_goods.goodsIntro isEqualToString:@""]){
            
            ///////////////////////////////设置内容，这里包装一层div，用来获取内容实际高度（像素），htmlcontent是html格式的字符串//////////////
            NSString * htmlcontent = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>", _goods.goodsIntro];
            [_webView loadHTMLString:[self dealHTML:htmlcontent] baseURL:nil];
        }
        else {
            
            _webLoad = YES;
            [self finishLoad];
        }
        
        }
}

- (void)imageViewLoadedImage:(EGOImageView*)imageView
{
    if (imageView.tag == 101) {
        NSInteger height = imageView.image.size.height;
        NSInteger width = imageView.image.size.width;
        NSInteger _imageHight = SCREEN_WIDTH / width * height;
        _goodsImage.frame = CGRectMake(0, 0, SCREEN_WIDTH, _imageHight);
        _islikeButton.frame = CGRectMake(_islikeButton.frame.origin.x, _imageHight - 49, _islikeButton.frame.size.width, _islikeButton.frame.size.height);
        _imageLoad = YES;
        [self finishLoad];
    }
}

- (void)finishLoad
{
    if (_webLoad && _imageLoad) {

        _backGroundView.frame = CGRectMake(0, _goodsImage.frame.size.height, _backGroundView.frame.size.width, _backGroundView.frame.size.height);

        _webView.frame = CGRectMake(0, _backGroundView.frame.origin.y + _backGroundView.frame.size.height + 10, _webView.frame.size.width, _webView.frame.size.height);
        CGSize newsize = CGSizeMake(0, _webView.frame.origin.y + _webView.frame.size.height);
        _scrollView.contentSize = newsize;

        [_scrollView addSubview:_goodsImage];
        [_scrollView addSubview:_backGroundView];
        [_scrollView addSubview:_webView];
         _hud.hidden = YES;

    }
}

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    //获取页面高度（像素）
    float height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    _webView.frame = CGRectMake(0, webView.frame.origin.y, SCREEN_WIDTH, height + 10);
    
    //获取WebView最佳尺寸（点）
    CGSize frame = [_webView sizeThatFits:_webView.frame.size];
    
    //获取内容实际高度（像素）
    float  height_str= [[webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))"] floatValue];
    _webView.frame = CGRectMake(0, webView.frame.origin.y, SCREEN_WIDTH, height_str);
    _webLoad = YES;
    [self finishLoad];
}

//获取宽度已经适配于webView的html。这里的原始html也可以通过js从webView里获取
- (NSString*)dealHTML:(NSString*)html
{

    if (html.length != 0) {

        NSString* strHtml = [html copy];
        NSString* regulaStr = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
        NSError* error;
        //http+:[^\\s]* 这是检测网址的正则表达式
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:regulaStr options:0 error:&error]; //筛选
        NSArray* arrayOfAllMatches = [regex matchesInString:html options:0 range:NSMakeRange(0, [html length])];

        for (NSTextCheckingResult* match in arrayOfAllMatches) {
            NSString* substringForMatch = [html substringWithRange:match.range];
            strHtml = [strHtml stringByReplacingOccurrencesOfString:substringForMatch withString:[NSString stringWithFormat:@"%@@%ldw", substringForMatch, (long)SCREEN_WIDTH]];
        }

        return strHtml;
    }
    else
        return nil;
}

#pragma mark -
#pragma mark EGOImageViewDelegate
- (void)imageViewFailedToLoadImage:(EGOImageView*)imageView error:(NSError*)error
{
    imageView.contentMode = UIViewContentModeScaleAspectFit;
}

#define MSG_IMAGE_INDEX_CONTEXT_PHOTO1 101

- (void)onTapImage:(UITapGestureRecognizer *)sender
{
    switch (sender.view.tag) {
        case MSG_IMAGE_INDEX_CONTEXT_PHOTO1:
            [self showImgs:0];
            break;
 
        default:
            break;
    }
}


- (void)showImgs:(NSUInteger)aIndex
{
    [_imgsList removeAllObjects];
 
        CXPhoto* photo = [[CXPhoto alloc] initWithURL:[NSURL URLWithString:getOriginalImage(_goods.goodsimage)]];
        
        [_imgsList addObject:photo];
    
    
    [_browser setInitialPageIndex:aIndex];
    _browser.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:_browser animated:YES completion:^{
        
    }];
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

#pragma mark
#pragma mark-- UIButtonAction
- (void)onBtnLike:(UIButton*)sender
{

    if (_addLikeRequest) {
        [_addLikeRequest cancel];
    }
    _addLikeRequest = [[ShopsService shareInstance]
        objectAddLikeV2:[CurrentAccount currentAccount].uid
               objectId:_goodsId
                   type:8
              onSuccess:^(DataModel* dataModel) {
                  if (dataModel.code == 202) {

                      [_scrollView makeToast:@"添加喜欢成功" duration:1.5 position:nil];
                      [self LikeRefresh];
                      sender.selected = YES;
                  }
                  else if (dataModel.code == 201) {

                      [_scrollView makeToast:@"删除喜欢成功" duration:1.5 position:nil];
                      [self LikeRefresh];
                      sender.selected = NO;
                  }
                  else {

                      [_scrollView makeToast:dataModel.error duration:1.5 position:nil];
                  }
              }];
}

- (void)LikeRefresh
{
    if (_likeRefreshRequest) {
        [_likeRefreshRequest cancel];
    }
    _likeRefreshRequest = [[ShopsService shareInstance]
        getGoodsInfoV2:_goodsId
                userId:[CurrentAccount currentAccount].uid
             OnSuccess:^(DataModel* dataModel) {

                 _dataModel = dataModel;
                 _goods = _dataModel.data;
            [AppCache saveCache:[NSString stringWithFormat:@"%@%ld", CACHE_SHOP_GOODSINFO, (long)_goodsId] Data:_goods];
                 _islikeLabel.text = [NSString
                     stringWithFormat:@"喜欢%ld人", (long)_goods.likeCount];

             }];
}

- (void)onBtnSave:(UIButton*)sender
{
    if (_addCollectRequest) {
        [_addCollectRequest cancel];
    }
    _addCollectRequest = [[TribeService shareInstance]
        addMyCollect:[CurrentAccount currentAccount].uid
                type:3
            objectId:_goodsId
           OnSuccess:^(DataModel* dataModel) {

               if (dataModel.code == 202) {

                   [ToastManager showToast:@"收藏成功" withTime:Toast_Hide_TIME];
               }
               else {

                   [_scrollView makeToast:dataModel.error duration:1.5 position:nil];
               }
           }];
}

- (void)onBtnBuy:(UIButton*)sender
{

    OrdeViewController* orVc = [[OrdeViewController alloc] init];
    if (_saveGoodsOrderRequest) {
        [_saveGoodsOrderRequest cancel];
    }
    _saveGoodsOrderRequest = [[ShopsService shareInstance] saveGoodsOrderFormInfo:[CurrentAccount currentAccount].uid
                                                 goodsId:_goodsId
                                                  shopId:_shopId
                                               onSuccess:^(DataModel* dataModel) {
                                                   if (dataModel.code == 200) {
                                                       OrderModel* orderModel = dataModel.data;

                                                       orderModel.bangbi = _msglistModel.count;
                                                       orderModel.goods = _goods;
                                                       orderModel.goodsId = _goodsId;
                                                       orderModel.goodsname = _goodsName;
                                                       orderModel.goodsTitle = _goods.goodstitle;
                                                       orderModel.shopname = _shopName;
                                                       
                                                       NSDictionary* dic = @{ ACTION_Controller_Name : messageListner, ACTION_Controller_Data : orderModel };
                                                       [self RouteMessage:ACTION_SHOW_SHOP_ORDER
                                                              withContext:dic];
                                                   }else{
                                                       [ToastManager showToast:dataModel.error withTime:Toast_Hide_TIME];
                                                   }

                                               }];
}

//点击进入商店详情
- (void)onTapShopView:(UITapGestureRecognizer*)sender
{
  
    NSDictionary* dic = [NSDictionary
                         dictionaryWithObjectsAndKeys:messageListner, ACTION_Controller_Name,
                         @{BANGBANG_INDEX_TRIBEID:@(_shopId),BANGBANG_INDEX_SELECTINDEX:@(SELECTSHOP)},
                         ACTION_Controller_Data, nil];
    [messageListner RouteMessage:ACTION_SHOW_BANGBANG_BANGINDEX withContext:dic];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

HEXColor_Method

    @end
