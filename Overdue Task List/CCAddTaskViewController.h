//
//  CCAddTaskViewController.h
//  Overdue Task List
//
//  Created by Warren Deshazo on 11/12/13.
//  Copyright (c) 2013 Circboxx LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTask.h"


@protocol CCAddTaskViewControllerDelegate <NSObject>

@required

-(void)didCancel;
-(void)didAddTask:(CCTask *)task;

@end

@interface CCAddTaskViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak,nonatomic) id <CCAddTaskViewControllerDelegate>delegate;

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)addTaskButtonPressed:(UIButton *)sender;
- (IBAction)cancelButtonPressed:(UIButton *)sender;

@end
