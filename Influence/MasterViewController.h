//
//  MasterViewController.h
//  Influence
//
//  Created by Michal Mandrysz on 09/03/2013.
//  Copyright (c) 2013 Michal Mandrysz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@class DetailViewController;
@class AppDelegate;
#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController<NSFetchedResultsControllerDelegate>
{
    BOOL insertMode;
    NSIndexPath *editableCell;
}
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

-(void)forward:(UIGestureRecognizer*) gesture;
-(void)backwardAction;
-(void)backward:(id)sender;
-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
-(void)setEditableCell:(NSIndexPath*) index;
@end
