//
//  ServiceConnector.h
//  Voluncruit
//
//  Created by Marissa McDowell on 4/23/14.
//  Copyright (c) 2014 CityWhisk. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ServiceConnectorDelegate <NSObject>
-(void)requestReturnedData:(NSData*)data;

@end

@interface ServiceConnector : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate>
@property (strong,nonatomic) id <ServiceConnectorDelegate> delegate;

-(void)postTestWithLat:(float )lat andLon:(float )lon andID:(int )fbID;
@end