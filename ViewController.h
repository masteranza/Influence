//
//  ViewController.h
//  Influence
//
//  Created by Michal Mandrysz on 27/04/2013.
//  Copyright (c) 2013 Michal Mandrysz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BreadcrumbView.h"

@interface ViewController : UIViewController <UIScrollViewDelegate, BreadcrumbDelegate>
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) MasterViewController* viewCandidate;
@property (strong, nonatomic) BreadcrumbView* breadcrumb;

-(void) removeOldViewControllers;
@end
