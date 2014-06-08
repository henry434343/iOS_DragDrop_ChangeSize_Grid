//
//  CustomView.m
//  MetroUI
//
//  Created by Henry Kung on 2014/6/6.
//  Copyright (c) 2014年 Henry Kung. All rights reserved.
//

#import "CustomView.h"
#import "PointItem.h"

@implementation CustomView
@synthesize label,delete,resize,positions;
@synthesize delegate;
@synthesize edgeInsets;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];

        self.label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10)];
        self.label.backgroundColor = [UIColor greenColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        
        self.delete = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.delete setAlpha:0];
        self.delete.frame = CGRectMake(5, 5, 30, 30);
        [self.delete setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [self.delete addTarget:self action:@selector(deleteItem) forControlEvents:UIControlEventTouchDown];
        
        self.resize = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.resize setAlpha:0];
        self.resize.frame = CGRectMake(frame.size.width-35, frame.size.height-35, 30, 30);
        [self.resize setImage:[UIImage imageNamed:@"resize.png"] forState:UIControlStateNormal];
        [self.resize addTarget:self action:@selector(resizeItem) forControlEvents:UIControlEventTouchDown];
        
        [self addSubview:self.label];
        [self addSubview:self.delete];
        [self addSubview:self.resize];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action :@selector(longPress:)];
        [self addGestureRecognizer:longPress];
    } 
    return self;
}

- (void)longPress:(UILongPressGestureRecognizer*)sender{
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
    }
    else if (sender.state == UIGestureRecognizerStateBegan){
        [self.delegate longPressCustomView:self];
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.label.frame = CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10);
    self.resize.frame = CGRectMake(frame.size.width-35, frame.size.height-35, 30, 30);
}

- (void)deleteItem {
    [self.delegate deleteCustomView:self];
}

- (void)resizeItem {
    [self.delegate resizeCustomView:self];
}



@end
