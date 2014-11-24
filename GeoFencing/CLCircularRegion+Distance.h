//
//  CLCircularRegion+Distance.h
//  GeoFencing
//
//  Created by Lei on 11/24/14.
//  Copyright (c) 2014 Lei. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLCircularRegion (Distance)

- (CLLocationDistance)distanceFromRegion:(CLCircularRegion *)region;

@end
