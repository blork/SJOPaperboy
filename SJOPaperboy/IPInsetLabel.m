//
//  IPInsetLabel.m
//  Instapaper
//
//  Created by Marco Arment on 7/23/11.
//  Copyright 2011 Instapaper LLC, released to the public domain.
//

#import "IPInsetLabel.h"

@implementation IPInsetLabel
@synthesize insets;

- (void)drawTextInRect:(CGRect)rect 
{
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

- (void)resizeHeightToFitText
{
    CGRect frame = [self bounds];
    CGFloat textWidth = frame.size.width - (self.insets.left + self.insets.right);

    CGSize newSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(textWidth, 1000000) lineBreakMode:self.lineBreakMode];
    frame.size.height = newSize.height + self.insets.top + self.insets.bottom;
    self.frame = frame;
}

@end
