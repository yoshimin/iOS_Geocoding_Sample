//
//  MyAnnotation.m
//  MapViewSample
//
//  Created by Shingai Yoshimi on 7/28/12.
//
//

#import "MyAnnotation.h"

@implementation MyAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)co
{
    self.coordinate = co;
    return self;
}

@end
