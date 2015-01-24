//
//  MapMyLocationViewController.h
//  UVX2
//
//  Created by Laure Linn on 8/21/14.
//  Copyright (c) 2014 LAL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Common.h"

#define INSERT 10

@interface MapMyLocationViewController : UIViewController <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;
@property (nonatomic, strong) NSMutableString *log;

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) NSDateFormatter *hourlyFormatter;
@property (nonatomic, strong) NSDateFormatter *dailyFormatter;

@property (nonatomic, strong) NSString *currentHour;
@property (nonatomic, strong) UIView *header;

@property (nonatomic, strong) UIView *circle;
@property (nonatomic, strong) UILabel *circleLabel;

@property double latitude;
@property double longitude;

@property double altitude;
@property double horizontalAccuracy;
@property double verticalAccuracy;

@end
