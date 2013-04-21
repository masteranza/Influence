//
//  NewCell.h
//  Influence
//
//  Created by Michal Mandrysz on 17/03/2013.
//  Copyright (c) 2013 Michal Mandrysz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
@interface Cell : UITableViewCell <UITextFieldDelegate>
@property (nonatomic,weak) Event* event;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UILabel *usedLabel;
@property (nonatomic, strong) UISegmentedControl *impulse;
@property (nonatomic) BOOL editMode;

@end
