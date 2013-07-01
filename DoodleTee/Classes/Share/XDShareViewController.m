//
//  XDShareViewController.m
//  DoodleTee
//
//  Created by xieyajie on 13-7-1.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDShareViewController.h"

#define kSharePlistName @"share"

#define kShareKeyIcon @"icon"
#define kShareKeyName @"name"
#define kShareKeySelector @"selector"

@interface XDShareViewController ()
{
    NSArray *_dataSource;
}

@property (nonatomic, retain) NSArray *dataSource;

@end

@implementation XDShareViewController

@synthesize dataSource = _dataSource;

@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self readInfoFromPlist];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    
    if (nil == cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                       reuseIdentifier: CellIdentifier] autorelease];
    }
    
    NSDictionary *infoDic = [_dataSource objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:[infoDic objectForKey:kShareKeyIcon]];
    cell.textLabel.text = [infoDic objectForKey:kShareKeyName];
        
    return cell;
}

#pragma mark - 读取plist文件

- (void)readInfoFromPlist
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:kSharePlistName ofType:@"plist"];
    _dataSource = [[NSArray alloc] initWithContentsOfFile:plistPath];
}

#pragma mark - public

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}


@end
