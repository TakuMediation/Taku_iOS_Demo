//
//  ATSelectViewController.m
//  AnyThingSDKDemo
//
//  Created by mac on 2021/12/13.
//

#import "ATSelectViewController.h"

@interface ATSelectViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *list;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic) BOOL multiple;

@property (nonatomic) NSMutableSet *set;

@end

@implementation ATSelectViewController

//- (void)dealloc
//{
//    NSLog(@"%s", __func__);
//}

- (instancetype)initWithSelectList:(NSArray *)list
{
    return [self initWithSelectList:list multipleSelection:NO];
}

- (instancetype)initWithSelectList:(NSArray *)list multipleSelection:(BOOL)multiple {
    if (self = [super init]) {
        _list = list;
        _multiple = multiple;
        _set = [NSMutableSet set];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    
    self.title = @"Select";
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [closeBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:closeBtn];
    self.navigationItem.leftBarButtonItem = btnItem;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (self.multiple) {
        UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [done setTitle:@"Done" forState:UIControlStateNormal];
        [done addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        [done setTitleColor:[UIColor blackColor] forState:0];
        UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:done];
        self.navigationItem.rightBarButtonItem = btnItem;
        
    }
}

#pragma mark - Action
- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done {
    
    if (self.selectBlock) {
        self.selectBlock(self.set.allObjects);
        self.selectBlock = nil;
    }
    [self close];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"select_cell_id"];
    cell.textLabel.text = self.list[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    if (self.multiple) {
        BOOL contain = [self.set containsObject:self.list[indexPath.row]];
        cell.accessoryType = contain ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScaleW(100);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *pid = self.list[indexPath.row];
    if (self.multiple == NO) {
        if (self.selectBlock) {
            self.selectBlock(@[pid]);
            self.selectBlock = nil;
            [self close];
        }
        return;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if ([self.set containsObject:pid]) {
        [self.set removeObject:pid];
        cell.accessoryType = UITableViewCellAccessoryNone;
        return;
    }
    [self.set addObject:pid];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

}

#pragma mark - lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"select_cell_id"];
    }
    return _tableView;
}


@end
