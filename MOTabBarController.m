//
//  MOTabBarController.m
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
#import "MOTabBarController.h"

#import "MOUIViewAdditions.h"
#import "MOUtility.h"

@interface MOTabBarController()

@property (nonatomic) BOOL tabHidden;
@property (nonatomic,strong) NSMutableArray* originalNavigationControllerDelegates;

- (void)createDefaultTabButtons;
- (void)setSelectedIndex:(int)aNumber force:(BOOL)yesOrNo;

@end


//todo doesn't handle rotation
@implementation MOTabBarController

@synthesize selectedViewController;
@synthesize selectedIndex;
@synthesize tabButtons;
@synthesize tabHidden;
@synthesize tabBarHeight;

- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle {
	if (self = [super initWithNibName:nibName bundle:nibBundle]) {
		selectedIndex = 0;
		tabBarHeight = 0;
	}

	return self;
}


- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}


- (void)viewDidLoad {
	[super viewDidLoad];

}


- (void)viewDidUnload {
	[super viewDidUnload];

}


- (void)didReceiveMemoryWarning {
	//Overridden to not release the view. Avoids a world of pain to reconstruct the subviews
}


- (id<UINavigationControllerDelegate>)navigationControllerDelegateForViewController:(UIViewController*)vc {
	if (![vc isKindOfClass:[UINavigationController class]]) return nil;

	int index = [self.viewControllers indexOfObject:vc];
	if (index == NSNotFound) return nil;

	id<UINavigationControllerDelegate> result = [self.originalNavigationControllerDelegates objectAtIndex:index];
	if ((NSNull*)result == [NSNull null]) return nil;

	return result;
}

#pragma mark View Management

- (void)bringTabButtonsToFront {
	for (UIButton* each in self.buttons) {
		[self.view bringSubviewToFront:each];
	}
}


