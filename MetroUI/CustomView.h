//
//  CustomView.h
//  MetroUI
//
//  Created by Henry Kung on 2014/6/6.
//  Copyright (c) 2014年 Henry Kung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Setting.h"

@protocol CustomViewDelegate;

@interface CustomView : UIView

@property(nonatomic, strong)UILabel *label;
@property(nonatomic, strong)UIButton *delete;
@property(nonatomic, strong)UIButton *resize;
@property(nonatomic, strong)NSMutableArray *positions;
@property(nonatomic, assign)ItemSize size;
@property(nonatomic, assign)id<CustomViewDelegate> delegate;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@end

@protocol CustomViewDelegate

- (void)deleteCustomView:(CustomView*)view;
- (void)resizeCustomView:(CustomView*)view;
- (void)longPressCustomView:(CustomView*)view;

@end
