//
//  ViewController.m
//  MetroUI
//
//  Created by Henry Kung on 2014/6/6.
//  Copyright (c) 2014年 Henry Kung. All rights reserved.
//

#import "ViewController.h"
#import "CustomView.h"
#import "PointItem.h"
#import "DragView.h"
#import "DB.h"
#import "Recorditem.h"
@interface ViewController ()<CustomViewDelegate> {
    CGPoint startLocation;
    
    int screenWidth;
    int screeHeight;
	
    int itemWidth;
    int itemHeight;
    int tempX;
    int tempY;
    
    int moveX;
    int moveY;
    int clickItemPointIndex;
    
    ItemOperator itemOperator;
    ItemActionMode itemActionMode;

    bool isNoSpaceToMove;
    DragView *dragView;
    CustomView *moveItem;
    
    NSMutableArray *views;
    NSMutableArray *screenPointUse;
    
    DB *db;
}

@end

@implementation ViewController
@synthesize delegate,indentify;

- (id)initWithid:(NSString *)id {
    self = [super init];
    if (self) {
        self.indentify = id;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    screenWidth = self.view.frame.size.width;
    screeHeight = self.view.frame.size.height;
    itemWidth = screenWidth/rowCount;
    itemHeight =  (screeHeight - (IS_IOS7 ? 64 : 44))/columnCount;
    
    [self initPoints];
    views = [NSMutableArray array];
    dragView = [[DragView alloc] initWithFrame:self.view.bounds itemWidth:itemWidth itemHeight:itemHeight];
    [dragView setAlpha:0];
    [self.view addSubview:dragView];
    
    db = [[DB alloc] initWithDBName:self.indentify];
    NSArray *array = [db getItem];
    if (array != nil) {
        for (NSData *data in array) {
            Recorditem *item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [self addView:item.id size:[item.size intValue] row:[item.row intValue] column:[item.column intValue]];
        }
    }
}

- (void)initPoints {
    screenPointUse = [NSMutableArray array];
    for (int i = 0; i < columnCount ; i++) {
        for (int j = 0; j < rowCount ; j++) {
            PointItem *p = [[PointItem alloc] init];
            p.X = j;
            p.Y = i;
            p.check = false;
            [screenPointUse addObject:p];
        }
    }
}

- (void)recordItems{
    for (CustomView *item in views) {
        [db insertItem:item.id size:item.size row:((PointItem*)[item.positions objectAtIndex:0]).X column:((PointItem*)[item.positions objectAtIndex:0]).Y];
    }
}

- (void)addView:(NSString*)id size:(int)size row:(int)row column:(int)column {
    
    if (views.count >= rowCount * columnCount) {
        NSLog(@"已達上限");
        return;
    }
    
    int x;
    int y;
    if (row == -1 && column == -1) {
        NSArray *array = [self getNewViewPosition:min];
        x = [[array objectAtIndex:0] intValue];
        y = [[array objectAtIndex:1] intValue];
    }
    else {
        x = row;
        y = column;
    }
    
    int width = 0;
    int height = 0;
    
    CustomView *view = [[CustomView alloc] init];
    switch (size) {
        case 0:
            width = itemWidth;
            height = itemHeight;
            view.positions = [NSMutableArray arrayWithObjects:[[PointItem alloc] initWithPoint:x andY:y], nil];
            break;
        case 1:
            width = itemWidth *2;
            height = itemHeight;
            view.positions = [NSMutableArray arrayWithObjects:[[PointItem alloc] initWithPoint:x andY:y],
                                                              [[PointItem alloc] initWithPoint:x+1 andY:y], nil];

            break;
        case 2:
            width = itemWidth;
            height = itemHeight *2;
            view.positions = [NSMutableArray arrayWithObjects:[[PointItem alloc] initWithPoint:x andY:y],
                                                              [[PointItem alloc] initWithPoint:x andY:y+1], nil];
            break;
        case 3:
            width = itemWidth *2;
            height = itemHeight *2;
            view.positions = [NSMutableArray arrayWithObjects:[[PointItem alloc] initWithPoint:x andY:y],
                                                              [[PointItem alloc] initWithPoint:x andY:y+1],
                                                              [[PointItem alloc] initWithPoint:x+1 andY:y],
                                                              [[PointItem alloc] initWithPoint:x+1 andY:y+1], nil];
            break;
    }
    
    view.frame =CGRectMake(x*itemWidth, (topBarHeight)+y*itemHeight, width, height);

    view.delegate = self;
    view.userInteractionEnabled = YES;
    view.id = id == nil ? [NSString stringWithFormat:@"%d",(int)views.count] : id;
    view.label.text = view.id;
    view.size = size;
    view.tag = views.count;
    
    [views addObject:view];
    [self.view addSubview:view];
    [self updateScreenPosition];
}

- (void)updateScreenPosition {
    [self initPoints];
    for (CustomView *item in views) {
        for (PointItem *itemP in item.positions) {
            for (PointItem *p in screenPointUse) {
                if ([p isEqual:itemP]) {
                    p.check = true;
                    break;
                }
            }
        }
    }
}

- (NSArray*)getNewViewPosition:(ItemSize)size {
    switch (size) {
		case min:
			for (PointItem *p in screenPointUse) {
				if (!p.check) {
                    return [NSArray arrayWithObjects:[NSNumber numberWithInt:p.X],[NSNumber numberWithInt:p.Y], nil];
                }
			}
			break;
		case mid_width:
			for (int i = 0; i < screenPointUse.count; i++) {
                @try {
                    PointItem *item1 = [screenPointUse objectAtIndex:i];
                    PointItem *item2 = [screenPointUse objectAtIndex:i+1];
                    if (!item1.check && !item2.check) {
                        if (item1.X == rowCount - 1) {
                            continue;
                        }
                        return [NSArray arrayWithObjects:[NSNumber numberWithInt:item1.X],[NSNumber numberWithInt:item1.Y], nil];
                    }
                }
                @catch (NSException *exception) {}
			}
			break;
		case mid_height:
			for (int i = 0; i < screenPointUse.count; i++) {
                @try {
                    PointItem *item1 = [screenPointUse objectAtIndex:i];
                    PointItem *item2 = [screenPointUse objectAtIndex:i+rowCount];
                    if (!item1.check && !item2.check) {
                        if (item1.X == columnCount - 1) {
                            continue;
                        }
                        return [NSArray arrayWithObjects:[NSNumber numberWithInt:item1.X],[NSNumber numberWithInt:item1.Y], nil];
                    }
                }
                @catch (NSException *exception) {}
			}
			break;
		case max:
			for (int i = 0; i < screenPointUse.count; i++) {
                
                @try {
                    PointItem *item1 = [screenPointUse objectAtIndex:i];
                    PointItem *item2 = [screenPointUse objectAtIndex:i+1];
                    PointItem *item3 = [screenPointUse objectAtIndex:i+rowCount];
                    PointItem *item4 = [screenPointUse objectAtIndex:i+rowCount+1];
                    if (!item1.check && !item2.check && !item3.check && !item4.check) {
                        if (item1.X == rowCount-1 || item1.Y == columnCount-1)
                            continue;
                        return [NSArray arrayWithObjects:[NSNumber numberWithInt:item1.X],[NSNumber numberWithInt:item1.Y], nil];
                    }
                }
                @catch (NSException *exception) {}
			}
			break;
		default:
			break;
    }
    return nil;
}

- (void)cloneViewItem:(CustomView*)item {
    tempX = ((PointItem*)[item.positions objectAtIndex:0]).X;
    tempY = ((PointItem*)[item.positions objectAtIndex:0]).Y;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches]anyObject];
    if ([[touch view] isKindOfClass:[CustomView class]]) {
        
        if (itemActionMode == editMode) {
            CustomView *nowItem = (CustomView*)[touch view];
            [self showEditMode:nowItem];

            [self.view bringSubviewToFront:nowItem];
            CGPoint pt =[[touches anyObject] locationInView:nowItem];
            [nowItem setAlpha:0.5];
            startLocation = pt;
            
            CGPoint touchLocation = [touch locationInView:self.view];
            [self cloneViewItem:nowItem];
            
            for (int i = 0; i < nowItem.positions.count; i++) {
                if (((PointItem*)[nowItem.positions objectAtIndex:i]).X == (int)touchLocation.x/itemWidth &&
                    ((PointItem*)[nowItem.positions objectAtIndex:i]).Y == (int)(touchLocation.y - (topBarHeight))/itemHeight) {
                    clickItemPointIndex = i ;
                    break;
                }
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent: (UIEvent *)event {
    
    if (itemActionMode == editMode) {
        UITouch *touch = [[event allTouches]anyObject];
        if ([[touch view] isKindOfClass:[CustomView class]]) {
            CustomView *nowItem = (CustomView*)[touch view];
            int X = (int)[touch locationInView:self.view].x;
            int Y = (int)[touch locationInView:self.view].y;
            if (X/itemWidth > rowCount-1 || (Y- (topBarHeight))/itemHeight > columnCount-1)
                return;
            
            CGPoint pt =[[touches anyObject] locationInView:nowItem];
            CGFloat dx = pt.x - startLocation.x;
            CGFloat dy = pt.y - startLocation.y;
            CGPoint newCenter = CGPointMake(nowItem.center.x + dx, nowItem.center.y + dy);
            nowItem.center = newCenter;
            
            
            
            
            int rootX = X/itemWidth;
            int rootY = (Y- (topBarHeight))/itemHeight;
            int index = clickItemPointIndex >= nowItem.positions.count ? 0 : clickItemPointIndex;
            if (((PointItem*)[nowItem.positions objectAtIndex:index]).X != rootX || ((PointItem*)[nowItem.positions objectAtIndex:index]).Y != rootY) {
                //設定起始位置
                if (nowItem.size == min) {
                    [self setItemPosition:nowItem position:[NSArray arrayWithObjects:[NSNumber numberWithInt:rootX],[NSNumber numberWithInt:rootY], nil]];
                }
                else if (nowItem.size == mid_width) {
                    if (clickItemPointIndex == 0)
                        [self setItemPosition:nowItem position:[NSArray arrayWithObjects:[NSNumber numberWithInt:rootX],[NSNumber numberWithInt:rootY], nil]];
                    else
                        [self setItemPosition:nowItem position:[NSArray arrayWithObjects:[NSNumber numberWithInt:rootX-1],[NSNumber numberWithInt:rootY], nil]];
                }
                else if (nowItem.size == mid_height) {
                    if (clickItemPointIndex == 0)
                        [self setItemPosition:nowItem position:[NSArray arrayWithObjects:[NSNumber numberWithInt:rootX],[NSNumber numberWithInt:rootY], nil]];
                    else
                        [self setItemPosition:nowItem position:[NSArray arrayWithObjects:[NSNumber numberWithInt:rootX],[NSNumber numberWithInt:rootY-1], nil]];
                }
                else  {
                    if (clickItemPointIndex == 0)
                        [self setItemPosition:nowItem position:[NSArray arrayWithObjects:[NSNumber numberWithInt:rootX],[NSNumber numberWithInt:rootY], nil]];
                    else if (clickItemPointIndex == 1)
                        [self setItemPosition:nowItem position:[NSArray arrayWithObjects:[NSNumber numberWithInt:rootX-1],[NSNumber numberWithInt:rootY], nil]];
                    else if (clickItemPointIndex == 2)
                        [self setItemPosition:nowItem position:[NSArray arrayWithObjects:[NSNumber numberWithInt:rootX],[NSNumber numberWithInt:rootY-1], nil]];
                    else
                        [self setItemPosition:nowItem position:[NSArray arrayWithObjects:[NSNumber numberWithInt:rootX-1],[NSNumber numberWithInt:rootY-1], nil]];
                }
                moveX = X;
                moveY = Y;
                NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithInt:X],[NSNumber numberWithInt:Y],nowItem, nil];
                [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(moveOverlapView:) userInfo:array repeats:NO];
            }
        }
    }
}

- (void)moveOverlapView:(NSTimer*)theTimer {
    NSArray *array = (NSArray*)[theTimer userInfo];
    int X = [[array objectAtIndex:0] intValue];
    int Y = [[array objectAtIndex:1] intValue];
    
    NSLog(@"X = %d",X);
    NSLog(@"Y = %d",Y);
    CustomView *nowItem = [array objectAtIndex:2];
    if (moveX == X && moveY == Y) {
        moveItem = nowItem;
        [self checkOverlap:moveItem];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches]anyObject];
    if ([[touch view] isKindOfClass:[CustomView class]]) {
        CustomView *nowItem = (CustomView*)[touch view];
        if (itemActionMode == editMode) {
            
            [nowItem setAlpha:1];
            int X = (int)[touch locationInView:self.view].x;
            int Y = (int)[touch locationInView:self.view].y;
            if (X/itemWidth > rowCount-1 || (Y- (topBarHeight))/itemHeight > columnCount-1)
                return;
            
            int rootX = 0;
            int rootY = 0;
            if (isNoSpaceToMove) {
                rootX = tempX;
                rootY = tempY;
                isNoSpaceToMove = false;
            }
            else {
                rootX = ((PointItem*)[nowItem.positions objectAtIndex:0]).X;
                rootY = ((PointItem*)[nowItem.positions objectAtIndex:0]).Y;
            }
            
            BOOL isReset = false;
            if (nowItem.size == mid_width) {
                if (rootX < 0) {
                    rootX = 0;
                    [self resetItem:nowItem rootX:rootX rootY:rootY];
                    isReset = true;
                }
                else if (rootX+1 >= rowCount) {
                    [self resetItem:nowItem rootX:rootX rootY:rootY];
                    isReset = true;
                }
            }
            else if (nowItem.size == mid_height) {
                if (rootY < 0) {
                    rootY = 0;
                    [self resetItem:nowItem rootX:rootX rootY:rootY];
                    isReset = true;
                }
                else if (rootY+1 >= columnCount) {
                    [self resetItem:nowItem rootX:rootX rootY:rootY];
                    isReset = true;
                }
            }
            else if (nowItem.size == max) {
                if (rootX < 0 || rootY < 0) {
                    rootX = rootX < 0 ? 0 : rootX;
                    rootY = rootY < 0 ? 0 : rootY;
                    [self resetItem:nowItem rootX:rootX rootY:rootY];
                    isReset = true;
                }
                else if (rootX+1 >= rowCount || rootY+1 >= columnCount) {
                    [self resetItem:nowItem rootX:rootX rootY:rootY];
                    isReset = true;
                }
            }
            
            if (!isReset)
                nowItem.frame = CGRectMake(0+(itemWidth*rootX), (topBarHeight)+(itemHeight*rootY), nowItem.frame.size.width, nowItem.frame.size.height);

            [self setItemPosition:nowItem position:[NSArray arrayWithObjects:[NSNumber numberWithInteger:rootX],[NSNumber numberWithInteger:rootY], nil]];
            [self checkOverlap:nowItem];
        }
        else {
            [self pressCustomView:nowItem];
        }
    }
    else {
        [self finishEditMode:nil];
    }
}

