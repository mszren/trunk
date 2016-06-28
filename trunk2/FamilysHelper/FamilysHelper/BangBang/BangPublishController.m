//
//  BangPublishController.m
//  FamilysHelper
//
//  Created by Owen on 15/6/16.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//

#import "BangPublishController.h"
#import "JMStaticContentTableViewSection.h"
#import "JMStaticContentTableViewCell.h"
#import "JMStaticContentTableViewBlocks.h"
#import "PublishAlbumTopView.h"
#import "ZYQAssetPickerController.h"
#import "SelectTagsController.h"
#import "PathHelper.h"
#import "OSSUnity.h"
#import "TribeService.h"
#import "UIView+Toast.h"
#import "TopicModel.h"
#import "ImgModel.h"
#import "UzysAssetsPickerController.h"

@interface BangPublishController () <UzysAssetsPickerControllerDelegate,UITableViewDataSource, UITableViewDelegate, PublishAlbumTopViewDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate > {
    NSArray* staticContentSections;
    NSString* _images;
    NSInteger _tagsID;
    NSString* path;
    NSMutableArray* _arrImgs;
}
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UITextField* txtTitle;
@property (nonatomic, strong) UITextView* tvContent;
@property (nonatomic, strong) UIImageView* ivContentImg;
@property (nonatomic, strong) PublishAlbumTopView* publishAlbumTopView;
@property (nonatomic, strong) UILabel* tagLabel;
@property (nonatomic, strong) UILabel* covertLabel;
@property (nonatomic,strong) NSMutableString* arrResourceURL;
@end

@implementation BangPublishController
@synthesize tribeModel = _tribeModel;
@synthesize messageListner;
- (void)showSelectTagsController
{
    SelectTagsController *selectVc = [[SelectTagsController alloc]init];
    selectVc.tagsList = _tribeModel.tagsList;
    selectVc.blockTagModel = ^(TagModel * model){
        
        _tagLabel.text = model.tagsName;
        _tagsID = model.tagsId;
    };
    [self.navigationController pushViewController:selectVc animated:YES];
    
//    NSDictionary* dic = @{ ACTION_Controller_Name : self, ACTION_Controller_Data : _tribeModel };
//    [self RouteMessage:ACTION_SHOW_BANGBANG_BANGPUBLISH_TAG withContext:dic];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeWhiteBackgroudView:@"发布互动"];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setWhiteNavBg];
 
}

- (void)initView
{
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TopBarHeight - 20)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.backgroundColor = BGViewGray;
    [self.view addSubview:_tableView];

    [self initializeTableView];
    [_tableView reloadData];
}

