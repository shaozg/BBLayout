//
//  CellTableViewController.m
//  BBLayout
//
//  Created by shaozengguang on 2020/3/14.
//  Copyright © 2020 shaozengguang. All rights reserved.
//

#import "CellTableViewController.h"
#import "SongCell.h"

@interface CellTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation CellTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configDataSource];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sCellID = @"SongCell_";
    SongCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellID];
    if (nil == cell) {
        cell = [[SongCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellID];
    }
    
    [cell updateWithDict:self.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

- (void)configDataSource {
    self.dataSource = [NSMutableArray arrayWithCapacity:1];
    NSMutableDictionary *dict = nil;
    int sort = 1;
    for (int i = 0; i < 5; i ++) {
        {
            dict = [NSMutableDictionary dictionary];
            [dict setObject:[NSString stringWithFormat:@"%d", sort] forKey:@"sort"];
            [dict setObject:[NSString stringWithFormat:@"第%d首歌标题-fit", sort] forKey:@"title"];
            [dict setObject:@"副标题-fill" forKey:@"desc"];
            [dict setObject:@"会员" forKey:@"member"];
            [dict setObject:@"高清" forKey:@"qualit"];
            [dict setObject:@(YES) forKey:@"mv"];
            [self.dataSource addObject:dict];
            sort ++;
        }
        {
            dict = [NSMutableDictionary dictionary];
            [dict setObject:[NSString stringWithFormat:@"%d", sort] forKey:@"sort"];
            [dict setObject:[NSString stringWithFormat:@"第%d首歌标题-fit", sort] forKey:@"title"];
            [dict setObject:@"副标题-fill" forKey:@"desc"];
            [dict setObject:@"" forKey:@"member"];
            [dict setObject:@"高清" forKey:@"qualit"];
            [dict setObject:@(YES) forKey:@"mv"];
            [self.dataSource addObject:dict];
            sort ++;
        }
        {
            dict = [NSMutableDictionary dictionary];
            [dict setObject:[NSString stringWithFormat:@"%d", sort] forKey:@"sort"];
            [dict setObject:[NSString stringWithFormat:@"第%d首歌标题-fit", sort] forKey:@"title"];
            [dict setObject:@"副标题-fill" forKey:@"desc"];
            [dict setObject:@"" forKey:@"member"];
            [dict setObject:@"高清" forKey:@"qualit"];
            [dict setObject:@(NO) forKey:@"mv"];
            [self.dataSource addObject:dict];
            sort ++;
        }
        {
            dict = [NSMutableDictionary dictionary];
            [dict setObject:[NSString stringWithFormat:@"%d", sort] forKey:@"sort"];
            [dict setObject:[NSString stringWithFormat:@"第%d首歌标题-fit", sort] forKey:@"title"];
            [dict setObject:@"副标题-fill" forKey:@"desc"];
            [dict setObject:@"" forKey:@"member"];
            [dict setObject:@"" forKey:@"qualit"];
            [dict setObject:@(NO) forKey:@"mv"];
            [self.dataSource addObject:dict];
            sort ++;
        }
    }
    
}

@end
