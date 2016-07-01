//
//  ViewController.m
//  Tinkoff
//
//  Created by KONSTANTIN KUSAINOV on 25/06/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import "ViewController.h"
#import "Tinkoff-Swift.h"
#import "KKDataManager.h"
#import "KKAnnotation.h"
#import "Item.h"
#import "Partner.h"
#import "KKOperationImage.h"
#import "KKDetailedViewController.h"

@import MapKit;
@import CoreLocation;

@interface ViewController () <MKMapViewDelegate, KKDataManagerDelegate>

@property (nonatomic, strong) KKDataManager *dataManager;

@property (nonatomic) KKOperationImageType typeDpi;

@property (nonatomic, strong) NSOperationQueue *queue;

@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (nonatomic, strong) NSMutableArray <KKAnnotation*> *points;
@property (nonatomic, strong) Item *selectedItem;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataManager = [KKDataManager new];
    _dataManager.delegate = self;
    
    self.queue = [[NSOperationQueue alloc] init];
    self.queue.maxConcurrentOperationCount = 15;
    
    self.typeDpi =  [[UIDevice currentDevice] dpiType];
    
    [self configureMapView];
}

#pragma mark - Configuration

- (void)configureMapView {
    MKUserTrackingBarButtonItem *buttonItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.map];
    self.navigationItem.leftBarButtonItem = buttonItem;
    [self locationAuthorization];
    self.points = [NSMutableArray array];
    MKCoordinateRegion regionMoscow = MKCoordinateRegionMake(CLLocationCoordinate2DMake(55.755786, 37.617633), MKCoordinateSpanMake(0.009, 0.009));
    [self.map setRegion:regionMoscow animated:NO];
}

- (void)locationAuthorization {
    CLLocationManager *locationManager = [CLLocationManager new];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.map.showsUserLocation = YES;
    } else {
        [locationManager requestWhenInUseAuthorization];
    }
}

#pragma mark - Public

- (void)fetchData:(KKPosition)position {
    if (self.queue.operationCount > 0) {
        [self.queue cancelAllOperations];
    }
    [self enableActivitySpin:YES];
    [self.dataManager didChangePosition:position];
}

#pragma mark - Private

- (void)enableActivitySpin:(BOOL)isEnable {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = isEnable;
}

#pragma mark - Private Handlers

- (void)didTapAnnotation:(UIButton*)senderButton {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    KKDetailedViewController *vc = [sb instantiateViewControllerWithIdentifier:idKKDetailedViewControllerStoryBoard];
    vc.item = self.selectedItem;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - KKDataManagerDelegate

- (void)didFinishLoadDataManager:(KKDataManager *)dataManager {
    if (dataManager == self.dataManager) {
        [self enableActivitySpin:NO];
        if (dataManager.items.count == 0) {
            return;
        }
        [self.map removeAnnotations:self.points];
        [self.points removeAllObjects];
        
        for (Item *objItem in dataManager.items) {
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake([objItem.latitude doubleValue], [objItem.longitude doubleValue]);
            KKAnnotation *a = [[KKAnnotation alloc] initWithLocation:position item:objItem];
            [self.points addObject:a];
        }
        
        [self.map addAnnotations:self.points];
    }
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    MKCoordinateRegion changedRegion = mapView.region;
    
    float radius = changedRegion.span.latitudeDelta * 111 * 500;
    NSLog(@"%f", radius);
    KKPosition pos = KKPositionMake(changedRegion.center.latitude, changedRegion.center.longitude, radius);
    [self fetchData:pos];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[KKAnnotation class]]) {
        static NSString *annotationViewReuseIdentifier = @"annotationViewReuseIdentifier";
        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewReuseIdentifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewReuseIdentifier];
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self action:@selector(didTapAnnotation:) forControlEvents:UIControlEventTouchUpInside];
            annotationView.rightCalloutAccessoryView = rightButton;
        }
        
        KKAnnotation *a = (KKAnnotation*)annotation;
        KKOperationImage *operation = [[KKOperationImage alloc] initWithAnnotaion:annotationView imageFileName:a.item.partner.picture typeDpi:self.typeDpi];
        [self.queue addOperation:operation];
        
        annotationView.image = nil;
        annotationView.annotation = annotation;
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"%@", ((KKAnnotation*)view.annotation).title);
    self.selectedItem = ((KKAnnotation*)view.annotation).item;
}

@end
