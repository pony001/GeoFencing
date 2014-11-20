//
//  ViewController.m
//  GeoFencing
//
//  Created by Lei on 11/20/14.
//  Copyright (c) 2014 Lei. All rights reserved.
//

#import "ViewController.h"
#import "SLLocation.h"
#import <MapKit/MapKit.h>
#import <Realm.h>

@interface ViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) RLMResults *locationArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mapView.delegate = self;
    [self drawMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)RefreshPressed:(id)sender {
    [self drawMap];
}

- (void)drawMap {
    _locationArray = [SLLocation allObjects];
    [self drawPolyLine];
    [self centerMap];
}

- (void)drawPolyLine {
    NSInteger count = _locationArray.count;
    if (count < 1) {
        return;
    }
    MKMapPoint points[count];
    for (int i = 0; i < count; i++) {
        SLLocation *location = [_locationArray objectAtIndex:i];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(location.latitude, location.longitude);
        points[i] = MKMapPointForCoordinate(coord);
    }
    
    MKPolyline *line = [MKPolyline polylineWithPoints:points count:count];
    [_mapView addOverlay:line];
}

- (void)centerMap
{
    //如果今天没有 location 直接返回
    if (_locationArray.count == 0) {
        return;
    }
    
    MKCoordinateRegion region;
    
    CLLocationDegrees maxLat = -90;
    CLLocationDegrees maxLon = -180;
    CLLocationDegrees minLat = 90;
    CLLocationDegrees minLon = 180;
    
    for (SLLocation *location in _locationArray) {
        if (location.latitude > maxLat) {
            maxLat = location.latitude;
        }
        if (location.latitude < minLat) {
            minLat = location.latitude;
        }
        if (location.longitude > maxLon) {
            maxLon = location.longitude;
        }
        if (location.longitude < minLon) {
            minLon = location.longitude;
        }
        
    }
    
    CLLocationDegrees latitudeDelta = (maxLat - minLat)/0.8;
    CLLocationDegrees longitudeDelta = (maxLon - minLon)/0.8;
    
    if (latitudeDelta > 360) {
        latitudeDelta = 360;
    }
    if (longitudeDelta > 360) {
        longitudeDelta = 360;
    }
    
    if (latitudeDelta < 0.0001) {
        latitudeDelta = 0.0001;
    }
    
    if (longitudeDelta < 0.0001) {
        longitudeDelta = 0.0001;
    }
    
    region.center.latitude = (maxLat + minLat)/2;
    region.center.longitude = (maxLon + minLon)/2;
    region.span.latitudeDelta = latitudeDelta;
    region.span.longitudeDelta = longitudeDelta;
    
    [_mapView setRegion:region animated:YES];
}


#pragma mark - MKMapViewDelegate
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.strokeColor = [UIColor blueColor];
        routeRenderer.lineWidth = 2.0;
        return routeRenderer;
    }
    return nil;
}

@end
