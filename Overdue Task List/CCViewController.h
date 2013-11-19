//
//  CCViewController.h
//  Overdue Task List
//
//  Created by Warren Deshazo on 11/12/13.
//  Copyright (c) 2013 Circboxx LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCAddTaskViewController.h"
#import "CCDetailTaskViewController.h"

@interface CCViewController : UIViewController <CCAddTaskViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, CCDetailTaskViewControllerDelegate>

- (IBAction)reorderButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)addTaskButtonPressed:(UIBarButtonItem *)sender;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *taskObjects;


@end
