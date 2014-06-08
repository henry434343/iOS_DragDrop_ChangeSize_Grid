//
//  ViewController.h
//  MetroUI
//
//  Created by Henry Kung on 2014/6/6.
//  Copyright (c) 2014年 Henry Kung. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewControllerDegelate;

@interface ViewController : UIViewController

@property(nonatomic, assign)id<ViewControllerDegelate> delegate;

- (void)addView;
@end

@protocol ViewControllerDegelate

- (void)editMode:(BOOL)isEdit;

@end
