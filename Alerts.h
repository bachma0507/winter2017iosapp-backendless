//
//  Alerts.h
//  Winter2016IOSApp
//
//  Created by Barry on 4/2/16.
//  Copyright © 2016 BICSI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alerts : NSObject
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic, strong) NSDate *updated;
@end