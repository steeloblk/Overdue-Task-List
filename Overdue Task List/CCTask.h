//
//  CCTask.h
//  Overdue Task List
//
//  Created by Warren Deshazo on 11/14/13.
//  Copyright (c) 2013 Circboxx LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCTask : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) BOOL isCompleted;

-(id)initWithData:(NSDictionary *)data;

@end
