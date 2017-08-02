//
//  FNRightCollectionCell.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/15.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNRightCollectionCell.h"
#import "FNMacro.h"

#import "View+MASAdditions.h"

@interface FNRightCollectionCell ()

@end
@implementation FNRightCollectionCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (self.nameImageView==nil)
        {
            self.nameImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,(kScreenWidth - 120)/3  , (kScreenWidth -120)/3)];
            
            self.nameImageView.contentMode=UIViewContentModeScaleAspectFill;
            
            self.nameImageView.clipsToBounds = YES;
            
            self.nameImageView.layer.masksToBounds = YES;
            
            self.nameImageView.layer.cornerRadius = 2.0;
            
            [self.contentView addSubview:self.nameImageView];
        }
        
        if (self.nameLabel==nil)
        {
            
            self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, (kScreenWidth - 120)/3-5,(kScreenWidth - 120)/3 , 30)];
            
            self.nameLabel.font=[UIFont systemFontOfSize:12];
    
            self.nameLabel.numberOfLines = 2;
            
            self.nameLabel.textAlignment=NSTextAlignmentCenter;

            [self.contentView addSubview:self.nameLabel];
        
        }
    }
    return self;
}

-(void)setCurHeadRightModel:(FNHeadRightModel *)curHeadRightModel
{
    _curHeadRightModel=curHeadRightModel;
    
    self.nameImageView.image=[UIImage imageNamed:_curHeadRightModel.img_key];
    
    self.nameLabel.text=_curHeadRightModel.subjectName;
}

@end
