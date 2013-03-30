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

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
    BOOL insertMode;
}
@property (strong, nonatomic) AppDelegate *appDelegate;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)back:(id)sender;
@end
