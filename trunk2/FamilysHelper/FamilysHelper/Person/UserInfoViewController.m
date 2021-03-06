//
//  UserInfoViewController.m
//  WeShare
//
//  Created by Elliott on 13-5-16.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//

#import "UserInfoViewController.h"
#import "TheEditController.h"
#import "MyDatePicker.h"
#import "SystemService.h"
#import "CityModel.h"
#import "CommunityModel.h"
#import "ChatDetailController.h"
#import "UzysAssetsPickerController.h"
#import "ImgModel.h"
#import "OSSUnity.h"
#import "SystemService.h"

@interface UserInfoViewController () <MyDatePickerDelegate, UIActionSheetDelegate,UzysAssetsPickerControllerDelegate> {
    MyDatePicker* _datePicker;
    ASIFormDataRequest* request;
    NSMutableArray* _arrImgs;
    NSMutableArray* _setArrImgs;
    
    NSMutableArray *_imgsList;
    CXPhotoBrowser *_browser;
    
    ASIHTTPRequest *_addRequest;

}
@property (nonatomic, strong) DataModel* dataModel;
@property (nonatomic, strong) DataModel* citydataModel;
@property (nonatomic, strong) NSArray* citylist;
@property (nonatomic, strong) NSArray* communitylist;
@property (nonatomic, assign) BOOL ISMyself;
@property (nonatomic, strong) NSString* newsCityId;
@property (nonatomic, strong) NSString* newsCommunityId;


@end

@implementation UserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setWhiteNavBg];
    [self initializeWhiteBackgroudView:@"个人资料"];
    
    _browser = [[CXPhotoBrowser alloc]initWithDataSource:self delegate:self];
    _browser.wantsFullScreenLayout = YES;
    
    _imgsList = [[NSMutableArray alloc]initWithCapacity:0];
    _arrImgs=[[NSMutableArray alloc] initWithCapacity:0];
    _setArrImgs=[[NSMutableArray alloc] initWithCapacity:0];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction:)];

    self.view.backgroundColor = COLOR_VIEW_BG;
    [_iv_Face setImage:[UIImage imageNamed:@"pic_default_60x60"]];
    _iv_Face.delegate = self;
    _iv_Face.userInteractionEnabled = YES;
    _iv_Face.tag = 1;
    
    UIButton* touchButton = [[UIButton alloc] initWithFrame:_iv_Face.bounds];
    touchButton.showsTouchWhenHighlighted = YES;
    [touchButton addTarget:self action:@selector(face_btn:) forControlEvents:UIControlEventTouchUpInside];
    [_iv_Face addSubview:touchButton];

    _bt_button.layer.cornerRadius = 5;
    _bt_button.clipsToBounds = YES;
    UITapGestureRecognizer* nicknameGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ac_nickname:)];
    [self.lb_nickname addGestureRecognizer:nicknameGesture];
    [_but_sex addTarget:self action:@selector(ac_sex:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer* birthdayGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ac_birthday:)];
    [self.lb_birthday addGestureRecognizer:birthdayGesture];

    UITapGestureRecognizer* cityGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ac_city:)];
    [self.lb_city addGestureRecognizer:cityGesture];
    UITapGestureRecognizer* commitityGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ac_commitity:)];
    [self.lb_commitity addGestureRecognizer:commitityGesture];

    UITapGestureRecognizer* addrGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ac_addr:)];
    [self.lb_addr addGestureRecognizer:addrGesture];

    UITapGestureRecognizer* signGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ac_sign:)];
    [self.lb_sign addGestureRecognizer:signGesture];

    if ([_phone isEqual:[CurrentAccount currentAccount].telNumber]) {
        self.navigationItem.rightBarButtonItem = rightItem;
        _bt_button.hidden = YES;
        _ISMyself = YES;
    }

    if (_userId == 0) {
        _userId = [CurrentAccount currentAccount].uid;
    }
    [self loadData:NO];
    [self getcityData];
    [self getcommunityData];
}
#pragma mark
#pragma mark-- nav item action
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)rightItemAction:(id)sender
{
    [self saveData];
}
- (void)ac_nickname:(id)sender
{
    if (_ISMyself) {
        
        NSDictionary *dictionary =[NSDictionary dictionaryWithObjectsAndKeys:@"nickname",@"flag",_lb_nickname.text,@"oldText",nil];
        NSDictionary* dic = @{ ACTION_Controller_Name : self, ACTION_Controller_Data : dictionary};
        
        [self RouteMessage:
         ACTION_SHOW_PERSON_EDITCENTER
               withContext:dic];
    }
}

