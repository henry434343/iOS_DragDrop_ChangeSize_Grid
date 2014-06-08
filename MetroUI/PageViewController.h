//
//  PageViewController.h
//  MetroUI
//
//  Created by Kung henry on 2014/6/8.
//  Copyright (c) 2014年 Henry Kung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@interface PageViewController : UIViewController <UIPageViewControllerDataSource,ViewControllerDegelate>

@property (strong, nonatomic) UIPageViewController *pageController;
@end
