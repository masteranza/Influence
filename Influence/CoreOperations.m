//
//  CoreOperations.m
//  Influence
//
//  Created by Michal Mandrysz on 17/03/2013.
//  Copyright (c) 2013 Michal Mandrysz. All rights reserved.
//

#import "CoreOperations.h"
#import "NSMutableArray+Stack.h"
@implementation CoreOperations
@synthesize managedObjectContext =_managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (id)sharedManager
{
    static CoreOperations *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {

    }
    return self;
}

#pragma mark - Methods

-(void) incrementUsedRecursivelyIn:(Event*) event
{
	event.used = [NSNumber numberWithInt:event.used.intValue+1];

	while (event.parent)
	{
		event = event.parent;
		event.used = [NSNumber numberWithInt:event.used.intValue+1];

	}

}

- (Log*) log:(int) value withNote:(NSString*) note For:(Event*)event atTime:(NSDate*)date
{
    Log* newLog = [NSEntityDescription insertNewObjectForEntityForName:@"Log" inManagedObjectContext:self.managedObjectContext];
    
	[newLog setDate:date];
	[newLog setQuantity:[NSNumber numberWithInt:value]];
	[newLog setNote:note];
	[newLog setEvent:event];
    [self incrementUsedRecursivelyIn:event];
	
    [[CoreOperations sharedManager] saveContext];

    return newLog;
}

-(Event*) createEventForParent:(Event*) parent
{
    Event *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];


	[newEvent setTimeStamp:[NSDate date]];
	[newEvent setUsed:[NSNumber numberWithInt:0]];
    [newEvent setParent:parent];
	[newEvent setDepth:[NSNumber numberWithInt:parent.depth.intValue+1]];
    
    [[CoreOperations sharedManager] saveContext];
    return newEvent;
}

- (void) removeEvent:(Event*)event
{
    [self.managedObjectContext deleteObject:event];
}

-(BOOL) isUnique:(NSString*) taskName andParent:(Event*) parent
{
    NSError *error = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like[cd] %@ AND parent == %@", taskName, parent];
    [request setPredicate:predicate];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];

    return (count==0);
}

-(Event*) getIfExists:(NSString*)name forParent:(Event*) parent
{
    NSError *error = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like[cd] %@ AND parent == %@", name, parent];
    [request setPredicate:predicate];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSArray* found = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    return [found count]==0?nil:found[0];
}

-(Event*) createEventNamed:(NSString*)name forParent:(Event*) parent
{
    Event* newEvent = [self getIfExists:name forParent:parent];
    if (newEvent!=nil) return newEvent;
    
    newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [newEvent setName:name];
    [newEvent setParent:parent];
    [newEvent setTimeStamp:[NSDate date]];
    [newEvent setUsed:[NSNumber numberWithInt:0]];
    [newEvent setDepth:[NSNumber numberWithInt:parent.depth.intValue+1]];
    NSLog(@"created at depth %d", parent.depth.intValue);
    return newEvent;
}

- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *managedObject in items) {
    	[self.managedObjectContext deleteObject:managedObject];
    }
    if (![self.managedObjectContext save:&error]) {
    	NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
}

-(void) createDefaultList
{
//    [self deleteAllObjects:@"Event"];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"events" ofType:@"txt"];
    NSString* fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray* allLinedStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSMutableArray* parentStack = [[NSMutableArray alloc] initWithCapacity:100];
    for (int i=0; i<allLinedStrings.count; i++)
    {
        NSArray* columns = [allLinedStrings[i] componentsSeparatedByString:@"\t"];
		if ([columns[columns.count-1] isEqualToString:@""]) continue;
		
        while ([parentStack count] > columns.count-1) [parentStack pop];
        
        NSLog(@"Creating %@ of parent %@", columns[columns.count-1], [[parentStack peek] name]);
        Event* event = [self createEventNamed:columns[columns.count-1] forParent:[parentStack peek]];
        [parentStack push:event];

    }
    [[CoreOperations sharedManager] saveContext];
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Influence" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Influence.sqlite"];
    
    NSError *error = nil;
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
	
    
    //Used to reset the store
    //[[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
	
    return _persistentStoreCoordinator;

}

- (void)saveContext
{
    NSError *error = nil;
 
    if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