- (void)ac_sex:(id)sender
{
    if (_ISMyself) {
        UIActionSheet* actionSheet = [[UIActionSheet alloc]
                     initWithTitle:@"请选择性别"
                          delegate:self
                 cancelButtonTitle:@"取消"
            destructiveButtonTitle:nil
                 otherButtonTitles:@"男", @"女", nil];
        actionSheet.tag = 1;
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
    }
}
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if (_ISMyself) {
        [_datePicker popDatePicker];
    }
}
//回调，字符串可自行进行截取
- (void)MyDatePickerDidConfirm:(NSString*)confirmString
{
    _lb_birthday.text = confirmString;
    NSDate* aDate = [self datefromstring:_lb_birthday.text];
    self.lb_age.text = [NSString stringWithFormat:@"%ld", (long)[self ageWithDateOfBirth:aDate]];
}
- (void)ac_birthday:(id)sender
{
    if (_ISMyself) {

        _datePicker = [[MyDatePicker alloc] initWithSelectTitle:@"选择日期" NSDate:[self datefromstring:_lb_birthday.text] viewOfDelegate:self.view delegate:self];

        _datePicker.isBeforeTime = YES; //(是否可选择以前时间)

        _datePicker.theTypeOfDatePicker = 1; //(datePicker显示类别，只写了三种主流)
        [_datePicker pushDatePicker];
    }
}
- (void)ac_city:(id)sender
{
    if (_ISMyself) {
        UIActionSheet* actionSheet = [[UIActionSheet alloc]
                     initWithTitle:@"请选择城市"
                          delegate:self
                 cancelButtonTitle:@"取消"
            destructiveButtonTitle:nil
                 otherButtonTitles:nil];
        if(_citylist){
            for (CityModel* cityModel in _citylist) {
               [actionSheet addButtonWithTitle:cityModel.cityName];
            }
        }
        
        actionSheet.tag = 2;
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        //actionSheet.cancelButtonIndex=_citylist.count;
        [actionSheet showInView:self.view];
    }
}
- (void)ac_commitity:(id)sender
{
    if (_ISMyself) {
        UIActionSheet* actionSheet = [[UIActionSheet alloc]
                     initWithTitle:@"请选择城市"
                          delegate:self
                 cancelButtonTitle:@"取消"
            destructiveButtonTitle:nil
                 otherButtonTitles:nil];
        if(_communitylist){
            for(CommunityModel* communityModel in _communitylist){
                [actionSheet addButtonWithTitle:communityModel.communityName];
            }
        }
        actionSheet.tag = 3;
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
    }
}
- (void)ac_addr:(id)sender
{
    if (_ISMyself) {
        NSDictionary *dictionary =[NSDictionary dictionaryWithObjectsAndKeys:@"addr",@"flag",_lb_addr.text,@"oldText",nil];
        NSDictionary* dic = @{ ACTION_Controller_Name : self, ACTION_Controller_Data : dictionary};
        
        [self RouteMessage:ACTION_SHOW_PERSON_EDITCENTER
               withContext:dic];
    }
}
- (void)ac_sign:(id)sender
{
    if (_ISMyself) {
        NSDictionary *dictionary =[NSDictionary dictionaryWithObjectsAndKeys:@"sign",@"flag",_lb_sign.text,@"oldText",nil];
        NSDictionary* dic = @{ ACTION_Controller_Name : self, ACTION_Controller_Data : dictionary};
        
        [self RouteMessage:ACTION_SHOW_PERSON_EDITCENTER
               withContext:dic];
    }
}

//string转日期
- (NSDate*)datefromstring:(NSString*)astring;
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* aDate = [dateFormatter dateFromString:astring];
    return aDate;
}

