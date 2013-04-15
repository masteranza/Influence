//
//  NewCell.m
//  Influence
//
//  Created by Michal Mandrysz on 17/03/2013.
//  Copyright (c) 2013 Michal Mandrysz. All rights reserved.
//

#import "Cell.h"
#import "CoreOperations.h"
@implementation Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.txtField=[[UITextField alloc]initWithFrame:CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-10)];

        self.txtField.autoresizesSubviews=YES;
        [self.txtField setPlaceholder:@"Type name here"];
        self.txtField.delegate = self;
        self.txtField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.contentView addSubview:self.txtField];
        //txtField.layer.cornerRadius=10.0;
        //[self.txtField setBorderStyle:UITextBorderStyleLine];
        [self setEditMode:NO];
    }
    return self;
}

- (void)setEditMode:(BOOL)editMode
{
    _editMode = editMode;
    self.txtField.enabled = editMode;
    if(editMode) [self.txtField becomeFirstResponder];
    else [self.txtField resignFirstResponder];
    NSLog(@"Set editing on %@ to %@", self.event.name, editMode?@"YES":@"NO");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.event.name  =textField.text;
    [self setEditMode:NO];
    [[CoreOperations sharedManager] saveContext];
    return NO;
}

-(void) setEvent:(Event *)event
{
    _event = event;
    self.txtField.text = event.name;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
