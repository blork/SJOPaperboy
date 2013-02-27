//
//  IPInsetLabel.h
//  Instapaper
//
//  Created by Marco Arment on 7/23/11.
//  Copyright 2011 Instapaper LLC, released to the public domain.
//

#import <UIKit/UIKit.h>

@interface IPInsetLabel : UILabel
@property (nonatomic, assign) UIEdgeInsets insets;
- (void)resizeHeightToFitText;
@end
