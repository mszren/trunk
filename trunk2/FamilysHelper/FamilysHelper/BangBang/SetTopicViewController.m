//
//  SetTopicViewController.m
//  FamilysHelper
//
//  Created by zhouwengang on 15/7/4.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//

#import "SetTopicViewController.h"
#import "TribeService.h"

@interface SetTopicViewController ()
{
    UIView *bgview1;
    UIButton* btnqiandao;
    NSMutableArray *noAttentionList;
    NSMutableArray *attentionList;
    
    UIView *bgview2;
    UILabel *tipLabel1;
    UILabel *tipLabel2;
    ASIHTTPRequest *_getTagsRequest;
    ASIHTTPRequest *_removeAttentionRequest;
    ASIHTTPRequest *_addAttentionRequest;
}
@property (retain) AOTagList *tag;
@property (retain) AOTagList *tag2;
@property (retain) UILabel  *tipLabel1;
@property (retain) UIButton  *tipLabel;
@end

@implementation SetTopicViewController
- (void)viewwillappear{
   

}
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 14, SCREEN_WIDTH - 160, 17)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"关注话题";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor =[UIColor whiteColor];
    self.navigationItem.titleView = titleLabel ;
    [self.view  setBackgroundColor:AllTableViewColor];
    
    self.tag = [[AOTagList alloc] initWithFrame:CGRectMake(0.0f, 10.0f, SCREEN_WIDTH, 300.0f)];
    self.tag.backgroundColor=[UIColor whiteColor];
    [self.tag setDelegate:self];
    [self.view addSubview:self.tag];
    
    _tipLabel=[[UIButton alloc] init];
    _tipLabel.frame=CGRectMake(0.0f,self.tag.frame.size.height,SCREEN_WIDTH, 20.0f);
    [_tipLabel setTitle:@"点击取消关注" forState:UIControlStateNormal];
    _tipLabel.backgroundColor=[UIColor whiteColor];
    [_tipLabel.titleLabel setTextAlignment:NSTextAlignmentRight];
    _tipLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _tipLabel.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 10);
    [_tipLabel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _tipLabel.titleLabel.font=[UIFont systemFontOfSize:13];
    
    [self.view addSubview:_tipLabel];
    
    _tipLabel1=[[UILabel alloc] init];
    _tipLabel1.frame=CGRectMake(10.0f,_tipLabel.frame.origin.y+40,SCREEN_WIDTH, 20.0f);
    _tipLabel1.text=@"点击关注";
    _tipLabel1.textColor=[UIColor blackColor];
    _tipLabel1.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_tipLabel1];
    
    self.tag2 = [[AOTagList alloc] initWithFrame:CGRectMake(0.0f, 220.0f, SCREEN_WIDTH, 300.0f)];
    self.tag2.backgroundColor=[UIColor whiteColor];
    [self.tag2 setDelegate:self];
    [self.view addSubview:self.tag2];
    
    [self loadData];
    [self resetRandomTagsName];
    
    
}
- (void)resetRandomTagsName
{
    [self.tag removeAllTag];
    [self.tag2 removeAllTag];
    
    }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initView{
    [self resetRandomTagsName];
    [self.tag addTags:attentionList tagstyle:1];
    [self.tag2 addTags:noAttentionList tagstyle:0];
    
}
- (void)loadData
{
    if (_getTagsRequest) {
        [_getTagsRequest cancel];
    }
    _getTagsRequest = [[TribeService shareInstance] getTagsInterByUserID:[CurrentAccount currentAccount].uid  OnSuccess:^(DataModel *dataModel) {
        
        if (dataModel.code==200) {
            NSDictionary *array=dataModel.data;
            [attentionList removeAllObjects];
            [noAttentionList removeAllObjects];

            attentionList=[array objectForKey:@"myattentionList"];
            
            noAttentionList=[array objectForKey:@"mynoAttentionList"];
            
            
            [self initView];
        }else{
            if (dataModel.code != 4) {
                
                [ToastManager showToast:dataModel.error withTime:Toast_Hide_TIME];
            }
            
        }
    }];
}

- (void)removeAttentionTags:(NSInteger) tribeId
{
    if (_removeAttentionRequest) {
        [_removeAttentionRequest cancel];
    }
    _removeAttentionRequest = [[TribeService shareInstance] removeUserAttentionTags:[CurrentAccount currentAccount].uid tagsID:tribeId OnSuccess:^(DataModel *dataModel) {
        
        if (dataModel.code==203) {
            
            [self loadData];
        }else{
            
            if (dataModel.code != 4) {
                
                [ToastManager showToast:dataModel.error withTime:Toast_Hide_TIME];
            }
        }
        
        
    }];
    
}

- (void)addUserAttentionTags:(NSInteger) tribeId
{
    if (_addAttentionRequest) {
        [_addAttentionRequest cancel];
    }
    _addAttentionRequest = [[TribeService shareInstance] addUserAttentionTags:[CurrentAccount currentAccount].uid tagsID:tribeId OnSuccess:^(DataModel *dataModel) {
        
        if (dataModel.code==202) {
            
            [self loadData];
        }else{
            
            [ToastManager showToast:dataModel.error withTime:Toast_Hide_TIME];
        }
        
        
    }];
    
}


#pragma mark - Tag delegate

- (void)tagDidAddTag:(AOTag *)tag
{
    _tipLabel.frame=CGRectMake(0.0f,self.tag.frame.size.height+10,SCREEN_WIDTH, 30.0f);
    _tipLabel1.frame=CGRectMake(10.0f,_tipLabel.frame.origin.y+40,SCREEN_WIDTH, 20.0f);
    self.tag2.frame=CGRectMake(0.0f,_tipLabel1.frame.origin.y+30.0f,SCREEN_WIDTH, self.tag2.frame.size.height);

}



- (void)tagDidSelectTag:(AOTag *)tag
{
    
    if (tag.tagstyle==1) {
        [self removeAttentionTags:tag.tid];
    }else if(tag.tagstyle==0){
        [self addUserAttentionTags:tag.tid];

    }
}
   

@end
