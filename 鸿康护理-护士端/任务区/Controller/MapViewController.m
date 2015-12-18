//
//  MapViewController.m
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/11/20.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface MapViewController ()<MAMapViewDelegate,AMapSearchDelegate>
{
    UILabel *myAddress;
    AMapSearchAPI *_search;
    MAMapView *_mapView;
}
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.title = @"任务地址";
    self.view.backgroundColor = [UIColor whiteColor];
    [MAMapServices sharedServices].apiKey = GAODEKEY;
    //初始化检索对象
    _mapView = [[MAMapView alloc]init];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(self.view.height*0.6);
    }];
    
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake([_lat floatValue], [_lng floatValue]) animated:YES];

    UILabel *title = [[UILabel alloc]init];
    title.text = [NSString stringWithFormat:@"任务地址:%@",_address];
    title.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE-1];
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.equalTo(self.view).offset(10);
        make.top.equalTo(_mapView.mas_bottom).offset(20);
        make.width.mas_equalTo(self.view.width-20);
    }];
    
    myAddress = [[UILabel alloc]init];
    myAddress.font = [UIFont systemFontOfSize:FONT_SIZE_MIDDLE-1];
    myAddress.text = @"我的位置：";
    myAddress.numberOfLines = 0;
    [self.view addSubview:myAddress];
    [myAddress mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(title.mas_bottom).offset(5);
        make.leading.equalTo(title);
        make.width.equalTo(title);
    }];
    
    MAPointAnnotation *anno = [[MAPointAnnotation alloc]init];
    anno.coordinate = CLLocationCoordinate2DMake([_lat floatValue], [_lng floatValue]);
    anno.title = @"任务地址";
    anno.subtitle = _address;
    [_mapView addAnnotation:anno];

}

#pragma mark - MAMapView delegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    
    MAPinAnnotationView *annoView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnoID"];
    if (annoView == nil) {
        
        annoView = [[MAPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"AnnoID"];
    }
    
    annoView.animatesDrop = YES;
    annoView.canShowCallout = YES;
    annoView.draggable = YES;
    if ([annotation coordinate].latitude == mapView.userLocation.coordinate.latitude && [annotation coordinate].longitude == mapView.userLocation.coordinate.longitude) {
        
        annoView.pinColor = MAPinAnnotationColorGreen;
    }
    return annoView;

}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
    CLLocation *location = userLocation.location;
    _search = [[AMapSearchAPI alloc]init];
    [AMapSearchServices sharedServices].apiKey = GAODEKEY;
    _search.delegate = self;
    
    //构造AMapReGeocodeSearchRequest对象
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];

   regeo.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    regeo.radius = 10000;
    regeo.requireExtension = YES;
    
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeo];
    mapView.showsUserLocation = NO;
    
    AMapDrivingRouteSearchRequest *request = [[AMapDrivingRouteSearchRequest alloc] init];
    request.origin = [AMapGeoPoint locationWithLatitude:[_lat floatValue] longitude:[_lng floatValue]];
    request.destination = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    request.strategy = 2;//距离优先
    request.requireExtension = YES;
    
    //发起路径搜索
    [_search AMapDrivingRouteSearch: request];
}

#pragma mark - AMapSearchDelegate
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    
    myAddress.text = [NSString stringWithFormat:@"我的位置：%@",response.regeocode.formattedAddress];
    
    MAPointAnnotation *anno = [[MAPointAnnotation alloc]init];
    anno.coordinate = _mapView.userLocation.coordinate;
    anno.title = @"我的位置";
    anno.subtitle = response.regeocode.formattedAddress;
    [_mapView addAnnotation:anno];
}

- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response {
    
}
@end
