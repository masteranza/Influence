//
//  MasterViewController.m
//  Influence
//
//  Created by Michal Mandrysz on 09/03/2013.
//  Copyright (c) 2013 Michal Mandrysz. All rights reserved.
//

#import "MasterViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "Cell.h"
#import "CoreOperations.h"

@implementation MasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UISwipeGestureRecognizer *g = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(forward:)];
    g.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:g];
    
    UISwipeGestureRecognizer *g2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backward:)];
    g2.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:g2];
    
    UILongPressGestureRecognizer* l = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.tableView addGestureRecognizer:l];
    
    UITapGestureRecognizer *t= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelEdit)];
    t.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:t];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createEvent:)];
    self.navigationItem.rightBarButtonItem = addButton;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark GESTURES & OPERATIONS
- (void)createEvent:(id)sender
{
    [[CoreOperations sharedManager] createEventForParent:(Event*)[self.appDelegate.parentStack peek]];

    [self setEditableCell:[NSIndexPath indexPathForRow:0 inSection:0]];
}
-(void)longPress:(UILongPressGestureRecognizer*) gesture
{
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (indexPath == nil) return;
    [self setEditableCell:indexPath];
}
-(void)cancelEdit
{
    NSLog(@"Cancel edit");
    [self setEditableCell:nil];
}

- (void) backwardAction
{
    [self.appDelegate.parentStack pop];
    NSLog(@"%d", self.navigationController.viewControllers.count);
    
    MasterViewController * mvc  = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"MVC"];
    mvc.appDelegate = self.appDelegate;
    
    Event* event = ((Event*)[self.appDelegate.parentStack peek]);
    mvc.title = (event?event.name:MvcName);

}
- (void) backward:(UISwipeGestureRecognizer*) gesture
{
    NSLog(@"Parents %d", self.appDelegate.parentStack.count);
    if ([self.appDelegate.parentStack count]>0)
    {
//        [self backwardAction];
        [self.navigationController popViewControllerAnimated:YES];
    }
    NSLog(@"Parents %d after", self.appDelegate.parentStack.count);
}
-(void) forward:(UISwipeGestureRecognizer*) gesture
{
    NSLog(@"Should swipe the hell out of this shit");
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    Event* object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    if (object == nil) return;
    
    [self.appDelegate.parentStack push:object];
    
    MasterViewController * mvc  = [[MasterViewController alloc] init];
    mvc.title = object.name;
    mvc.appDelegate = self.appDelegate;

    [self.appDelegate.navigationController pushViewController:mvc animated:YES];
    NSLog(@"Count %d", self.appDelegate.parentStack.count);    
}

#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Cell* cell = [[Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(Cell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    Event *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.event  =object;
}

#pragma mark EDITING
-(void)setEditableCell:(NSIndexPath*) indexPath
{
    NSLog(@"Setting editable cell to %@", indexPath);
    
    if (editableCell!=nil && ![editableCell isEqual:indexPath])
    {
        ((Cell*)[self.tableView cellForRowAtIndexPath:editableCell]).editMode = NO;
        if ([((Cell*)[self.tableView cellForRowAtIndexPath:editableCell]).txtField.text isEqual:@""])
        {
            [[CoreOperations sharedManager] removeEvent:[self.fetchedResultsController objectAtIndexPath:editableCell]];
        }
        else [[CoreOperations sharedManager] saveContext];
    }
    editableCell = indexPath;
    if (indexPath)
    {
        ((Cell*)[self.tableView cellForRowAtIndexPath:indexPath]).editMode =YES;
        [[self tableView] scrollToRowAtIndexPath:editableCell atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
        [[CoreOperations sharedManager] removeEvent:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.appDelegate.dialog show:YES inContainer:self.view];

}





#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:[[CoreOperations sharedManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    NSLog(@"%d", ((Event*)self.appDelegate.parentStack.peek).depth.intValue);
    NSLog(@"depth == %@ AND parent == %@", [NSNumber numberWithInt:((Event*)self.appDelegate.parentStack.peek).depth.intValue+1], [self.appDelegate.parentStack peek]);
    
    //    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"used" ascending:YES];
    //    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    //    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"depth == %@ AND parent == %@", [NSNumber numberWithInt:((Event*)self.appDelegate.parentStack.peek).depth.intValue+1], [self.appDelegate.parentStack peek] ]];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[CoreOperations sharedManager] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}
@end