- (void)resetItem:(CustomView*)item rootX:(int)rootX rootY:(int)rootY {
    item.size = min;
    item.frame = CGRectMake(0+(itemWidth*rootX), (topBarHeight)+(itemHeight*rootY), itemWidth, itemHeight);
}

- (void)pressCustomView:(CustomView*)view {
    itemActionMode = switchMode;
    view.label.backgroundColor = view.label.backgroundColor == [UIColor greenColor] ? [UIColor redColor] : [UIColor greenColor];
}

- (void)longPressCustomView:(CustomView*)view {
    
    if (itemActionMode != editMode) {
        clickItemPointIndex = -1;
        itemActionMode = editMode;
        [dragView setAlpha:0.5];
        [self showEditMode:view];
    }
    
    for (CustomView *item in views) {
        [item setAlpha:1];
    }
}

- (void)showEditMode:(CustomView*)view {
    for (CustomView *subview in views) {
        [subview.delete setAlpha:0];
        [subview.resize setAlpha:0];
    }
    [view.delete setAlpha:1];
    [view.resize setAlpha:1];
    [self.delegate editMode:TRUE];
}

- (void)finishEditMode:(CustomView*)view {
    itemActionMode = switchMode;
    [dragView setAlpha:0];
    for (CustomView *view in views) {
        [view setAlpha:1];
        [view.delete setAlpha:0];
        [view.resize setAlpha:0];
    }
    [self.delegate editMode:false];
}

