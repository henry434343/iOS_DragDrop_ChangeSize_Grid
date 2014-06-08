//
//  PageViewController.m
//  MetroUI
//
//  Created by Kung henry on 2014/6/8.
//  Copyright (c) 2014年 Henry Kung. All rights reserved.
//

#import "PageViewController.h"
@interface PageViewController () {
    NSMutableArray *viewControllers;
    NSMutableArray *firstViewControll;
}

@end

@implementation PageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    viewControllers  = [NSMutableArray array];
    firstViewControll = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        ViewController *controller = [[ViewController alloc] init];
        controller.delegate = self;
        [viewControllers addObject:controller];
        
        if (i == 0) {
            [firstViewControll addObject:controller];
        }
    }
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageController.dataSource = self;
    self.pageController.view.frame = self.view.bounds;
    [self.pageController setViewControllers:firstViewControll direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];

    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addView)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)addView {
    
    [((ViewController*)[self.pageController.viewControllers objectAtIndex:0]) addView];    
}

- (void)editMode:(BOOL)isEdit {
    [self setScrollEnabled:!isEdit forPageViewController:self.pageController];
}

- (void)setScrollEnabled:(BOOL)enabled forPageViewController:(UIPageViewController*)pageViewController{
    for(UIView* view in pageViewController.view.subviews){
        if([view isKindOfClass:[UIScrollView class]]){
            UIScrollView* scrollView=(UIScrollView*)view;
            [scrollView setScrollEnabled:enabled];
            return;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [viewControllers indexOfObject:viewController];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [viewControllers objectAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
   NSUInteger index = [viewControllers indexOfObject:viewController];
    
    index++;
    
    if (index == 5) {
        return nil;
    }
    
    return [viewControllers objectAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return [viewControllers count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
