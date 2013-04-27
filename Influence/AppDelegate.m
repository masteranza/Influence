//
//  AppDelegate.m
//  Influence
//
//  Created by Michal Mandrysz on 09/03/2013.
//  Copyright (c) 2013 Michal Mandrysz. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreOperations.h"
#import "MasterViewController.h"
#import "ViewController.h"
@implementation AppDelegate

- (void)presentDatetimePicker
{
	self.datetimePicker.layer.zPosition = 99999;
	CGRect startFrame = self.datetimePicker.frame;
	CGRect endFrame = self.datetimePicker.frame;
	startFrame.origin.y = self.controller.view.frame.size.height;
	self.datetimePicker.frame = startFrame;
	[self.controller.view addSubview:self.datetimePicker];
	
	[UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction |UIViewAnimationOptionBeginFromCurrentState
                     animations:^{ CGRect r = self.datetimePicker.frame; r.origin.y= startFrame.origin.y - endFrame.size.height; self.datetimePicker.frame =r; }
                     completion:^(BOOL f) { if(f){}}];
}

- (void)hideDatetimePicker
{
//	if (self.datetimePicker.superview == self.controller.view)
	[UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction |UIViewAnimationOptionBeginFromCurrentState
                     animations:^{ CGRect r = self.datetimePicker.frame; r.origin.y= self.controller.view.frame.size.height; self.datetimePicker.frame =r; }
                     completion:^(BOOL f) { if(f){	[self.datetimePicker removeFromSuperview]; }}];
}

#pragma mark - CPPickerViewDataSource

- (NSInteger)numberOfItemsInPickerView:(CPPickerView *)pickerView
{
    return 100000;
}

- (NSString *)pickerView:(CPPickerView *)pickerView titleForItem:(NSInteger)item
{
    return [NSString stringWithFormat:@"%i", item + 1];
}

#pragma mark - CPPickerViewDelegate
- (void)pickerView:(CPPickerView *)pickerView didSelectItem:(NSInteger)item
{
	
}
///TODO: Add long press to delegate

-(void) log:(int) value withNote:(NSString*) note
{
    Log* log = [[CoreOperations sharedManager] log:value withNote:note For:self.loggingEvent atTime:self.datetimePicker.date];
    if (log)
    {
		NSLog(@"Logged %@!", log);
        //Prompt log success!
    }
}

#pragma mark - DHDialogViewController
- (void)dialog:(DHDialogViewController*)dialog didChangeVisibility:(BOOL)visibleFlag
{
	if(visibleFlag)
	{
		if (!self.datetimePicker)
		{
			self.datetimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 15, 320, 242)];
			self.datetimePicker.datePickerMode = UIDatePickerModeDateAndTime;
			self.datetimePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
			[self.datetimePicker addTarget:self.dialog action:@selector(dateChanged:)
						  forControlEvents:UIControlEventValueChanged];
		}
		//Reset date&time
		[self.datetimePicker setDate:[NSDate date]];
		[self.dialog dateChanged:self.datetimePicker];
	}
	else
	{
		[self.controller.view endEditing:YES];
		[self hideDatetimePicker];
		
	}
	
	//Block scroll while displaying Log popup window
//	self.currentViewController.tableView.scrollEnabled = !visibleFlag;
	self.scrollView.scrollEnabled = !visibleFlag;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.parentStack = [[NSMutableArray alloc] init];
	self.controllerStack = [[NSMutableArray alloc] init];

	self.controller = [[ViewController alloc] init];
	self.controller.view.frame = self.window.frame;
	self.controller.appDelegate = self;
	[self.window setRootViewController:self.controller];
	
	self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavigationBar, 320, self.controller.view.frame.size.height)];
	self.controller.scrollView = self.scrollView;
	self.scrollView.delegate  = self.controller;
    [self.controller.view addSubview:self.scrollView];
	[self.controller.view setBackgroundColor:[UIColor redColor]];
	self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(640, self.controller.view.frame.size.height-NavigationBar); //this must be the appropriate size!
	
	//Init first MasterViewController
	self.mvc  = [[MasterViewController alloc] init];
	self.mvc.view.frame = self.window.frame;
	self.mvc.appDelegate = self;
	[self.scrollView addSubview:self.mvc.view];

    self.dialog = [[DHDialogViewController alloc] initWithContentSize:CGSizeMake(250, 330) forFrame:self.window.frame delegate:self];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [[CoreOperations sharedManager] saveContext];
}
@end
