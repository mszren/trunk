//
//  MyActivityCell.m
//  FamilysHelper
//
//  Created by hubin on 15/7/23.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//

#import "MyActivityCell.h"


@interface MyActivityCell (){
    
}

@property(nonatomic,strong)EGOImageView* imagUrl;
@property(nonatomic,strong)UILabel* contextLabel;
@property(nonatomic,strong)MyCollectionModel* myCollectionModel;
@property (nonatomic,strong)UIView* titleGroundView;
@end;



@implementation MyActivityCell


@synthesize messageListner;

-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.selected) {
        _titleGroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _contextLabel.backgroundColor = [UIColor clearColor];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView* backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 145)];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        
//        long imagWidth=SCREEN_WIDTH/7;
        _imagUrl = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"pic_default_95x95"]];
        _imagUrl.frame = CGRectMake(0, 0, SCREEN_WIDTH, 145);
        _imagUrl.userInteractionEnabled = YES;
        [backView addSubview:_imagUrl];
        _titleGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, SCREEN_WIDTH, 35)];
        _titleGroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [backView addSubview:_titleGroundView];
        _contextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20,15)];
        _contextLabel.textColor = [UIColor whiteColor];
        _contextLabel.font = [UIFont systemFontOfSize:15];
        _contextLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        [_titleGroundView addSubview:_contextLabel];
        
    }
    return self;
}


- (void)bindData:(MyCollectionModel*)model{
    if(!model){
        return;
    }
    if(model.imageUrl&&![@"" isEqualToString:model.imageUrl]){
        _imagUrl.imageURL=[AppImageUtil getImageURL:model.imageUrl Size:_imagUrl.frame.size];
    }
    _contextLabel.text=model.context;
}

@end