- (void)createDefaultTabButtons {
	if ([self.tabButtons count] > 0) return;

	NSMutableArray* array = [NSMutableArray array];
	CGFloat width = 320/5;
	CGFloat height = 44;
	UIColor* backgroundColor = [UIColor blackColor];

	MOTabButton* b1 = [[MOTabButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
	b1.backgroundColor = backgroundColor;
	//b1.text = @"b1";
	[array addObject:b1];

	MOTabButton* b2 = [[MOTabButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
	b2.backgroundColor = backgroundColor;
	//b2.text = @"b2";
	[array addObject:b2];

	MOTabButton* b3 = [[MOTabButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
	b3.backgroundColor = backgroundColor;
	//b3.text = @"b3";
	[array addObject:b3];

	MOTabButton* b4 = [[MOTabButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
	b4.backgroundColor = backgroundColor;
	//b4.text = @"b4";
	[array addObject:b4];

	MOTabButton* b5 = [[MOTabButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
	b5.backgroundColor = backgroundColor;
	//b5.text = @"b5";
	[array addObject:b5];

	self.tabButtons = array;
}


- (void)createButtons {
	if ([self.buttons count] > 0) return;

	NSMutableArray* array = [NSMutableArray array];

	for (int i=0; i<[self.tabButtons count]; ++i) {
		UIButton* b = [UIButton buttonWithType:UIButtonTypeCustom];
		[b addTarget:self action:NSSelectorFromString([NSString stringWithFormat:@"button%dTapped", i]) forControlEvents:UIControlEventTouchUpInside];
		[array addObject:b];
		[self.view addSubview:b];
	}

	self.buttons = array;
}


- (CGFloat)shortestTabButtonHeight {
	CGFloat result = 1000; //arbitary large height
	for (MOTabButton* each in self.tabButtons) {
		result = fmin(result, each.frame.size.height);
	}

	return result;
}


- (void)resizeViewController:(UIViewController*)aViewController {
	aViewController.view.frame = CGRectMake(0, 0, self.view.moWidth, self.view.moHeight-(self.tabHidden? 0: self.tabBarHeight));
}


- (void)displayViewController:(UIViewController*)aViewController {
	NSAssert(aViewController, @"We should only display a non-nil view controller in tab bar");

	UIViewController* old = self.selectedViewController;
	selectedViewController = aViewController;
	selectedIndex = [self.viewControllers indexOfObject:self.selectedViewController];	// Must not use accessor

	if (selectedIndex == NSNotFound) {
		@throw [NSException exceptionWithName:NSRangeException reason:@"View controller not found in tab bar" userInfo:nil];
	}

	[old viewWillDisappear:NO];
	[self resizeViewController:aViewController];

	[aViewController viewWillAppear:NO];
	[old.view removeFromSuperview];
	[self.view addSubview:aViewController.view];
	[old viewDidDisappear:NO];
	[aViewController viewDidAppear:NO];

	[self bringTabButtonsToFront];
}

#pragma mark View Events

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.selectedViewController viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.selectedViewController viewWillDisappear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.selectedViewController viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self.selectedViewController viewDidDisappear:animated];
}

#pragma mark Accessors

- (CGFloat)tabBarHeight {
	if (tabBarHeight == 0) return [self shortestTabButtonHeight];

	return tabBarHeight;
}


- (NSArray*)viewControllers {
	return self.childViewControllers;
}


- (void)setViewControllers:(NSArray*)anArray {
	for (int i=0; i<[self.originalNavigationControllerDelegates count]; ++i) {
		id<UINavigationControllerDelegate> d = [self.originalNavigationControllerDelegates objectAtIndex:i];

		if ((NSNull*)d != [NSNull null]) {
			((UINavigationController*)[self.viewControllers objectAtIndex:i]).delegate = d;
		}
	}

	for (UIViewController* vc in self.viewControllers) {
		[vc willMoveToParentViewController:nil];
		[vc removeFromParentViewController];
	}

	self.originalNavigationControllerDelegates = [NSMutableArray array];

	for (UIViewController* vc in anArray) {
		UINavigationController* nc = (UINavigationController*)vc;
		
		if ([nc isKindOfClass:[UINavigationController class]] && nc.delegate) {
			[self.originalNavigationControllerDelegates addObject:nc.delegate];
		} else {
			[self.originalNavigationControllerDelegates addObject:[NSNull null]];
		}

		if ([nc isKindOfClass:[UINavigationController class]]) {
			nc.delegate = self;
		}

		[self addChildViewController:vc];
		[vc didMoveToParentViewController:self];
	}

	if ([self.viewControllers count] == 0) {
		self.selectedIndex = NSNotFound;
		return;
	}
	
	//todo only do this if using the default buttons
	/*
	for (int i=0; i<[self.viewControllers count]; ++i) {
		[[self.buttons objectAtIndex:i] setTitle:((UIViewController*)[self.viewControllers objectAtIndex:i]).title forState:UIControlStateNormal];
	}
	*/

	//Documented behavoir for UITabBarController -setViewControllers:animated: (although we don't do animation) to re-select the tab with the previously selected view controller, if the view controller isn't around anymore, selected the same tab index if there are enough tabs. Otherwise, select tab 0
	//todo need to handle if previously selected more tab
	int posOfPreviousViewControllerInCurrentTabs = [self.viewControllers indexOfObject:self.selectedViewController];
	if (posOfPreviousViewControllerInCurrentTabs != NSNotFound) {
		self.selectedIndex = posOfPreviousViewControllerInCurrentTabs;
	} else {
		self.selectedIndex = 0;
	}
	[self.view setNeedsLayout];
}


- (void)setSelectedViewController:(UIViewController*)aViewController {
	if (self.selectedViewController == aViewController) {
		[self resizeViewController:self.selectedViewController]; // need to resize if we change the tab buttons, but still same tab
		return;
	}

	if (aViewController) {
		[self displayViewController:aViewController];
	}
}


- (void)setSelectedIndex:(int)aNumber force:(BOOL)yesOrNo {
	NSAssert([self.buttons count] == 0 || self.selectedIndex < [self.buttons count], @"Not enough tab buttons");

	if (!yesOrNo && self.selectedIndex == aNumber) return;

	if (aNumber >= [self.viewControllers count]) {
		@throw [NSException exceptionWithName:NSRangeException reason:[NSString stringWithFormat:@"Tab index %d out of range", aNumber] userInfo:nil];
	}

	UIButton* old = [self.buttons objectAtIndex:self.selectedIndex];
	MOTabButton* oldTb = [self.tabButtons objectAtIndex:self.selectedIndex];
	[old setImage:oldTb.normalImage forState:UIControlStateNormal];
	[old setImage:oldTb.highlightedImage forState:UIControlStateHighlighted];

	selectedIndex = aNumber;

	[self createDefaultTabButtons];

	NSAssert(aNumber < [self.buttons count], @"Not enough tab buttons");

	UIButton* new = [self.buttons objectAtIndex:self.selectedIndex];
	MOTabButton* newTb = [self.tabButtons objectAtIndex:self.selectedIndex];
	[new setImage:newTb.highlightedImage forState:UIControlStateNormal];
	[new setImage:newTb.highlightedImage forState:UIControlStateHighlighted];

	self.selectedViewController = [self.viewControllers objectAtIndex:self.selectedIndex];
}


- (void)setSelectedIndex:(int)aNumber {
	[self setSelectedIndex:aNumber force:NO];
}


- (void)setTabButtons:(NSArray*)anArray {
	if (anArray == tabButtons) return;

	if (!anArray) {
		tabButtons = nil;
		return;
	}

	tabButtons = [NSArray arrayWithArray:anArray];
	[self createButtons];

	CGFloat x = 0;
	for (int i=0; i<[self.tabButtons count]; ++i) {
		MOTabButton* tb = [self.tabButtons objectAtIndex:i];
		UIButton* b = [self.buttons objectAtIndex:i];
		b.frame = CGRectMake(x, 0, tb.frame.size.width, tb.frame.size.height);
		b.moBottom = self.view.moHeight;
		if (tb.normalImage) {
			[b setImage:tb.normalImage forState:UIControlStateNormal];
			[b setImage:tb.highlightedImage forState:UIControlStateHighlighted];
			b.backgroundColor = [UIColor clearColor];
		} else {
			b.backgroundColor = tb.backgroundColor;
			[b setTitle:tb.text forState:UIControlStateNormal];
		}
		x += b.frame.size.width;
	}

	[self setSelectedIndex:0 force:YES];
}


- (void)setTabHidden:(BOOL)yesOrNo {
	if (self.tabHidden == yesOrNo) return;

	tabHidden = yesOrNo;

	[UIView animateWithDuration:0.35 animations:^{
		for (UIView* each in self.buttons) {
			each.moLeft += self.view.moWidth * (self.tabHidden? -1: 1);
		}
	}];
}

#pragma mark Button taps

- (void)tabButtonTapped:(int)aNumber {
	NSAssert(aNumber < [self.viewControllers count] && aNumber != NSNotFound, @"Invalid button tapped");

	//Only send -moTabBarController:shouldSelectViewController: for first 5 tabs, including More. But not for the view controllers within more to be consistent with UITabBarController
	if ([self.delegate respondsToSelector:@selector(moTabBarController:shouldSelectViewController:)]) {
		UIViewController* vc = [self.viewControllers objectAtIndex:aNumber];
		if (![self.delegate moTabBarController:self shouldSelectViewController:vc]) return;
	}

	self.selectedIndex = aNumber;

	//According to UITabBarControllerDelegate docs, >= iOS 3.0, delegate called even if tapped on current selection
	if ([self.delegate respondsToSelector:@selector(moTabBarController:didSelectViewController:)]) {
		[self.delegate moTabBarController:self didSelectViewController:self.selectedViewController];
	}
}


- (void)button0Tapped {
	[self tabButtonTapped:0];
}


- (void)button1Tapped {
	[self tabButtonTapped:1];
}


- (void)button2Tapped {
	[self tabButtonTapped:2];
}


- (void)button3Tapped {
	[self tabButtonTapped:3];
}


- (void)button4Tapped {
	[self tabButtonTapped:4];
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController*)navigationController willShowViewController:(UIViewController*)viewController animated:(BOOL)animated {
	BOOL hideTabs = NO;
	for (UIViewController* each in navigationController.viewControllers) {
		if (each.hidesBottomBarWhenPushed) {
			hideTabs = YES;
			break;
		}
	}

	self.tabHidden = hideTabs;
	[self resizeViewController:navigationController];

	id<UINavigationControllerDelegate> d = [self navigationControllerDelegateForViewController:navigationController];
	if ([d respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) [d navigationController:navigationController willShowViewController:viewController animated:animated];
}


- (void)navigationController:(UINavigationController*)navigationController didShowViewController:(UIViewController*)viewController animated:(BOOL)animated {
	id<UINavigationControllerDelegate> d = [self navigationControllerDelegateForViewController:navigationController];
	if ([d respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) [d navigationController:navigationController didShowViewController:viewController animated:animated];
}

@end
