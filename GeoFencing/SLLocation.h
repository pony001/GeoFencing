//
//  SLLocation.h
//  GeoFencing
//
//  Created by Lei on 11/20/14.
//  Copyright (c) 2014 Lei. All rights reserved.
//

#import <Realm/Realm.h>

@class CLLocation;

@interface SLLocation : RLMObject

@property double latitude;
@property double longitude;
@property double altitude;
@property double horizontalAccuracy;
@property double verticalAccuracy;
@property NSDate *timestamp;

- (id)initWithCLLocation:(CLLocation *)cllocation;

@end

RLM_ARRAY_TYPE(SLLocation)
