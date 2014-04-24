//
//  User.h
//  Voluncruit
//
//  Created by Marissa McDowell on 4/21/14.
//  Copyright (c) 2014 CityWhisk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface User : NSObject


@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, assign) int missionsCompleted;
@property (nonatomic, assign) int badges;
@property (strong, nonatomic) FBProfilePictureView *profilePicture;
@property (strong, nonatomic) NSMutableArray *upcomingMissions;
@property (strong, nonatomic) NSMutableArray *friends;

@end
