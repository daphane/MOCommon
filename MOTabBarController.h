//
//  MOTabBarController.h
//  Licensed under the terms of the BSD License, as specified below.
//
//  Created by Hwee-Boon Yar on May/26/2011.
//
/*
 Copyright 2011 Yar Hwee Boon. All rights reserved.
 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 * Neither the name of MotionObj nor the names of its
 contributors may be used to endorse or promote products derived from
 this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
#import <UIKit/UIKit.h>

#import "MOTabBarControllerDelegate.h"

@interface MOTabButton : UIControl

@property (nonatomic,strong) UIImage* normalImage;
@property (nonatomic,strong) UIImage* highlightedImage;
@property (nonatomic,strong) NSString* text;

@end


// No support for more button unlike UITableViewController. We also assume that the viewControllers passed in will already be wrapped with UINavigationController
@interface MOTabBarController : UIViewController<UINavigationControllerDelegate>

@property (nonatomic,copy) NSArray* viewControllers;
@property (nonatomic) int selectedIndex;
@property (nonatomic,weak) UIViewController* selectedViewController;
@property (nonatomic,copy) NSArray* tabButtons;
@property (nonatomic,strong) NSArray* buttons;
@property (nonatomic,weak) NSObject<MOTabBarControllerDelegate>* delegate;
//Default to 0. If 0, will return the value of the shortest button image. Useful to set when the toolbar has buttons of different heights but the images height don't reflect that (eg. images have transparent areas)
@property (nonatomic) CGFloat tabBarHeight;

@end
