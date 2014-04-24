//
//  NewEvent.h
//  Voluncruit
//
//  Created by Marissa McDowell on 4/23/14.
//  Copyright (c) 2014 CityWhisk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewEvent : NSObject

@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSDate *eventDate;
@property (nonatomic, copy) NSDate *eventTime;
@property (nonatomic, copy) NSString *eventAddress;
@property (nonatomic, copy) NSString *eventDescription;
@property (nonatomic, copy) NSString *hostName;
@property (nonatomic, copy) NSString *eventPhone;
@property (nonatomic, copy) NSString *hostEmail;
@property (nonatomic, copy) NSMutableArray *genReqs;
@property (nonatomic, copy) NSMutableArray *ageReqs;
@property (nonatomic, copy) NSMutableArray *bgReqs;
@property (nonatomic, copy) NSMutableArray *physReqs;
@property (nonatomic, copy) NSMutableArray *skillReqs;

@end
