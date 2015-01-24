//
//  MapMyLocationViewController.m
//  UVX2
//
//  Created by Laure Linn on 8/21/14.
//  Copyright (c) 2014 LAL. All rights reserved.
//

/*
 You can overlay a view on top of the map view. It should not be a subview of the map view, but of its superview - but in front of the map view. If the overlay view has a translucent background color, we can see through it. If the overlay view has user interactions disabled (userInteractionEnabled = NO), touches will fall through to the map view - as if the overlay view weren't there, which is exactly what you seem to want. In other words, it will appear as if the map itself is shaded by your translucent color.
 
 This has nothing to do with map view or mkoverlay. You should fix your tags accordingly. This is simply a question about overlaying any view with a color cast or other visual modification.
 */

#import "MapMyLocationViewController.h"

#define ALPHA_1 .1

@interface MapMyLocationViewController ()

@end

@implementation MapMyLocationViewController

@synthesize mapView, header, circle, circleLabel, log;
@synthesize backgroundImageView, blurredImageView, tableView, screenHeight, hourlyFormatter, dailyFormatter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// NSDateFormatter objects are expensive to initialize, but by placing
// them in the init method you’ll ensure they’re only initialized once.
- (id)init
{
    if (self = [super init])
    {
        self.hourlyFormatter = [[NSDateFormatter alloc] init];
        self.hourlyFormatter.dateFormat = @"h a";
        
        self.dailyFormatter = [[NSDateFormatter alloc] init];
        self.dailyFormatter.dateFormat = @"EEEE";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[CLLocationManager requestAlwaysAuthorization];
    
    // Get and store the screen height
    // Needed to display the weather data in a paged manner
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    [self addMap];
    
    [self createPolygonOverlay];
    [self createTableView];
    
    // Set the header of your table to be the same size of your screen
    // This takes advantage of UITableView’s paging which will page the header and the daily and hourly forecast sections
    CGRect headerFrame = [UIScreen mainScreen].bounds;
    
    NSLog(@"%@", @"headerFrame.size.height");
    NSLog(@"@ %f", headerFrame.size.height);
    
    NSLog(@"%@", @"headerFrame.size.width");
    NSLog(@"@ %f", headerFrame.size.width);
    
    CGFloat inset = 10;
    CGFloat topOffset = 70;
    CGFloat temperatureHeight = 40;
    CGFloat cityHeight = 40;
    
    CGFloat toolBarHeight = 44;
    
    CGFloat x;
    CGFloat y;
    CGFloat width;
    CGFloat height;
    
    // Set the current-conditions view as your table header
    self.header = [[UIView alloc] initWithFrame:headerFrame];
    
    // CARTER VIEW
    width = headerFrame.size.width;
    height = 140;
    x = 0;
    y = headerFrame.size.height - (toolBarHeight + height);
    
    CGRect imageViewFrame = CGRectMake(x, y, width, height);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    imageView.image = [Common imageWithColor:[UIColor flatGreenColor]];
    //[self.header addSubview:imageView];
    
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.header;
    
    //////////// CURRENT TEMPERATURE
    
    x = inset;
    y = topOffset;
    width = headerFrame.size.width - (2 * inset);
    height = temperatureHeight;
    CGRect temperatureFrame = CGRectMake(x,y,width,height);
    
    UILabel *temperatureLabel = [[UILabel alloc] initWithFrame:temperatureFrame];
    temperatureLabel.backgroundColor = [UIColor clearColor];
    temperatureLabel.textColor = [UIColor flatGreenColor];
    temperatureLabel.text = @"0°";
    temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:44];
    //[self.header addSubview:temperatureLabel];
    
    // CITY
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, cityHeight)];
    cityLabel.backgroundColor = [UIColor flatGreenColor];
    cityLabel.textColor = [UIColor whiteColor];
    cityLabel.text = @"Loading...";
    cityLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    //[self.header addSubview:cityLabel];
    
    [self.tableView reloadData];
    [self refreshScreen];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
}

- (void)refreshScreen
{
    [self.tableView reloadData];
}

