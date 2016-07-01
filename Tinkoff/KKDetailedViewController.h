//
//  KKDetailedViewController.h
//  Tinkoff
//
//  Created by KONSTANTIN KUSAINOV on 30/06/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;

static NSString* const idKKDetailedViewControllerStoryBoard = @"KKDetailedViewControllerSBId";

@interface KKDetailedViewController : UIViewController

@property (nonatomic, strong) Item *item;

@end
