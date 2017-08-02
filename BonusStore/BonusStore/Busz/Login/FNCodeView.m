//
//  FNCodeView.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNCodeView.h"
#import "FNLoginBO.h"

@interface FNCodeView ()
{
    __block UIImage *_captcha;
}

@end

@implementation FNCodeView

@synthesize changeArray = _changeArray;
@synthesize changeString = _changeString;
@synthesize coldeLabel = _coldeLabel;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        self.backgroundColor = UIColorWithRGB(192, 192, 192);
        
        [self addTarget:self action:@selector(getCaptcha)];
        
        [self getCaptcha];
        
    }
    return self;
}

- (void)getCaptcha
{
    self.random = arc4random()%1000;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"graphCodeChanged" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%lu",self.random],@"graphCodeChanged", nil]];
    NSString *url = nil;
#if TARGET_DEV
     url = [NSString stringWithFormat:@"%@:18002/buyer/buyer/getCaptcha?id=%lu",URL_BASE,(unsigned long)self.random];
#else
   url = [NSString stringWithFormat:@"%@/buyer/buyer/getCaptcha?id=%lu",URL_BASE,(unsigned long)self.random];
#endif
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
}

- (void)change
{
    self.changeArray = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",nil];
    
    NSMutableString *getStr = [[NSMutableString alloc] initWithCapacity:2];
    
    self.changeString = [[NSMutableString alloc]initWithCapacity:6];
    for (NSInteger i = 0; i < 4; i ++) {
        NSInteger index = arc4random() % ([self.changeArray count] - 1);
        getStr = [self.changeArray objectAtIndex:index];
        
        self.changeString = (NSMutableString *)[self.changeString stringByAppendingString:getStr];
    
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    float red = arc4random() % 100 / 100.0;
    float green = arc4random() % 100 / 100.0;
    float blue = arc4random() % 100 / 100.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    [self setBackgroundColor:color];
    
    NSString *text = [NSString stringWithFormat:@"%@",self.changeString];

    CGSize cSize = [@"S" sizeWithFont:[UIFont systemFontOfSize:20]];
    int width = rect.size.width / text.length - cSize.width;
    int height = rect.size.height - cSize.height;
    CGPoint point;
    
    float pX, pY;
    for (int i = 0; i < text.length; i++)
    {
        pX = arc4random() % width + rect.size.width / text.length * i;
        pY = arc4random() % height;
        point = CGPointMake(pX, pY);
        [_captcha drawInRect:CGRectMake(0, 0, point.x, point.y)];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    for(int cout = 0; cout < 10; cout++)
    {
        red = arc4random() % 100 / 100.0;
        green = arc4random() % 100 / 100.0;
        blue = arc4random() % 100 / 100.0;
        color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        CGContextSetStrokeColorWithColor(context, [color CGColor]);
        pX = arc4random() % (int)rect.size.width;
        pY = arc4random() % (int)rect.size.height;
        CGContextMoveToPoint(context, pX, pY);
        pX = arc4random() % (int)rect.size.width;
        pY = arc4random() % (int)rect.size.height;
        CGContextAddLineToPoint(context, pX, pY);
        CGContextStrokePath(context);
    }
}



@end