- (void)deleteCustomView:(CustomView *)view {
    NSLog(@"deleteCustomView : %d",(int)view.tag);
    [db removeItem:view.id];
    [view removeFromSuperview];
    [views removeObject:view];
    [self updateScreenPosition];
}

- (void)resizeCustomView:(CustomView *)view {
    NSLog(@"resizeCustomView %d",(int)view.tag);
    
    itemOperator = reSizeItem;
    [self itemResize:view];
}

- (void)itemResize:(CustomView*)item {
    
    int startX = ((PointItem*)[item.positions objectAtIndex:0]).X;
    int startY = ((PointItem*)[item.positions objectAtIndex:0]).Y;
    switch (item.size) {
        case min:
            if (startX+1>rowCount-1) {
                NSLog(@"startX+1>rowCount-1");
                @try {
                    startX = [[[self getNewViewPosition:mid_width] objectAtIndex:0] intValue];
					startY = [[[self getNewViewPosition:mid_width] objectAtIndex:1] intValue];
                    NSLog(@"startX = %d",startX);
                    NSLog(@"startY = %d",startY);
                }
                @catch (NSException *exception) {}
			}
            item.positions = [NSMutableArray arrayWithObjects:[[PointItem alloc] initWithPoint:startX andY:startY],
                                                              [[PointItem alloc] initWithPoint:startX+1 andY:startY],nil];
		    item.size = mid_width;
            [item setFrame:CGRectMake(0+(itemWidth*startX), (topBarHeight)+(itemHeight*startY), itemWidth*2, itemHeight)];

            break;
            
        case mid_width:
            if (startY+1>columnCount-1) {
                @try {
                    startX = [[[self getNewViewPosition:mid_height] objectAtIndex:0] intValue];
					startY = [[[self getNewViewPosition:mid_height] objectAtIndex:1] intValue];
                }
                @catch (NSException *exception) {}
			}
            item.positions = [NSMutableArray arrayWithObjects:[[PointItem alloc] initWithPoint:startX andY:startY],
                                                              [[PointItem alloc] initWithPoint:startX andY:startY+1],nil];
		    item.size = mid_height;
            [item setFrame:CGRectMake(0+(itemWidth*startX), (topBarHeight)+(itemHeight*startY), itemWidth, itemHeight*2)];

            break;
            
        case mid_height:
            if (startX+1>rowCount-1 || startY+1>columnCount-1) {
                @try {
                    startX = [[[self getNewViewPosition:max] objectAtIndex:0] intValue];
					startY = [[[self getNewViewPosition:max] objectAtIndex:1] intValue];
                }
                @catch (NSException *exception) {}
			}
            item.positions = [NSMutableArray arrayWithObjects:[[PointItem alloc] initWithPoint:startX andY:startY],
                                                              [[PointItem alloc] initWithPoint:startX+1 andY:startY],
                                                              [[PointItem alloc] initWithPoint:startX andY:startY+1],
                                                              [[PointItem alloc] initWithPoint:startX+1 andY:startY+1],nil];
		    item.size = max;
            [item setFrame:CGRectMake(0+(itemWidth*startX), (topBarHeight)+(itemHeight*startY), itemWidth*2, itemHeight*2)];
            break;
            
        case max:
            item.positions = [NSMutableArray arrayWithObjects:[[PointItem alloc] initWithPoint:startX andY:startY],nil];
		    item.size = min;
            [item setFrame:CGRectMake(0+(itemWidth*startX), (topBarHeight)+(itemHeight*startY), itemWidth, itemHeight)];
            break;
            
        default:
            break;
    }
    
    [self updateScreenPosition];
    [self checkOverlap:item];
}

