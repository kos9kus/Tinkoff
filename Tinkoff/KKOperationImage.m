//
//  KKOperationImage.m
//  Tinkoff
//
//  Created by KONSTANTIN KUSAINOV on 29/06/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import "KKOperationImage.h"
#import "KKNetworkManager.h"

@import MapKit;

#define KKOperationImageImageURL @"https://static.tinkoff.ru/icons/deposition-partners-v3/%@/%@"

@interface KKOperationImage ()
@property (nonatomic, strong) MKAnnotationView *annotation;
@property (nonatomic, strong) NSURL *urlImage;
@property (nonatomic, strong) UIImage *image;
@end

@implementation KKOperationImage

- (id)initWithAnnotaion:(MKAnnotationView*)annotation imageFileName:(NSString*)imageFileName typeDpi:(KKOperationImageType)typeDpi {
    self = [super init];
    if (self) {
        self.urlImage = [NSURL URLWithString:[NSString stringWithFormat:KKOperationImageImageURL, [self stringDpiFromType:typeDpi], imageFileName] ];
        self.annotation = annotation;
        self.image = [UIImage imageNamed:@"defaultLogo"]; // default image;
    }
    return self;
}

- (void)main {
    if (![self isCancelled]) {
        UIImage *image = [self loadImage];
        if (![self isCancelled]) {
            [self presentImage:image];
        }
    }
}

#pragma mark - Private

- (void)setImage {
    if (![self isCancelled]) {
        self.annotation.image = self.image;
    }
}

- (void)presentImage:(UIImage*)image {
    if (image) {
        [self resizeImageFromImage:image];
    } else {
        [self resizeImageFromImage:self.image];
    }
    [self performSelectorOnMainThread:@selector(setImage) withObject:nil waitUntilDone:NO];
}

- (UIImage*)loadImage {
    KKNetworkManager *netManager = [KKNetworkManager new];
    NSData *data = [netManager makeSyncRequestRegardCacheWithUrl:self.urlImage];
    if (!data || data.length == 0) {
        return nil;
    }
    UIImage *img = [[UIImage alloc] initWithData:data];
    return img;
}

- (void)resizeImageFromImage:(UIImage*)image {
    CGSize size = CGSizeMake(30, 30);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (NSString*)stringDpiFromType:(KKOperationImageType)type {
    switch (type) {
        case KKOperationImageTypeMDPI:
            return @"mdpi";
            break;
        case KKOperationImageTypeHDPI:
            return @"hdpi";
            break;
        case KKOperationImageTypeXHDPI:
            return @"xhdpi";
            break;
        case KKOperationImageTypeXXHDPI:
            return @"xxhdpi";
            break;
    }
}

@end