- (void)initializeTableView
{
    [self removeAllSections];
    __unsafe_unretained BangPublishController* blackController = self;
    [self addSection:^(JMStaticContentTableViewSection* section, NSUInteger sectionIndex) {

        [section addCell:^(JMStaticContentTableViewCell* staticContentCell, UITableViewCell* cell, NSIndexPath* indexPath) {

            staticContentCell.reuseIdentifier = @"BangPublishTitleCell";
            staticContentCell.cellHeight = 45.0f;

            if (!blackController.txtTitle) {
                blackController.txtTitle = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, SCREEN_WIDTH - 100, 20)];
                blackController.txtTitle.text = @"";
                blackController.txtTitle.placeholder = @"请输入标题";
                blackController.txtTitle.textColor = [UIColor darkGrayColor];
                blackController.txtTitle.font = FONT_SIZE(13);
                blackController.txtTitle.delegate = blackController;
                blackController.txtTitle.backgroundColor = [UIColor clearColor];
            }
            [cell addSubview:blackController.txtTitle];

            cell.backgroundColor = [UIColor whiteColor];

        }];

    }];

    [self addSection:^(JMStaticContentTableViewSection* section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell* staticContentCell, UITableViewCell* cell, NSIndexPath* indexPath) {

            staticContentCell.reuseIdentifier = @"BangPublishContentCell";
            staticContentCell.cellHeight = 85.0f;
            if (!blackController.tvContent) {
                blackController.tvContent = [[UITextView alloc] initWithFrame:CGRectMake(5, 10, SCREEN_WIDTH - 20, 50)];
                blackController.tvContent.text = @"";
                blackController.tvContent.textColor = [UIColor darkGrayColor];
                blackController.tvContent.font = FONT_SIZE_14;
                blackController.tvContent.backgroundColor = [UIColor clearColor];
                blackController.covertLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, SCREEN_WIDTH - 20, 15)];
                blackController.covertLabel.text = @"说点什么吧";
                blackController.covertLabel.textColor = COLOR_GRAY_DEFAULT_185;
                blackController.covertLabel.font = [UIFont systemFontOfSize:13];
                [blackController.tvContent addSubview:blackController.covertLabel];
                blackController.tvContent.delegate = blackController;
            }
            [cell addSubview:blackController.tvContent];
            cell.backgroundColor = [UIColor whiteColor];

        }];

    }];
    [self addSection:^(JMStaticContentTableViewSection* section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell* staticContentCell, UITableViewCell* cell, NSIndexPath* indexPath) {

            staticContentCell.reuseIdentifier = @"BangPublishCategoryCell";
            staticContentCell.cellHeight = 40;
            if (!blackController.tagLabel) {
                blackController.tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 15)];
                blackController.tagLabel.text = @"选择标签";
                blackController.tagLabel.textColor = COLOR_GRAY_DEFAULT_OPAQUE_1f;
                blackController.tagLabel.font = [UIFont systemFontOfSize:13];
            }
            [cell addSubview:blackController.tagLabel];
            cell.backgroundColor = [UIColor whiteColor];
        } whenSelected:^(NSIndexPath* indexPath) {

            [blackController showSelectTagsController];
        }];
    }];

    [self addSection:^(JMStaticContentTableViewSection* section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell* staticContentCell, UITableViewCell* cell, NSIndexPath* indexPath) {

            staticContentCell.reuseIdentifier = @"BangPublishImageCell";
            staticContentCell.cellHeight = PublishImageTileHeight + 40;
            if (!blackController.publishAlbumTopView) {

                blackController.publishAlbumTopView = [[PublishAlbumTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, PublishImageTileHeight + 40)];
                blackController.publishAlbumTopView.delegate = blackController;
                blackController.publishAlbumTopView.imageMaxCount = 1;
                blackController.view.backgroundColor = [UIColor redColor];
                [blackController.publishAlbumTopView setViewDefault];
            }
            [cell addSubview:blackController.publishAlbumTopView];
            cell.backgroundColor = [UIColor whiteColor];

        }];

    }];
}


