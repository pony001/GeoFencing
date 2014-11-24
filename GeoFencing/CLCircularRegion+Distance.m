//
//  CLCircularRegion+Distance.m
//  GeoFencing
//
//  Created by Lei on 11/24/14.
//  Copyright (c) 2014 Lei. All rights reserved.
//

#import "CLCircularRegion+Distance.h"

@implementation CLCircularRegion (Distance)

- (CLLocationDistance)distanceFromRegion:(CLCircularRegion *)region {
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:self.center.latitude
                                                       longitude:self.center.longitude];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:region.center.latitude
                                                       longitude:region.center.longitude];
    return [location1 distanceFromLocation:location2];
}

@end
