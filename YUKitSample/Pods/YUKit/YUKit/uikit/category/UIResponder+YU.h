//
//  UIResponder+YU.h
//  YUKit<https://github.com/c6357/YUKit>
//
//  Created by BruceYu on 15/9/7.
//  Copyright (c) 2015年 BruceYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (YU)

/**
 recently Controller;

 @return <#return value description#>
 */
- (UIViewController*)recentlyController;


/**
 recently NavigationContoller

 @return <#return value description#>
 */
- (UINavigationController*)recentlyNavigationContoller;

@end
