//
//  UITextField+ExtentRange.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/25.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "UITextField+ExtentRange.h"

@implementation UITextField (ExtentRange)

- (NSRange)selectedRange
{
    UITextPosition * beginning = self.beginningOfDocument;
    
    UITextRange * selectedRange = self.selectedTextRange;
    
    UITextPosition * selectedStart = selectedRange.start;
    
    UITextPosition * selectedEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectedStart];
    
    const NSInteger length = [self offsetFromPosition:selectedStart toPosition:selectedEnd];
    
    return NSMakeRange(location, length);
}

- (void)setSelectedRange:(NSRange)range
{
    UITextPosition * beginning = self.beginningOfDocument;
    
    UITextPosition * startPosition = [self positionFromPosition:beginning offset:range.location];
    
    UITextPosition * endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    
    UITextRange * selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}

@end
