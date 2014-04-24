//
//  Event.h
//  Voluncruit
//
//  Created by Marissa McDowell on 4/18/14.
//  Copyright (c) 2014 CityWhisk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *hostname;
@property (nonatomic, copy) NSString *hostorg;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSDate *time;
@property (nonatomic, copy) NSString *eventPicFile;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, assign) int attendees;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, copy) NSString *servicetypeid;
@property (nonatomic, copy) NSString *serviceType;
@property (nonatomic, assign) double distance;  // used for sorting
@property (nonatomic, assign) int eid;

@end
