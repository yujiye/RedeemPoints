//
//  FNButton.m
//  BonusStore
//
//  Created by Nemo on 16/4/19.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNButton.h"

@implementation FNButton

+ (instancetype)buttonWithType:(FNButtonType)type title:(NSString *)title
{
    FNButton *but = [FNButton buttonWithType:UIButtonTypeCustom];//(FNButton *)[UIButton buttonWithType:UIButtonTypeCustom];
    
    [but setTitle:title forState:UIControlStateNormal];
    
    [but setType:type];
    
    return but;
}

- (void)setType:(FNButtonType)type
{
    switch (type)
    {
        case FNButtonTypePlain:
            self.layer.borderColor = [MAIN_COLOR_RED_BUTTON CGColor];
            
            self.layer.borderWidth = 1;

            self.backgroundColor = MAIN_COLOR_RED_BUTTON;
            
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            break;
            
        case FNButtonTypeOpposite:
            
            self.layer.borderColor = [MAIN_BACKGROUND_COLOR CGColor];
            
            self.layer.borderWidth = 1;

            self.backgroundColor = MAIN_BACKGROUND_COLOR;
            
            [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            break;
            
        case FNButtonTypeEdge:
            
            self.layer.borderColor = [MAIN_COLOR_RED_BUTTON CGColor];
            
            self.layer.borderWidth = 1;
            
            self.backgroundColor = [UIColor whiteColor];
            
            [self setTitleColor:MAIN_COLOR_RED_BUTTON forState:UIControlStateNormal];
            
            break;
            
        default:
            break;
    }
}

@end
