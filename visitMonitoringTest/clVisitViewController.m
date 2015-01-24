//
//  clVisitViewController.m
//  TestApp
//
//  Created by Steve Schauer on 6/18/14.
//  Copyright (c) 2014 Steve Schauer. All rights reserved.
//

#import "clVisitViewController.h"
#import "Storage.h"
#import <MapKit/MapKit.h>

@interface clVisitViewController ()

@property (nonatomic, strong) NSDate *previousDeparture;
@property (nonatomic, strong) NSDate *nextArrival;

@property (nonatomic, strong) NSString *departureText;
@property (nonatomic, strong) NSString *nextDepartureText;
@property (nonatomic, strong) NSString *previousDepartureText;

@property (nonatomic, strong) NSString *arrivalText;
@property (nonatomic, strong) NSString *nextArrivalText;

@property (nonatomic, strong) NSString *transportTime;
@property (nonatomic, strong) NSString *visitTime;

@property (weak, nonatomic) IBOutlet UILabel *transportTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *arrivalLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *previousDepartureLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextArrivalLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextDepartureLabel;

@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (assign) int visitIndex;

@end

@implementation clVisitViewController

#define METERS_PER_MILE 1609.344

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _visitIndex = [[Storage store] visitCount]-1;

    UISwipeGestureRecognizer *gr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showNextVisit)];
    [gr setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:gr];
    
    gr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPreviousVisit)];
    [gr setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:gr];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showLastVisit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideAll
{
    [_arrivalLabel setHidden:YES];
    [_departureLabel setHidden:YES];
    [_visitTimeLabel setHidden:YES];
    [_transportTimeLabel setHidden:YES];
    [_timeStampLabel setHidden:YES];
    [_visitNumberLabel setHidden:YES];
    [_previousDepartureLabel setHidden:YES];
    [_nextArrivalLabel setHidden:YES];
    [_nextDepartureLabel setHidden:YES];
    [_mapView setHidden:YES];
}

- (void)showAll
{
    [_arrivalLabel setHidden:NO];
    [_departureLabel setHidden:NO];
    [_visitTimeLabel setHidden:NO];
    [_transportTimeLabel setHidden:NO];
    [_timeStampLabel setHidden:NO];
    [_visitNumberLabel setHidden:NO];
    [_previousDepartureLabel setHidden:NO];
    [_nextArrivalLabel setHidden:NO];
    [_nextDepartureLabel setHidden:NO];
    [_mapView setHidden:NO];
}

- (void)showVisitContext {
    
    // Format Labels to local date / time
    NSDateFormatter *df = [CLVisitLog dateFormatter_clVisit_LocalTime];
    NSDateFormatter *dfLocal = [Common dateFormatter_localDateTime];
    NSDateFormatter *df_LocalDate = [Common dateFormatter_localDate];
    
    // Format the distant past and future dates for comparison
    NSDate *distantPast_UTC = [NSDate distantPast];
    NSString *distantPast = [df_LocalDate stringFromDate:distantPast_UTC];
    
    NSDate *distantFuture_UTC = [NSDate distantFuture];
    NSString *distantFuture = [df_LocalDate stringFromDate:distantFuture_UTC];

    // Previous Visit
    NSDictionary *info = [[Storage store] visitAtIndex:_visitIndex-1];
    if (info) {
        
        NSDate *previousDeparture = [df dateFromString:info[@"departureDate"]];
        NSString *previousDepartureString = [dfLocal stringFromDate:previousDeparture];
        
        NSDateFormatter *df_LocalDate = [Common dateFormatter_localDate];
        NSString *departureDistantFormat = [df_LocalDate stringFromDate:previousDeparture];
        
        // Format Labels
        if ([departureDistantFormat isEqualToString:distantFuture]) _previousDepartureText = nil;
        else _previousDepartureText = previousDepartureString;
        _previousDeparture = previousDeparture;
        
    } else {
        _previousDepartureText = nil;
        _previousDeparture = nil;
    }
    
    [_previousDepartureLabel setText:_previousDepartureText];
    
    // Next Visit
    info = [[Storage store] visitAtIndex:_visitIndex+1];
    if (info) {
        
        NSDate *nextArrival = [df dateFromString:info[@"arrivalDate"]];
        NSString *nextArrivalString = [dfLocal stringFromDate:nextArrival];
        
        NSDate *nextDeparture = [df dateFromString:info[@"departureDate"]];
        NSString *nextDepartureString = [dfLocal stringFromDate:nextDeparture];
        
        NSString *departureDistantFormat = [df_LocalDate stringFromDate:nextDeparture];
        NSString *arrivalDistantFormat = [df_LocalDate stringFromDate:nextArrival];
        
        if ([departureDistantFormat isEqualToString:distantFuture]) _nextDepartureText = @"Distant Future";
        else _nextDepartureText = nextDepartureString;
        
        if ([arrivalDistantFormat isEqualToString:distantPast]) _nextArrivalText = @"Distant Past";
        else _nextArrivalText = nextArrivalString;
        
        _nextArrival = nextArrival;
        
    } else {
        
        _nextArrivalText = nil;
        _nextDepartureText = nil;
        _nextArrival = nil;
    }
    
    [_nextArrivalLabel setText:_nextArrivalText];
    [_nextDepartureLabel setText:_nextDepartureText];
}