- (void)clearPointInScreenFromItem:(CustomView*)viewItem {
    [self initPoints];
    for (CustomView *item in views) {
        for (PointItem *itemP in item.positions) {
            if (item != viewItem) {
                for (PointItem *p in screenPointUse) {
                    if ([p isEqual:itemP]) {
                        p.check =true;
                    }
                }
            }
        }
    }
}

- (void)setItemPosition:(CustomView*)item position:(NSArray*)array {
    int startX = [[array objectAtIndex:0] intValue];
    int startY = [[array objectAtIndex:1] intValue];
    switch (item.size) {
		case min:
            item.positions = [NSMutableArray arrayWithObjects:[[PointItem alloc] initWithPoint:startX andY:startY],nil];
			break;
		case mid_width:
            item.positions = [NSMutableArray arrayWithObjects:[[PointItem alloc] initWithPoint:startX andY:startY],
                                                              [[PointItem alloc] initWithPoint:startX+1 andY:startY],nil];
			break;
		case mid_height:
            item.positions = [NSMutableArray arrayWithObjects:[[PointItem alloc] initWithPoint:startX andY:startY],
                                                              [[PointItem alloc] initWithPoint:startX andY:startY+1],nil];
			break;
		case max:
            item.positions = [NSMutableArray arrayWithObjects:[[PointItem alloc] initWithPoint:startX andY:startY],
                                                              [[PointItem alloc] initWithPoint:startX+1 andY:startY],
                                                              [[PointItem alloc] initWithPoint:startX andY:startY+1],
                                                              [[PointItem alloc] initWithPoint:startX+1 andY:startY+1],nil];
			break;
            
		default:
			break;
    }
    [self updateScreenPosition];
}

