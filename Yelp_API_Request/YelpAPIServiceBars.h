//
//  YelpAPIServiceBars.h
//  YelpNearby
//
//  Created by Barry on 5/14/14.
//  Copyright (c) 2014 Subh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthConsumer.h"

@protocol YelpAPIServiceDelegate <NSObject>
-(void)loadResultWithDataArray:(NSArray *)resultArray;
@end

@interface YelpAPIServiceBars : NSObject <NSURLConnectionDataDelegate>

@property(nonatomic, strong) NSMutableData *urlRespondData;
@property(nonatomic, strong) NSString *responseString;
@property(nonatomic, strong) NSMutableArray *resultArray;

@property (weak, nonatomic) id <YelpAPIServiceDelegate> delegate;

-(void)searchNearByRestaurantsByFilter:(NSString *)categoryFilter atLatitude:(CLLocationDegrees)latitude
                          andLongitude:(CLLocationDegrees)longitude;

@end
