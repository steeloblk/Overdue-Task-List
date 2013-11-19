//
//  CCEditTaskViewController.h
//  Overdue Task List
//
//  Created by Warren Deshazo on 11/12/13.
//  Copyright (c) 2013 Circboxx LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTask.h"

@protocol CCEditTaskViewControllerDelegate <NSObject>

-(void)didUpdateTask;

@end


@interface CCEditTaskViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate>


@property (weak, nonatomic) id <CCEditTaskViewControllerDelegate>delegate;

@property (strong, nonatomic)CCTask *task;

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)saveButtonPresssed:(UIBarButtonItem *)sender;


@end
