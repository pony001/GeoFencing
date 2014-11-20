//
//  SLLocation.m
//  GeoFencing
//
//  Created by Lei on 11/20/14.
//  Copyright (c) 2014 Lei. All rights reserved.
//

#import "SLLocation.h"
#import <CoreLocation/CoreLocation.h>

@implementation SLLocation

- (id)initWithCLLocation:(CLLocation *)cllocation {
    if (self = [super init]) {
        _latitude = cllocation.coordinate.latitude;
        _longitude = cllocation.coordinate.longitude;
        _altitude = cllocation.altitude;
        _horizontalAccuracy = cllocation.horizontalAccuracy;
        _verticalAccuracy = cllocation.verticalAccuracy;
        _timestamp = cllocation.timestamp;
    }
    return self;
}

@end
