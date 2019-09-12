//
//  UITextField+ExtentRange.m
//  KDLC
//
//  Created by apple on 15/10/13.
//  Copyright (c) 2015年 llyt. All rights reserved.
//

#import "UITextField+ExtentRange.h"

@implementation UITextField (ExtentRange)

- (NSRange)selectedRange
{
    
    UITextPosition* beginning = self.beginningOfDocument;
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;

    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

- (void)setSelectedRange:(NSRange) range
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextPosition *startPosition = [self positionFromPosition:beginning inDirection:UITextLayoutDirectionRight offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:startPosition inDirection:UITextLayoutDirectionRight offset:range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

@end
