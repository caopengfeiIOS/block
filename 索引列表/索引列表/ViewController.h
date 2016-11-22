//
//  ViewController.h
//  索引列表
//
//  Created by hbgl on 16/8/19.
//  Copyright © 2016年 hbgl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView * tableView;

@end