- (void)checkOverlap:(CustomView*)item {
    
    for (CustomView *otherItem in views) {
        if (item != otherItem) {
            BOOL isOverlap = false;
            for (PointItem *p in item.positions) {
                for (PointItem *otherP in otherItem.positions) {
                    if ([p isEqual:otherP]) {
                        isOverlap = true;
                        [self clearPointInScreenFromItem:otherItem];
                        NSArray *start = [self getNewViewPosition:otherItem.size];
                        if (start != nil) {
                            isNoSpaceToMove = false;
                            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                                otherItem.frame = CGRectMake(0+(itemWidth*[[start objectAtIndex:0] intValue]), (topBarHeight)+(itemHeight*[[start objectAtIndex:1] intValue]), otherItem.frame.size.width, otherItem.frame.size.height);
                            } completion:^(BOOL finished){
                                
                            }];
                            [self setItemPosition:otherItem position:start];
                            [self updateScreenPosition];
                        }
                        else {
                            if (itemOperator == reSizeItem) {
                                [self itemResize:item];
                                NSLog(@"無空間");
                            }
                            else {
                                NSLog(@"無空間可移動");
                                isNoSpaceToMove = true;
                            }
                        }
                        
                        break;
                    }

                }
                if (isOverlap) {
                    break;
                }
            }
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
