//
//  AppDelegate.h
//  Influence
//
//  Created by Michal Mandrysz on 09/03/2013.
//  Copyright (c) 2013 Michal Mandrysz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSMutableArray+Stack.h"
#import "MasterViewController.h"
#import "MNavigationController.h"
#import "DHDialogViewController.h"
#import "CPPickerView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, DHDialogViewControllerDelegate, CPPickerViewDataSource, CPPickerViewDelegate, UIPickerViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableArray* parentStack;
@property (strong, nonatomic) MasterViewController* controller;
@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) DHDialogViewController *dialog;
@property (strong, nonatomic) UIDatePicker* datetimePicker;
@property (weak, nonatomic) Event* loggingEvent;

- (MasterViewController*)currentViewController;
- (void)presentDatetimePicker;
- (void)hideDatetimePicker;
@end