- (IBAction) showPreviousVisit
{
    NSDictionary *info = [[Storage store] visitAtIndex:_visitIndex-1];
    if (info) {
        _visitIndex--;
        [self showVisit:info];
    }
}

- (IBAction) showNextVisit
{
    NSDictionary *info = [[Storage store] visitAtIndex:_visitIndex+1];
    if (info) {
        _visitIndex++;
        [self showVisit:info];
    }
}

- (void) showLastVisit
{
    _visitIndex = [[Storage store] visitCount]-1;
    [self showVisit:[[Storage store] visitAtIndex:_visitIndex]];
}

- (void) showVisit: (NSDictionary *)visitInfo
{
    if (visitInfo) {

        [self showAll];

        NSString *title = [NSString stringWithFormat:@"Visit #%d",_visitIndex+1];
        [_visitNumberLabel setText:title];
        
        // Format Labels to local date / time
        NSDateFormatter *df = [CLVisitLog dateFormatter_clVisit_LocalTime];
        NSDate *arrival = [df dateFromString:visitInfo[@"arrivalDate"]];
        NSDate *departure = [df dateFromString:visitInfo[@"departureDate"]];
        
        df = [Common dateFormatter_localDateTime];
        NSString *arrivalString = [df stringFromDate:arrival];
        NSString *departureString = [df stringFromDate:departure];
        
        NSDateFormatter *df_LocalDate = [Common dateFormatter_localDate];
        
        // Format the distant past and future dates for comparison
        NSDate *distantPast_UTC = [NSDate distantPast];
        NSString *distantPast = [df_LocalDate stringFromDate:distantPast_UTC];
        
        NSDate *distantFuture_UTC = [NSDate distantFuture];
        NSString *distantFuture = [df_LocalDate stringFromDate:distantFuture_UTC];
        
        NSString *departureDistantFormat = [df_LocalDate stringFromDate:departure];
        NSString *arrivalDistantFormat = [df_LocalDate stringFromDate:arrival];
        
        if ([departureDistantFormat isEqualToString:distantFuture]) _departureText = nil;
        else _departureText = departureString;
        [_departureLabel setText:_departureText];
        
        if ([arrivalDistantFormat isEqualToString:distantPast]) _arrivalText = nil;
        else _arrivalText = arrivalString;
        [_arrivalLabel setText:_arrivalText];
        
        [self showVisitContext];
        
        if (_previousDepartureText == nil || [_previousDepartureText isEqualToString:@"Distant Future"]) {
            
            [_visitTimeLabel setText:[Common computeDurationStringWithDate1:arrival date2:departure]];
            [_transportTimeLabel setText:nil];

        } else {
            
            [_visitTimeLabel setText:nil];
            [_transportTimeLabel setText:[Common computeDurationStringWithDate1:_previousDeparture date2:arrival]];
            
        }
        
        [_mapView removeAnnotations:[_mapView annotations]];
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = [visitInfo[@"latitude"] doubleValue];
        zoomLocation.longitude= [visitInfo[@"longitude"] doubleValue];
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, .50*METERS_PER_MILE, 0.50*METERS_PER_MILE);
        
        //MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1.0*METERS_PER_MILE, 0.25*METERS_PER_MILE);
        
        [_mapView setRegion:viewRegion animated:YES];
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:zoomLocation];
        [annotation setTitle:title];
        [_mapView addAnnotation:annotation];
        
    } else {
        [self hideAll];
        [_nextButton setEnabled:NO];
        [_previousButton setEnabled:NO];
    }
}

@end
