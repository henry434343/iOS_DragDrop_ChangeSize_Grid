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

@property(nonatomic, strong)NSString *indentify;
@property(nonatomic, assign)id<ViewControllerDegelate> delegate;

- (id)initWithid:(NSString*)id;
- (void)recordItems;
- (void)addView:(NSString*)id size:(int)size row:(int)row column:(int)column;
@end

@protocol ViewControllerDegelate

- (void)editMode:(BOOL)isEdit;

@end
