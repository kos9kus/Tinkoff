//
//  KKDetailedViewController.m
//  Tinkoff
//
//  Created by KONSTANTIN KUSAINOV on 30/06/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import "KKDetailedViewController.h"
#import "Item.h"
#import "Partner.h"

@interface KKDetailedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray <NSString*> *dataModel;

@end

@implementation KKDetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.item) {
        self.dataModel = [self createDataForTable];
    }
    
    self.tableView.rowHeight =  UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.f;
}


- (NSArray <NSString*> *)createDataForTable {
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:self.item.partnerName];
    [array addObject:self.item.fullAddress];
    [array addObject:self.item.partner.name];
    [array addObject:self.item.partner.url];
    [array addObject:self.item.partner.limitations];
    [array addObject:self.item.partner.depositionDuration];
    [array addObject:self.item.partner.descriptionItem];
    
    
    return [array copy];
}

#pragma mrak - Table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKDetailedTableCellId"];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = self.dataModel[indexPath.row];
    
    return cell;
}

@end
