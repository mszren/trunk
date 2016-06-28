//
//  UUMessageContentButton.h
//  BloodSugarForDoc
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EmojiAndTextView.h"

@interface UUMessageContentButton : UIButton{
    //content
    EmojiAndTextView * _contentText;
}

//bubble imgae
@property (nonatomic, retain) UIImageView *backImageView;

//audio
@property (nonatomic, retain) UIView *voiceBackView;
@property (nonatomic, retain) UILabel *second;
@property (nonatomic, retain) UIImageView *voice;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, assign) BOOL isMyMessage;


//set content
- (void)setContentDataText:(NSString *) contentStr withFrom:(BOOL) isFrom;
- (void)removeContentDataText;


//voice manage
- (void)benginLoadVoice;
- (void)didLoadVoice;
- (void)stopPlay;

@end
