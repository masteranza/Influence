//
//  NSMutableArray+Stack.h
//  Influence
//
//  Created by Michal Mandrysz on 09/03/2013.
//  Copyright (c) 2013 Michal Mandrysz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Stack)
- (void)push:(id)anObject;
- (id)pop;
- (id)peek;
- (void)clear;
- (BOOL) notEmpty;
@end
