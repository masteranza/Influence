//
//  NSMutableArray+Stack.m
//  Influence
//
//  Created by Michal Mandrysz on 09/03/2013.
//  Copyright (c) 2013 Michal Mandrysz. All rights reserved.
//

#import "NSMutableArray+Stack.h"

@implementation NSMutableArray (Stack)

- (void)push:(id)anObject
{
    NSLog(@"Push");
    [self addObject:anObject];
}
- (id)pop
{
    NSLog(@"Pop");
    id obj = nil;
    if(self.count > 0)
    {
        obj = [self lastObject];
        [self removeLastObject];
    }
    return obj;
}

- (id)peek
{
    NSLog(@"Peek %d", self.count);
    id obj = nil;
    if(self.count > 0)
    {
        obj = [self lastObject];
    }
    return obj;
}
- (void)clear
{
    [self removeAllObjects];
}
- (BOOL)notEmpty
{
    return self.count> 0;
}
@end