//计算年龄
- (NSInteger)ageWithDateOfBirth:(NSDate*)date;
{

    // 出生日期转换 年月日
    NSDateComponents* components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSInteger brithDateYear = [components1 year];
    NSInteger brithDateDay = [components1 day];
    NSInteger brithDateMonth = [components1 month];

    // 获取系统当前 年月日
    NSDateComponents* components2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentDateYear = [components2 year];
    NSInteger currentDateDay = [components2 day];
    NSInteger currentDateMonth = [components2 month];

    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }

    return iAge;
}
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    {
        if (actionSheet.tag == 1) {
            if (buttonIndex == 0) {
                [_but_sex setBackgroundImage:[UIImage imageNamed:@"man.png"] forState:UIControlStateNormal];
                _sex = @"男";
            }
            else if (buttonIndex == 1) {
                [_but_sex setBackgroundImage:[UIImage imageNamed:@"weman.png"] forState:UIControlStateNormal];
                _sex = @"女";
            }
        }
        else if (actionSheet.tag == 2) {
            if(buttonIndex!=0){
                CityModel* cityModel=(CityModel*)_citylist[buttonIndex-1];
                _lb_city.text = cityModel.cityName;
                _newsCityId=[NSString stringWithFormat:@"%ld",(long)cityModel.cityId];
            }
        }
        else if (actionSheet.tag == 3) {
            if(buttonIndex!=0){
                CommunityModel* communityModel=(CommunityModel*)_communitylist[buttonIndex-1];
                _lb_commitity.text=communityModel.communityName;
                _newsCommunityId=[NSString stringWithFormat:@"%ld",(long)communityModel.communityId];
            }
        }
    }
}