- (void)addMap
{
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.tintColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    _latitude = userLocation.coordinate.latitude;
    _longitude = userLocation.coordinate.longitude;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:_latitude longitude:_longitude];
    
    [self locationStatus:location];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation {
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc]
                                  initWithAnnotation:annotation reuseIdentifier:@"pin"];
    annView.pinColor = MKPinAnnotationColorRed;
    return annView;
}

- (void)createPolygonOverlay {
    
    CLLocationCoordinate2D ccoodsW[4] = { {85.9809906974076,-179.999999644933}, {-80.9793991796858,-179.999999644933}, {-80.97939920061767,0}, {85.9809906974076,0} };
    
    // Add an Polygon Overlay
    MKPolygon *overlay = [MKPolygon polygonWithCoordinates:ccoodsW count:4];
    //[self.mapView addOverlay:overlay];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolygon class]]) {
        
        MKPolygon *polygonOverlay = (MKPolygon *)overlay;
        MKPolygonRenderer *renderer = [[MKPolygonRenderer alloc] initWithPolygon:polygonOverlay];
        
        UIColor *overLayColor = [UIColor whiteColor];
        
        renderer.strokeColor = [UIColor clearColor];
        
        renderer.fillColor = overLayColor;
        renderer.alpha = 0.50;
        
        renderer.lineWidth = 3;
        
        return renderer;
    }
    
    return nil;
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.tableView.pagingEnabled = YES;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

// The table view has two sections, one for hourly forecasts and one for daily
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (! cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger cellCount = [self tableView:self.tableView numberOfRowsInSection:indexPath.section];
    return self.screenHeight / (CGFloat)cellCount;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Get the height of the scroll view and the content offset. Cap the offset at 0
    // so attempting to scroll past the start of the table won’t affect blurring.
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    
    // Divide the offset by the height with a maximum of 1 so that your offset is capped at 100%.
    CGFloat percent = MIN(position / height, 1.0);
    
    // Assign the resulting value to the blur image’s alpha property
    // to change how much of the blurred image you’ll see as you scroll.
    self.blurredImageView.alpha = percent;
}

-(void)write:(NSString *)msg {
    NSLog(@"%@", msg);
    [self.log appendFormat:@"%@\n", msg];
    
    self.logTextView.text = self.log;
    
    CGPoint bottomOffset = CGPointMake(0, [self.logTextView contentSize].height - self.logTextView.frame.size.height);
    
    if (bottomOffset.y > 0)
        [self.logTextView setContentOffset: bottomOffset animated: YES];
}

- (void)locationStatus:(CLLocation *)location {
    [self write:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    
    // Last Location
    [self write:[NSString stringWithFormat: @"Latitude: %f", location.coordinate.latitude]];
    [self write:[NSString stringWithFormat: @"Longitude: %f", location.coordinate.longitude]];
    [self write:[NSString stringWithFormat: @"Altitude: %f", location.altitude]];
    
    // Last Location Accuracy
    [self write:[NSString stringWithFormat: @"Horizontal Accuracy: %f", location.horizontalAccuracy]];
    [self write:[NSString stringWithFormat: @"Vertical Accuracy: %f", location.verticalAccuracy]];
    
    // Last Location timestamp
    NSDateFormatter *localTime = [[NSDateFormatter alloc] init];
    [localTime setDateFormat:@"hh:mm:ss a"];
    [localTime setTimeZone:[NSTimeZone localTimeZone]];
    [self write:[NSString stringWithFormat: @"Timestamp: %@", [localTime stringFromDate:location.timestamp]]];
    
    RelativeDateDescriptor *timeDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    // Example Prior Date Description Formats:  @"%@ ago", @"occured %@ ago", @"happend %@ in the past"
    // Example Post Date Description Formats:   @"in %@", @"occuring in %@", @"happening in %@"
    [timeDescriptor setExpressedUnits:RDDTimeUnitHours|RDDTimeUnitMinutes|RDDTimeUnitSeconds];
    NSString *description = [timeDescriptor describeDate:location.timestamp relativeTo:[NSDate date]];
    
    NSString *message = description;
    [self write:[NSString stringWithFormat:@"%@", message]];
    
    [self write:@""];
}

@end