- (void)rightItemAction:(id)sender
{

    if ([_txtTitle.text isEqualToString:@""] | [_txtTitle.text isEqualToString:@"请输入标题"]) {


        [ToastManager showToast:@"请输入标题" withTime:Toast_Hide_TIME];
        return;
    }
    else if ([_tvContent.text isEqualToString:@""]) {

 
        [ToastManager showToast:@"请输入内容" withTime:Toast_Hide_TIME];
        return;
    }
    else if ([_tagLabel.text isEqualToString:@"选择标签"]) {

        [ToastManager showToast:@"选择标签" withTime:Toast_Hide_TIME];
        return;
    }
    else if (_publishAlbumTopView.dataList.count == 0){
        
        [ToastManager showToast:@"请选择照片" withTime:Toast_Hide_TIME];
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
    }

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [[OSSUnity shareInstance] uploadFiles:_arrImgs
                            withTargetSubPath:OSSMessagePath
                                    withBlock:^(NSArray* arrStatus) {
                                       _arrResourceURL = [[NSMutableString alloc] initWithCapacity:0];
                                        for (int i = 0; i < _arrImgs.count; i++) {
                                            ImgModel* model = _arrImgs[i];
                                            [_arrResourceURL appendFormat:@"%@|%ld", model.imagename, (long)model.sort];
                                        }
                                        _images = [NSString stringWithString:_arrResourceURL];

                                        [[TribeService shareInstance] publishTopicWith:_txtTitle.text
                                                                               tribeId:_tribeModel.shopId
                                                                                typeId:1
                                                                                  oper:[CurrentAccount currentAccount].uid
                                                                                   tag:[NSString stringWithFormat:@"%ld", (long)_tagsID]
                                                                                images:_images
                                                                           contentInfo:_tvContent.text
                                                                             OnSuccess:^(DataModel* dataModel) {
                                                                                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
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
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)RouteMessage{
    TopicModel *topicModel = [[TopicModel alloc]init];
    topicModel.isTop = 0;
    topicModel.isEssence = 0;
    topicModel.topic = _txtTitle.text;
    topicModel.contentInfo = _tvContent.text;
    topicModel.face = [CurrentAccount currentAccount].face;
    topicModel.hitNum = 0;
    topicModel.replyNum = 0;
    topicModel.createTime = [NSDate currentTimeByJava];
    [messageListner RouteMessage:NOTIFICATION_BANG_PUBLISH withContext:@{ NOTIFICATION_DATA : topicModel }];
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
    
    [self presentViewController:picker
                       animated:YES
                     completion:^{
                         
                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Static Content
- (void)removeAllSections
{
    if (staticContentSections) {
        staticContentSections = nil;
        staticContentSections = [NSArray array];
    }
}
- (void)addSection:(JMStaticContentTableViewControllerAddSectionBlock)b
{
    if (!staticContentSections)
        staticContentSections = [NSArray array];

    JMStaticContentTableViewSection* section = [[JMStaticContentTableViewSection alloc] init];
    section.tableView = _tableView;

    b(section, [staticContentSections count] + 1);

    staticContentSections = [staticContentSections arrayByAddingObject:section];
}

#pragma mark -
#pragma mark Tableview Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return staticContentSections.count;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    JMStaticContentTableViewSection* sectionContent = [staticContentSections objectAtIndex:section];
    return sectionContent.staticContentCells.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    JMStaticContentTableViewSection* sectionContent = [staticContentSections objectAtIndex:indexPath.section];
    JMStaticContentTableViewCell* cellContent = [sectionContent.staticContentCells objectAtIndex:indexPath.row];

    return cellContent.cellHeight;
}

- (UITableViewCell*)tableView:(UITableView*)ltableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    JMStaticContentTableViewSection* sectionContent = [staticContentSections objectAtIndex:indexPath.section];
    JMStaticContentTableViewCell* cellContent = [sectionContent.staticContentCells objectAtIndex:indexPath.row];

    UITableViewCell* cell = [ltableView dequeueReusableCellWithIdentifier:cellContent.reuseIdentifier];
    if (cell == nil) {
        cell = [[[cellContent tableViewCellSubclass] alloc] initWithStyle:cellContent.cellStyle reuseIdentifier:cellContent.reuseIdentifier];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.imageView.image = nil;
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;

    cellContent.configureBlock(nil, cell, indexPath);
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView*)ltableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (!ltableView.editing && !ltableView.allowsMultipleSelection)
        [ltableView deselectRowAtIndexPath:indexPath animated:YES];
    if (ltableView.editing && !ltableView.allowsMultipleSelectionDuringEditing)
        [ltableView deselectRowAtIndexPath:indexPath animated:YES];

    JMStaticContentTableViewSection* sectionContent = [staticContentSections objectAtIndex:indexPath.section];
    JMStaticContentTableViewCell* cellContent = [sectionContent.staticContentCells objectAtIndex:indexPath.row];

    if (cellContent.whenSelectedBlock) {
        cellContent.whenSelectedBlock(indexPath);
    }
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
#pragma mark-- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{

    [_txtTitle resignFirstResponder];
    return YES;
}

#pragma mark
#pragma mark-- UITextViewDelegate

- (void)textViewDidChange:(UITextView*)textView
{
    _tvContent.text = textView.text;
    if (_tvContent.text.length == 0) {
        _covertLabel.text = @"说点什么吧";
    }
    else {
        _covertLabel.text = @"";
    }
}

- (void)textViewDidBeginEditing:(UITextView*)textView
{
    _tvContent = textView;
}

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {

        [_tvContent resignFirstResponder];
        return NO;
    }

    return YES;
}

@end
