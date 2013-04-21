//
//  MNavigationController.m
//  Influence
//
//  Created by Michal Mandrysz on 08/04/2013.
//  Copyright (c) 2013 Michal Mandrysz. All rights reserved.
//

#import "MNavigationController.h"
#import "MasterViewController.h"
@interface MNavigationController ()

@end

@implementation MNavigationController

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{

//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration: 1.00];
//    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp
//                           forView:self.view cache:NO];
//    
    
    UIViewController *viewController = [self.viewControllers lastObject];
    if ([viewController isKindOfClass:[MasterViewController class]])
        [((MasterViewController*)viewController) backwardAction];

    
    return [super popViewControllerAnimated:YES];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
