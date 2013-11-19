//
//  CCAddTaskViewController.m
//  Overdue Task List
//
//  Created by Warren Deshazo on 11/12/13.
//  Copyright (c) 2013 Circboxx LLC. All rights reserved.
//

#import "CCAddTaskViewController.h"

@interface CCAddTaskViewController ()

@end

@implementation CCAddTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.textView.delegate = self;
    self.textField.delegate =self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark  return new task helper

-(CCTask *)returnNewTaskObject;
{
    CCTask *taskObject = [[CCTask alloc]init];
    taskObject.title = self.textField.text;
    taskObject.description = self.textView.text;
    taskObject.date = self.datePicker.date;
    taskObject.isCompleted = NO;
    
    // good place to check whether the user has entered info and not entered blank data
    
    return taskObject;
}

#pragma mark - UITextFiedDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField

{
    [self.textField resignFirstResponder];
    return YES;
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        [self.textField resignFirstResponder];
        return NO;
    }
    return YES;
}



#pragma mark Buttons Pressed

- (IBAction)addTaskButtonPressed:(UIButton *)sender {
    
    [self.delegate didAddTask:self.returnNewTaskObject];
    
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    
    [self.delegate didCancel];
}
@end