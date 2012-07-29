//
//  ViewController.m
//  MapViewSample
//
//  Created by Yoshimi Shingai on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "MyAnnotation.h"

static const CGRect kNavigationBarFrame = {
    .origin = { .x = 0.f, .y = 0.f }, .size = { .width = 320.f, .height = 44.f }
};

@interface ViewController ()

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) MyAnnotation *myAnnotation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:kNavigationBarFrame];
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,kNavigationBarFrame.size.height,self.view.frame.size.width,self.view.frame.size.height - kNavigationBarFrame.size.height)];
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    
    [self startReceiveLocation];
}

//♡･*:.｡.♥･*:.｡.♡.｡.:*･ﾟ♥.｡.:*･ﾟ♡.｡.:*･ﾟ♥.｡.:*･ﾟ♡.｡.:*･ﾟ♥.｡.:*･ﾟ♡//
#pragma mark -- move pin to location you want  --
//♡･*:.｡.♥･*:.｡.♡.｡.:*･ﾟ♥.｡.:*･ﾟ♡.｡.:*･ﾟ♥.｡.:*･ﾟ♡.｡.:*･ﾟ♥.｡.:*･ﾟ♡//

- (void)movePinLocationTo:(CLLocationCoordinate2D)coord {
    if (!self.myAnnotation) {
        self.myAnnotation = [[MyAnnotation alloc] initWithCoordinate:coord];
        [self.mapView addAnnotation:self.myAnnotation];
    }
    
    // (*・∀・).｡oO(set a coordinate of the specific location)
    self.myAnnotation.coordinate = coord;
    
    // (*・∀・).｡oO(Specify the position of the center of the map and the display area)
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 200.0f, 200.0f);
    [self.mapView setRegion:region animated:YES];
}

//♡･*:.｡.♥･*:.｡.♡.｡.:*･ﾟ♥.｡.:*･ﾟ♡.｡.:*･ﾟ♥.｡.:*･ﾟ♡.｡.:*･ﾟ♥.｡.:*･ﾟ♡//
#pragma mark --  get the current location --
//♡･*:.｡.♥･*:.｡.♡.｡.:*･ﾟ♥.｡.:*･ﾟ♡.｡.:*･ﾟ♥.｡.:*･ﾟ♡.｡.:*･ﾟ♥.｡.:*･ﾟ♡//

- (void)startReceiveLocation {
    if (nil == self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    self.locationManager.delegate = self;
    
    // (*・∀・).｡oO(start receiving the current Location)
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // (*・∀・).｡oO(get the current location)
    self.currentLocation = newLocation;
    
    // (*・∀・).｡oO(move a pin to the currentLocation)
    [self movePinLocationTo:self.currentLocation.coordinate];
    
    // (*・∀・).｡oO(stop receiving the current Location)
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:@"エラー"
                               message:@"位置情報が取得できませんでした。"
                              delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles: nil]show];
}

//♡･*:.｡.♥･*:.｡.♡.｡.:*･ﾟ♥.｡.:*･ﾟ♡.｡.:*･ﾟ♥.｡.:*･ﾟ♡.｡.:*･ﾟ♥.｡.:*･ﾟ♡//
#pragma mark --  search location by location name --
//♡･*:.｡.♥･*:.｡.♡.｡.:*･ﾟ♥.｡.:*･ﾟ♡.｡.:*･ﾟ♥.｡.:*･ﾟ♡.｡.:*･ﾟ♥.｡.:*･ﾟ♡//

- (void) searchBarSearchButtonClicked: (UISearchBar *) searchBar {
    [searchBar resignFirstResponder];
    
    // (*・∀・).｡oO(show error message if there is only blank)
    if ([[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"エラー"
                                    message:@"住所を入力してください。"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil]show];
        return;
    }
    
    __weak ViewController *weak_self = self;
    self.geocoder = [[CLGeocoder alloc] init];
    [self.geocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray * placemarks, NSError * error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"エラー"
                                        message:@"場所が取得できませんでした。"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil]show];
            return;
        }
        if ([placemarks count] == 0) {
            [[[UIAlertView alloc] initWithTitle:@"エラー"
                                        message:@"該当する場所がありません。"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil]show];
            return;
        }
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        CLLocationCoordinate2D coord = placemark.location.coordinate;
        [weak_self movePinLocationTo:coord];
    }
     ];
}

@end
