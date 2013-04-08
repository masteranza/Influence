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

@interface AppDelegate : UIResponder <UIApplicationDelegate, DHDialogViewControllerDelegate, CPPickerViewDataSource, CPPickerViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableArray* parentStack;
@property (strong, nonatomic) MasterViewController* controller;
@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) DHDialogViewController *dialog;
@end