- (void)bt_buttonAction:(id)sender
{
    if (_bt_button.tag == 1) {
        ChatDetailController* controller = [[ChatDetailController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        controller.currentUserModel = [_user copy];
        controller.currentUserModel.isF = 1;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (_bt_button.tag == 0) {
        
        if (_addRequest) {
            
            [_addRequest cancel];
        }
        _addRequest = [[SystemService shareInstance] addFamilyNew:[CurrentAccount currentAccount].uid num:_phone onSuccess:^(DataModel *dataModel) {
            if (dataModel.code == 202) {
                
                [ToastManager showToast:@"申请添加好友成功" withTime:Toast_Hide_TIME];
            }else
                [ToastManager showToast:dataModel.error withTime:Toast_Hide_TIME];
                }];
    }
}
- (void)initview
{
    self.iv_Face.layer.cornerRadius = self.iv_Face.bounds.size.width / 2;
    self.iv_Face.clipsToBounds = YES;
    if (_user.face == nil || [@"" isEqualToString:_user.face]) {
        [self.iv_Face setImage:[UIImage imageNamed:@"ic_face"]];
    }
    else {
        [self.iv_Face setImageURL:[AppImageUtil getImageURL:_user.face Size:self.iv_Face.frame.size]];
    }

    self.lb_birthday.text = [NSDate dateYMDTimeInterval:_user.birthday.doubleValue];
    NSDate* aDate = [self datefromstring:_lb_birthday.text];
    self.lb_age.text = [NSString stringWithFormat:@"%ld", (long)[self ageWithDateOfBirth:aDate]];
    if (_nickname == nil) {
        self.lb_nickname.text = _user.nickname;
    }
    else {
        self.lb_nickname.text = _nickname;
    }
    if (_address == nil) {
        self.lb_addr.text = _user.address;
    }
    else {
        self.lb_addr.text = _address;
    }
    if (_signature == nil) {
        self.lb_sign.text = _user.signature;
    }
    else {
        self.lb_sign.text = _signature;
    }

    if ([@"男" isEqualToString:_user.sex]) {
        [_but_sex setBackgroundImage:[UIImage imageNamed:@"man.png"] forState:UIControlStateNormal];
        _sex = @"男";
    }
    else {
        [_but_sex setBackgroundImage:[UIImage imageNamed:@"weman.png"] forState:UIControlStateNormal];
        _sex = @"女";
    }
    if (_citylist.count > 0) {

        for (int i = 0; i < _citylist.count; i++) {
            CityModel* City = [_citylist objectAtIndex:i];
            NSString* str = [NSString stringWithFormat:@"%ld", (long)City.cityId];
            NSString* string = [NSString stringWithFormat:@"%@", _user.cityId];
            if ([str isEqual:string]) {
                self.lb_city.text = City.cityName;
                i = _citylist.count + 1;
            }
        }
    }

    if (_communitylist.count > 0) {

        for (int i = 0; i < _communitylist.count; i++) {
            CommunityModel* Community =[_communitylist objectAtIndex:i];
            NSString* str = [NSString stringWithFormat:@"%ld", (long)Community.communityId];
            NSString* string = [NSString stringWithFormat:@"%@", _user.communityId];
            if ([str isEqual:string]) {
                self.lb_commitity.text = Community.communityName;
                i = _communitylist.count + 1;
            }
        }
    }
    [_bt_button addTarget:self action:@selector(bt_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    if (_user.isF == 1) {
        _bt_button.tag = 1;
        [_bt_button setTitle:@"发送消息" forState:UIControlStateNormal];
    }
    else if (_user.isF == 0) {
        _bt_button.tag = 0;
        [_bt_button setTitle:@"加为好友" forState:UIControlStateNormal];
    }
}
- (void)loadData:(BOOL)isRefresh
{
    [[SystemService shareInstance] getUserInfoNew:_userId
                                              uid:_phone
                                        onSuccess:^(DataModel* dataModel) {
                                            if (dataModel.code == 200) {

                                                _dataModel = dataModel;
                                                _user = _dataModel.data;
                                                if(isRefresh){
                                                    [self setRouteMessage];
                                                }
                                                [self initview];
                                            }
                                            else if(dataModel.code != 200 && dataModel.code != 20000){
                                                [ToastManager showToast:dataModel.error withTime:Toast_Hide_TIME];
                                            }

                                        }];
}
- (void)getcityData
{
    [[SystemService shareInstance] getNewAllCityInfo:^(DataModel* dataModel) {
        if (dataModel.code == 200) {

            _citylist = dataModel.data;
        }

        else {
            [ToastManager showToast:dataModel.error withTime:Toast_Hide_TIME];
        }
        //[self loadData];
    }];
}
- (void)getcommunityData
{
    [[SystemService shareInstance] getNewAllcommunityInfo:^(DataModel* dataModel) {
        if (dataModel.code == 200) {

            _communitylist = dataModel.data;
        }
        else {
            [ToastManager showToast:dataModel.error withTime:Toast_Hide_TIME];
        }

    }];
}
- (void)saveData
{
    if(_arrImgs.count>0){
        ALAsset* asset = _arrImgs[0];
        UIImage* tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        NSData* editImageData = UIImageJPEGRepresentation(tempImg, 0.8f);
        
        NSString* name = [NSString stringWithFormat:@"%@.jpg", [NSDate currentTimeByJava]];
        NSString* path = [[PathHelper cacheDirectoryPathWithName:MSG_Img_Dir_Name] stringByAppendingPathComponent:name];
        [editImageData writeToFile:path atomically:YES];
        ImgModel* model = [[ImgModel alloc] init];
        model.sort = 0;
        model.imgpath = path;
        [_setArrImgs addObject:model];

    }
    _nickname = self.lb_nickname.text;
    _birthday = self.lb_birthday.text;
    _face = @"";
    _cityId = _newsCityId;

    _signature = self.lb_sign.text;
    _address = self.lb_addr.text;

    if(_setArrImgs.count>0){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [[OSSUnity shareInstance] uploadFiles:_setArrImgs
                            withTargetSubPath:OSSMessagePath
                                    withBlock:^(NSArray* arrStatus) {
                                            ImgModel* model = _setArrImgs[0];
                                            _face=model.imagename;
                                        [[SystemService shareInstance] completePersonInfoNew:[CurrentAccount currentAccount].uid
                                                                                    nickname:_nickname
                                                                                    birthday:_birthday
                                                                                         sex:_sex
                                                                                        face:_face
                                                                                      cityId:_cityId
                                                                                 communityId:_communityId
                                                                                   signature:_signature
                                                                                     address:_address
                                                                                   onSuccess:^(DataModel* dataModel) {
                                                                                       if (dataModel.code == 200) {
                                                                                           [ToastManager showToast:@"保存成功" withTime:Toast_Hide_TIME];
                                                                                           [self loadData:YES];
                                                                                       }
                                                                                       else {
                                                                                           [ToastManager showToast:dataModel.error withTime:Toast_Hide_TIME];
                                                                                       }

                                                                                   }];
                                    }];
    }else{
        [[SystemService shareInstance] completePersonInfoNew:[CurrentAccount currentAccount].uid
                                                    nickname:_nickname
                                                    birthday:_birthday
                                                         sex:_sex
                                                        face:_face
                                                      cityId:_cityId
                                                 communityId:_communityId
                                                   signature:_signature
                                                     address:_address
                                                   onSuccess:^(DataModel* dataModel) {
                                                       if (dataModel.code == 200) {
                                                           [ToastManager showToast:@"保存成功" withTime:Toast_Hide_TIME];
                                                           [self loadData:YES];
                                                       }
                                                       else {
                                                           [ToastManager showToast:dataModel.error withTime:Toast_Hide_TIME];
                                                       }

                                                   }];
    }
}
//路由调用刷新
- (void)setRouteMessage
{
    User *user = _user;
    [self RouteMessage:NOTIFICATION_PERSON_USER withContext:@{ NOTIFICATION_DATA : user }];
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

#define MSG_IMAGE_INDEX_CONTEXT_PHOTO1 1
- (void)imageViewDidTouched:(EGOImageView*)imageView
{
    switch (imageView.tag) {
        case MSG_IMAGE_INDEX_CONTEXT_PHOTO1:
            [self showImgs:0];
        default:
            break;
    }
}


- (void)showImgs:(NSUInteger)aIndex
{
    [_imgsList removeAllObjects];
 
        CXPhoto* photo = [[CXPhoto alloc] initWithURL:[NSURL URLWithString:getOriginalImage(_user.face)]];
        
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

- (void)face_btn:(id)sender
{
    if (_ISMyself) {
        [ToastManager showToast:@"更新头像" withTime:Toast_Hide_TIME];
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
        
        [self presentViewController:picker
                           animated:YES
                         completion:nil];


    }
    else {
        [ToastManager showToast:@"查看头像" withTime:Toast_Hide_TIME];
    }
}
#pragma mark RouteMessage Delegate
- (void)RouteMessage:(NSString*)message withContext:(id)context
{
    if ([message isEqualToString:NOTIFICATION_PERSON_NOTICE]) {
        NSDictionary* dic = context;
        NSMutableDictionary *nsMutableDictionary=[dic objectForKey:NOTIFICATION_DATA];
        NSString* myFlag=[nsMutableDictionary objectForKey:@"flag"];
            if ([myFlag isEqual:@"nickname"]) {
                _lb_nickname.text=[nsMutableDictionary objectForKey:@"editText"];
            }else if([myFlag isEqual:@"sign"]){
                _lb_sign.text=[nsMutableDictionary objectForKey:@"editText"];
            }else if([myFlag isEqual:@"addr"]){
               _lb_addr.text=[nsMutableDictionary objectForKey:@"editText"];
            }
        }
    else {
        [self.messageListner RouteMessage:message withContext:context];
    }
}

#pragma mark - UzysAssetsPickerControllerDelegate methods
- (void)uzysAssetsPickerController:(UzysAssetsPickerController*)picker didFinishPickingAssets:(NSArray*)assets
{
    
    if ([[assets[0] valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]) //Photo
    {
        UIImage * tempImg = [UIImage imageWithCGImage:((ALAsset*)assets[0]).defaultRepresentation.fullScreenImage];
        _iv_Face.image=tempImg;
        [_arrImgs removeAllObjects];
        [_arrImgs addObjectsFromArray:assets];
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

@end
