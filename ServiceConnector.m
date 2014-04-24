//
//  ServiceConnector.m
//  Voluncruit
//
//  Created by Marissa McDowell on 4/23/14.
//  Copyright (c) 2014 CityWhisk. All rights reserved.
//

#import "ServiceConnector.h"


@implementation ServiceConnector{
    NSData *receivedData;
}


-(void)postTestWithLat:(float )lat andLon:(float )lon andID:(int )fbID {
    
    //build up the request that is to be sent to the server
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.citywhisk.com/scripts/voluncruit.php"]];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"postValues" forHTTPHeaderField:@"METHOD"];
    
    //create data that will be sent in the post
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[NSNumber numberWithFloat:lat] forKey:@"latitude"];
    [dictionary setValue:[NSNumber numberWithFloat:lon] forKey:@"longitude"];
    [dictionary setValue:[NSNumber numberWithInt:fbID] forKey:@"fbID"];
    
    //serialize the dictionary data as json
    NSData *data = [[dictionary copy] JSONValue];
    
    [request setHTTPBody:data]; //set the data as the post body
    [request addValue:[NSString stringWithFormat:@"%d",data.length] forHTTPHeaderField:@"Content-Length"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(!connection){
        NSLog(@"Connection Failed");
    }
}

@end
