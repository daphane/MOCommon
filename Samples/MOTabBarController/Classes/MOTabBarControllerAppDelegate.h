//
//  MOTabBarControllerAppDelegate.h
//  MOTabBarController demo
//
//  Created by Hwee-Boon Yar on 5/30/11.
//  Copyright 2011 MotionObj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MOTabBarControllerDelegate.h"

@class MOTabBarController;

@interface MOTabBarControllerAppDelegate : NSObject <UIApplicationDelegate, MOTabBarControllerDelegate> {
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet MOTabBarController *tabBarController;

@end

