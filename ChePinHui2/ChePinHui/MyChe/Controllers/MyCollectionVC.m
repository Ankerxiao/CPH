//
//  MyCollectionVC.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/19.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "MyCollectionVC.h"
#import "NetManager.h"
#import "CartModel.h"
#import <UIImageView+WebCache.h>

#define SCREENW [UIScreen mainScreen].bounds.size.width

#define API_SERVER @"http://10.11.57.27/mcmp1605/data_enter.php"
#define TO_COLLECT_GOODS @"method=collect_goods&session_id=%@&goods_id=%@"
#define CANCEL_COLLECT_GOODS @"method=cancel_collect_goods&session_id=%@&goods_id=%@"
#define ALL_COLLECT_GOODS @"method=all_collect_goods&session_id=%@"

@interface MyCollectionVC () <UIScrollViewDelegate>
{
    NSMutableArray *_dataArray;
    UIImageView *_imageVX;
}
@property (nonatomic,strong) UIScrollView *backScrollView;
@end

@implementation MyCollectionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(pressRight:)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的收藏";
    
    _dataArray = [NSMutableArray array];
    _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREEN_HEIGHT-113)];
    _backScrollView.delegate = self;
    [self.view addSubview:_backScrollView];
    
    //初始化收藏界面，去请求数据
    [self initCollectionView];
    
}

- (void)initCollectionView
{
    [self getCollectData];
}

- (void)getCollectData
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *str = [NSString stringWithFormat:ALL_COLLECT_GOODS,[ud objectForKey:@"session"]];
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@",API_SERVER,str];
    NSLog(@"%@",urlStr);
    NetManager *nm = [NetManager shareManager];
    [nm requestStrUrl:urlStr withSuccessBlock:^(id data) {
        NSArray *array = data[@"data"][@"collect_list"];
        NSMutableArray *tempArr = [NSMutableArray array];
        for(NSDictionary *dict in array)
        {
            CartModel *model = [[CartModel alloc] initWithDictionary:dict error:nil];
            [tempArr addObject:model];
        }
        _dataArray = tempArr;
        dispatch_async(dispatch_get_main_queue(),^{
            [self refreshCollectView];
        });
    } withFailedBlock:^(NSError *error) {
        
    }];
}

- (void)refreshCollectView
{
    NSInteger count = _dataArray.count;
    for(int i=0;i<count;i++)
    {
        CartModel *model = _dataArray[i];
        NSInteger line = i%2;
        NSInteger row = i/2;
        UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(line*(SCREENW/2), row*(SCREENW/2), SCREENW/2, SCREENW/2)];
        vw.tag = 1000+i;
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENW/2, SCREENW/2-80)];
        [imageV sd_setImageWithURL:[NSURL URLWithString:model.goods_thumb]];
        [vw addSubview:imageV];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame)+5, SCREENW/2, 40)];
        [label setFont:[UIFont systemFontOfSize:15]];
        label.text = model.goods_name;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [vw addSubview:label];
        
        UILabel *priceL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)+10, SCREENW/2, 20)];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",model.goods_price] attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
        priceL.attributedText = attr;
        priceL.textAlignment = NSTextAlignmentCenter;
        [vw addSubview:priceL];
        
        
        //加上X号
        UIImageView *imageVX = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)-45, imageV.frame.origin.y, 40, 40)];
        imageVX.image = [UIImage imageNamed:@"collect_delete"];
        imageVX.alpha = 0;
        imageVX.tag = 10+i;
        imageVX.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [tap addTarget:self action:@selector(pressX:)];
        [imageVX addGestureRecognizer:tap];
        [vw addSubview:imageVX];
        
        [_backScrollView addSubview:vw];
        
    }
    _backScrollView.contentSize = CGSizeMake(SCREENW, count*SCREEN_WIDTH/4+44);
}

- (void)pressRight:(UIBarButtonItem *)barBtn
{
    NSInteger count = _dataArray.count;
    if([barBtn.title isEqualToString:@"编辑"])
    {
        barBtn.title = @"完成";
        for(int i=0;i<count;i++)
        {
            UIImageView *imageV = [self.view viewWithTag:10+i];
            imageV.alpha = 1;
        }
    }
    else
    {
        barBtn.title = @"编辑";
        for(int i=0;i<count;i++)
        {
            UIImageView *imageV = [self.view viewWithTag:10+i];
            imageV.alpha = 0;
        }
        _backScrollView.contentSize = CGSizeMake(SCREENW, (count%2+1)*SCREENW/2);
    }
}

- (void)pressX:(UITapGestureRecognizer *)tap
{
    UIView *vw = tap.view.superview;
    //更新收藏夹并且更新界面
    [self updateCollect:tap.view.tag];//从10开始的
    [self updateAllViews:tap.view.superview.tag];//从1000开始的
    [vw removeFromSuperview];
}

- (void)updateCollect:(NSInteger)tag
{
    CartModel *model = _dataArray[tag-10];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *str = [NSString stringWithFormat:CANCEL_COLLECT_GOODS,[ud objectForKey:@"session"],model.goods_id];
    NetManager *nm = [NetManager shareManager];
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@",API_SERVER,str];
    [nm requestStrUrl:urlStr withSuccessBlock:^(id data) {
        dispatch_async(dispatch_get_main_queue(),^{
    
        });
    } withFailedBlock:^(NSError *error) {
        
    }];
}

- (void)updateAllViews:(NSInteger)tag
{
    NSInteger count = _dataArray.count;
    NSInteger begin = tag-1000;
    for(NSInteger i = begin;i < count;i++)
    {
        for(NSInteger j = i+1;j < count;j++)
        {
            _dataArray[i] = _dataArray[j];
        }
        //取后面一个view
        NSInteger line = i%2;
        NSInteger row = i/2;
        UIView *nextView = [self.view viewWithTag:i+1+1000];
        [UIView animateWithDuration:0.5 animations:^{
            nextView.frame = CGRectMake(line*(SCREENW/2), row*(SCREENW/2), SCREENW/2, SCREENW/2);
        }];
        //更改tag值 注意：需要将view上的红叉View的tag也要减1
        UIView *redXView = [nextView viewWithTag:nextView.tag-990];
        redXView.tag = redXView.tag - 1;
        nextView.tag = nextView.tag-1;
    }
    [_dataArray removeObjectAtIndex:count-1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
