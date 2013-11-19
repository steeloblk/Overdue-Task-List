//
//  CCViewController.m
//  Overdue Task List
//
//  Created by Warren Deshazo on 11/12/13.
//  Copyright (c) 2013 Circboxx LLC. All rights reserved.
//

#import "CCViewController.h"

@interface CCViewController ()

@end

@implementation CCViewController

-(NSMutableArray *)taskObjects
{
    if (!_taskObjects) {
        _taskObjects = [[NSMutableArray alloc]init];
    }
    return _taskObjects;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    
    NSArray *tasksAsPropertyLists = [[NSUserDefaults standardUserDefaults]arrayForKey:TASK_OBJECTS_KEY];
    
    for (NSDictionary *dictionary in tasksAsPropertyLists) {
        CCTask *taskObject = [self taskObjectFromDictionary:dictionary];
        [self.taskObjects addObject:taskObject];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[CCAddTaskViewController class]]) {
        CCAddTaskViewController *addTaskViewController = segue.destinationViewController;
        addTaskViewController.delegate = self;
    }
    else if ([segue.destinationViewController isKindOfClass:[CCDetailTaskViewController class]]){
        CCDetailTaskViewController *detailTaskViewController = segue.destinationViewController;
        NSIndexPath *path = sender;
        CCTask *taskObject = self.taskObjects[path.row];
        detailTaskViewController.task = taskObject;
        detailTaskViewController.delegate = self;
    }
}


- (IBAction)reorderButtonPressed:(UIBarButtonItem *)sender {
    if (self.tableView.editing == YES)
        [self.tableView setEditing:NO animated:YES];
        
    else [self.tableView setEditing:YES animated:NO];
}

- (IBAction)addTaskButtonPressed:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"toAddTaskViewControllerSegue" sender:nil];
}

#pragma mark - Color coding

-(BOOL)isDateGreaterThanDueDate:(NSDate *)date and: (NSDate *)toDate
{
    NSTimeInterval dateInterval = [date timeIntervalSince1970];
    NSTimeInterval dueDateInterval = [toDate timeIntervalSince1970];
    if (dateInterval > dueDateInterval) return YES; else return NO;
}

#pragma mark - User completion tap

-(void)UpdateCompletionOfTask:(CCTask *)task forIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *taskObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASK_OBJECTS_KEY]mutableCopy];
    
    if (!taskObjectsAsPropertyLists)
        taskObjectsAsPropertyLists = [[NSMutableArray alloc]init];
    
    [taskObjectsAsPropertyLists removeObjectAtIndex:indexPath.row];
    
    if (task.isCompleted == YES) task.isCompleted = NO;
    else task.isCompleted = YES;
    
    
    [taskObjectsAsPropertyLists insertObject:[self taskObjectAsAPropertyList:task] atIndex:indexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.tableView reloadData];
    
    
}


#pragma mark CCAddTaskViewController Delegate

-(void)didCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didAddTask:(CCTask *)task
{
    [self.taskObjects addObject:task];
    
    NSMutableArray *taskObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASK_OBJECTS_KEY]mutableCopy];
    if (!taskObjectsAsPropertyLists)
        taskObjectsAsPropertyLists = [[NSMutableArray alloc]init];
    
    [taskObjectsAsPropertyLists addObject:[self taskObjectAsAPropertyList:task]];
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

#pragma mark - CCDeailTaskViewControllerDelegate

-(void)updateTask
{
    [self saveTask];
    [self.tableView reloadData];
    
}


#pragma mark - Helper Methods

//convert task list into NSDictionary
-(NSDictionary *)taskObjectAsAPropertyList:(CCTask *)taskObject
{
    NSDictionary *dictionary = @{TASK_TITLE : taskObject.title,TASK_DESCRIPTION : taskObject.description, TASK_DATE : taskObject.date, TASK_COMPLETION : @(taskObject.isCompleted)};
    
    return dictionary;
}

//converts NSDictionary to a task Object
-(CCTask *)taskObjectFromDictionary:(NSDictionary *)dictionary
{
    CCTask *taskObject = [[CCTask alloc]initWithData:dictionary];
    return taskObject;
}

-(void)saveTask
{
    NSMutableArray *taskObjectsAsPropertyLists =[[NSMutableArray alloc]init];
    for (int x=0; x < [self.taskObjects count]; x ++) {
        [taskObjectsAsPropertyLists addObject:[self taskObjectAsAPropertyList:self.taskObjects[x]]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.taskObjects count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //configure the cell....
    CCTask *task = [self.taskObjects objectAtIndex:indexPath.row];
    //or you could have refactored     CCTask *task = [self.taskObjects[indexPath.row];
    
    cell.textLabel.text = task.title;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:task.date];
    cell.detailTextLabel.text = stringFromDate;
    
    BOOL isOverDue = [self isDateGreaterThanDueDate:[NSDate date] and:task.date];
    
    if (task.isCompleted == YES) cell.backgroundColor = [UIColor greenColor];
    else if (isOverDue == YES)
        cell.backgroundColor = [UIColor redColor];
    else cell.backgroundColor = [UIColor yellowColor];
    return cell;
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    CCTask *task = self.taskObjects[indexPath.row];
    [self UpdateCompletionOfTask:task forIndexPath:indexPath];
    
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.taskObjects removeObjectAtIndex:indexPath.row];
        
        NSMutableArray *newTaskObjectsData = [[NSMutableArray alloc] init];
        
        for (CCTask *task in self.taskObjects) {
            [newTaskObjectsData addObject:[self taskObjectAsAPropertyList:task]];
        }
        [[NSUserDefaults standardUserDefaults]setObject:newTaskObjectsData forKey:TASK_OBJECTS_KEY];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toDetailTaskViewControllerSegue" sender:indexPath];
    
    
}
 -(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    CCTask *taskObject = [self.taskObjects objectAtIndex:sourceIndexPath.row];
    /*could be written as
    CCTask *taskObject = [self.taskObjects [sourceIndexPath.row]; */
    [self.taskObjects removeObjectAtIndex:sourceIndexPath.row];
    [self.taskObjects insertObject:taskObject atIndex:destinationIndexPath.row];
    [self saveTask];
}

@end





