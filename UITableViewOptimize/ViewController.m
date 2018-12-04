//
//  ViewController.m
//  UITableViewOptimize
//
//  Created by 索晓晓 on 2017/11/12.
//  Copyright © 2017年 SXiao.RR. All rights reserved.
//

#import "ViewController.h"
#import "FriendsterTableViewCell.h"
#import "FriendsterModel.h"
#import <SDImageCache.h>
#import <SDWebImageManager.h>

//优化一: 复用ID
static NSString *const Identifier = @"DemoTableCellID";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isNeedLoadImage;
    BOOL _isQuickScroll;
    BOOL _isDecelerationing;
    
}
@property (nonatomic ,strong)UITableView *tableView;

@property (nonatomic ,strong)NSMutableArray *dataArray;

@end

@implementation ViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return  _dataArray;
}

- (void)didClearCacheSDImage
{
    //清楚内存图片
    [[SDImageCache sharedImageCache] clearMemory];
    //清理硬盘图片
    __weak typeof(self)wself = self;
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
        [wself.tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isNeedLoadImage = YES;
    
    _isQuickScroll = NO;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(didClearCacheSDImage) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"清空图片缓存" forState:0];
    [btn setBackgroundColor:[UIColor orangeColor]];
    btn.frame = CGRectMake(50, 25, self.view.bounds.size.width - 100, 50);
    [self.view addSubview:btn];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100,self.view.bounds.size.width, self.view.bounds.size.height - 100) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //优化一: 注册Cell  Class
    [_tableView registerClass:[FriendsterTableViewCell class] forCellReuseIdentifier:Identifier];
    
    [self.view addSubview:_tableView];
    
    NSMutableArray *filesArray = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"demoData" ofType:@"plist"]];
    
    for (NSDictionary*dict  in filesArray) {
        
        FriendsterModel *item = [FriendsterModel friendsterWithDict:dict];
        
        if (item.cellType != FriendsterCellTypeNone) {
             [self.dataArray addObject:item];
        }
    }
    
    [_tableView reloadData];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //优化一: 利用复用ID取缓存Cell  注册Cell Class之后取缓存时,没有会自动创建新的Cell所以无需判断是否为nil
    FriendsterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    FriendsterModel *model = self.dataArray[indexPath.row];

        //如果快速滑动 不加载图片
        if (_isQuickScroll) {
            if (_isDecelerationing) {//处于减速中,如果有图片缓存是需要加载的
                NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:model.img_url]];
                UIImage *image =  [[SDImageCache sharedImageCache] imageFromCacheForKey:key];
                if (image) {
                    cell.model = model;
                }else{
                    cell.noImageModel = model;
                }
            }else{
                cell.noImageModel = model;
            }
        }else{
           cell.model = model;
        }
    return cell;
}
//这个方法是返回对应Cell的高度的,可以在数据层计算好每一个Cell的高度,之后直接从缓存中取出来就可以了,因为UITableView的调用之前会先把所有的Cell的高度全部获取一遍,这里就是返回高度的地方,如果在这里大量计算,会延迟TableView的加载
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsterModel *model = self.dataArray[indexPath.row];;
    
    return model.cellHeight;
}

/*
    优化达到的效果
 1: 当用户手动 drag table view 的时候，会加载 cell 中的图片；
 2: 在用户快速滑动的减速过程中，不加载过程中 cell 中的图片（但文字信息还是会被加载，只是减少减速过程中的网络开销和图片加载的开销）；
 3: 在减速结束后，加载所有可见 cell 的图片（如果需要的话）；
 4: 在减速结束后,需要显示的Cell的图片要优先下载.

 scrollViewWillBeginDragging 即将开始拖拽
 scrollViewWillEndDragging: withVelocity: targetContentOffset: 即将停止拖拽
 scrollViewDidEndDecelerating 已经停止减速
 
 进一步优化
 1: 如果内存中有图片的缓存，减速过程中也会加载该图片
 2: 如果图片属于 targetContentOffset 能看到的 cell，正常加载，这样一来，快速滚动的最后一屏出来的的过程中，用户就能看到目标区域的图片逐渐加载
 */


//即将开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"%s",__func__);
//    _isNeedLoadImage = NO;
}

//即将停止拖动  滚动很快时，只加载目标范围内的Cell，这样按需加载，极大的提高流畅度。
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"%s",__func__);
    //  先获取当前开始减速时第几行
    NSIndexPath *ip = [self.tableView indexPathForRowAtPoint:CGPointMake(0, targetContentOffset->y)];

    NSIndexPath *cip = [[self.tableView indexPathsForVisibleRows] firstObject];

    NSLog(@"%@",ip);
    NSLog(@"%@",cip);

    NSInteger skipCount = 6;//判断快速滑动的cell跨越的数量

    if (labs(cip.row-ip.row)>skipCount) {
        _isQuickScroll = YES;
    }else{
        _isQuickScroll = NO;
    }
    
    
}
//即将开始减速
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%s",__func__);
    _isDecelerationing = YES;
    
}


//已经停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%s",__func__);
     _isNeedLoadImage = YES;
    _isDecelerationing = NO;
    _isQuickScroll = NO;
    //刷新当前屏幕可见CEll
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
