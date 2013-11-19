//
//  CCDetailTaskViewController.h
//  Overdue Task List
//
//  Created by Warren Deshazo on 11/12/13.
//  Copyright (c) 2013 Circboxx LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTask.h"
#import "CCEditTaskViewController.h"

@protocol CCDetailTaskViewControllerDelegate <NSObject>

-(void)updateTask;

@end


@interface CCDetailTaskViewController : UIViewController <CCEditTaskViewControllerDelegate>

@property (strong, nonatomic) id <CCDetailTaskViewControllerDelegate>delegate;
@property (strong,nonatomic) CCTask *task;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
- (IBAction)editButtonPressed:(UIBarButtonItem *)sender;

@end
