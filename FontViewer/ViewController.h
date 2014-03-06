//
//  ViewController.h
//  FontViewer
//
//  Created by 蒋承军 on 14-3-6.
//  Copyright (c) 2014年 蒋承军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
