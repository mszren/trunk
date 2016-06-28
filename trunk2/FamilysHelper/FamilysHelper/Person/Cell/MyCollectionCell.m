//
//  MyCollectionCell.m
//  FamilysHelper
//
//  Created by hubin on 15/7/22.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//

#import "MyCollectionCell.h"
#import "MyCollectionModel.h"
@interface MyCollectionCell (){
    
}

@property(nonatomic,strong)EGOImageView* imagUrl;
@property(nonatomic,strong)UILabel* contextLabel;
@property(nonatomic,strong)MyCollectionModel* myCollectionModel;
@end;

@implementation MyCollectionCell


@synthesize messageListner;

 
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView* backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 75)];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        
        _imagUrl = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"pic_default_60x60"]];
        _imagUrl.frame = CGRectMake(10, 10, 55, 55);
        _imagUrl.userInteractionEnabled = YES;
        [backView addSubview:_imagUrl];
        _contextLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 33, SCREEN_WIDTH - 115,11)];
        _contextLabel.textColor = [UIColor blackColor];
        _contextLabel.font = [UIFont systemFontOfSize:11];
        _contextLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        [backView addSubview:_contextLabel];
        
    }
    return self;
}


- (void)bindData:(MyCollectionModel*)model{
    if(!model){
        return;
    }
    _myCollectionModel=model;
    if(_myCollectionModel.imageUrl&&![@"" isEqualToString: _myCollectionModel.imageUrl]){
        _imagUrl.imageURL=[AppImageUtil getImageURL:_myCollectionModel.imageUrl Size:_imagUrl.frame.size];
    }
    _contextLabel.text=_myCollectionModel.context;
}
@end