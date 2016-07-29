//
//  GoodsDetailVC.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/15.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "GoodsDetailVC.h"
#import "DetailCell.h"
#import "NetManager.h"
#import "GoodDetailModel.h"
#import <UIImageView+WebCache.h>
#import "GoodsPicModel.h"
#import "LoginVC.h"
#import "OrderVC.h"
#import "KeFuVC.h"

#define SESSION_ID @"3334f8d6000d9a3db346e798615ebee2"
#define API_SERVER @"http://127.0.0.1/mcmp1605/data_enter.php"
#define GET_GOOD_INFO @"method=goods_info&goods_id=%@"
#define ADD_CART_API @"method=add_cart&session_id=%@&goods_id=%@&goods_num=%ld"
#define TO_COLLECT_GOODS @"method=collect_goods&session_id=%@&goods_id=%@"
#define CANCEL_COLLECT_GOODS @"method=cancel_collect_goods&session_id=%@&goods_id=%@"

@interface GoodsDetailVC () <UIScrollViewDelegate,UITextFieldDelegate,LoginVCDelegate>
{
    DetailCell *_cell;
    NSMutableArray *_imageDataArray;
    NSInteger _purchaseNum;
    BOOL _isFirst;
    NSInteger _type;
    
    UIView *_view1;
    UIView *_view2;
    UIView *_view3;
    UIView *_view4;
    UIView *_view5;
}
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIScrollView *bigScrollView;
@property (nonatomic,strong) UIScrollView *picScrollView;
@end

@implementation GoodsDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.view.backgroundColor = [UIColor blueColor];
    [self.view endEditing:YES];
    
    _isFirst = YES;

    //初始化底部view，包含客服，加入购物车，立即购买
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-113, SCREEN_WIDTH, 49)];
    _bottomView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_bottomView];
    
    //初始化底部view上的各个组件
    [self initBottomElem];
    
    
    //初始化整个ScrollView，将所有控件都加入到此ScrollView上
    _bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-113)];
    _bigScrollView.delegate = self;
    [self.view addSubview:_bigScrollView];
    
    
    //初始化bigScrollView上的各个控件
    _imageDataArray = [NSMutableArray array];
    [self initSubViews];
    
    //请求数据
    [self getData];
}

#pragma mark 初始化self.view上的底部view--加入购物车，客服和立即购买
- (void)initBottomElem
{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH/8, 44)];
    imageV.image = [UIImage imageNamed:@"goodskefu"];
    imageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(kefu)];
    [imageV addGestureRecognizer:tap];
    [_bottomView addSubview:imageV];
    
    //加入购物车
    UIButton *cartBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+50, imageV.frame.origin.y, 130, 39)];
    [cartBtn setBackgroundColor:[UIColor redColor]];
    [cartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [cartBtn addTarget:self action:@selector(addCart) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:cartBtn];
    
    //立即购买
    UIButton *purchaseBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cartBtn.frame)+5, imageV.frame.origin.y, 130, 39)];
    [purchaseBtn setBackgroundColor:[UIColor redColor]];
    [purchaseBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [purchaseBtn addTarget:self action:@selector(purchase) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:purchaseBtn];
}

- (void)kefu
{
    KeFuVC *kfvc = [[KeFuVC alloc] init];
    
    [self.navigationController pushViewController:kfvc animated:YES];
}

- (void)addCart
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([[ud objectForKey:@"Login"] isEqualToString:@"Logined"])
    {
        //请求数据，接口
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:nil userInfo:nil];
        [self addCartToServer];
    }
    else
    {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:@"GoodsDetail" forKey:@"VC"];
        [ud synchronize];
        _type = 0;
        LoginVC *lvc = [[LoginVC alloc] init];
        lvc.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:lvc];
        nav.navigationBar.barTintColor = [UIColor redColor];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)addCartToServer
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *addStr = [NSString stringWithFormat:ADD_CART_API,[ud objectForKey:@"session"],self.goodsID,_purchaseNum];
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@",API_SERVER,addStr];
    NSLog(@"%@",urlStr);
    GoodDetailModel *model = [[GoodDetailModel alloc] init];
    model = _imageDataArray[0];
    if(_purchaseNum == 0 || _purchaseNum > [model.goods_number integerValue])
    {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确的购买数量" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [ac addAction:cancel];
        [self presentViewController:ac animated:YES completion:nil];
        return;
    }
    NetManager *nm = [NetManager shareManager];
    [nm requestStrUrl:urlStr withSuccessBlock:^(id data) {
        NSLog(@"%@",data);
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"已加入购物车" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [ac addAction:cancel];
        [self presentViewController:ac animated:YES completion:nil];
    } withFailedBlock:^(NSError *error) {
        
    }];
    
}

- (void)showWhichVC
{
    [self showVC];
}

- (void)showVC
{
    switch (_type) {
        case 0: //加入购物车
        {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"已加入购物车" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [ac addAction:cancel];
            [self presentViewController:ac animated:YES completion:nil];
        }
            break;
        case 1: //添加收藏
        {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"已加入收藏夹" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [ac addAction:cancel];
            [self presentViewController:ac animated:YES completion:nil];
        }
            break;
        case 2: //立即购买
        {
            
        }
            break;
        default:
            break;
    }
}

//购买按钮的点击方法
- (void)purchase
{
    GoodDetailModel *model = [[GoodDetailModel alloc] init];
    model = _imageDataArray[0];
    OrderVC *ovc = [[OrderVC alloc] init];
    ovc.gdModel = model;
    ovc.price = model.shop_price;
    ovc.purchaseNum = [NSString stringWithFormat:@"%ld",_purchaseNum];
    [self.navigationController pushViewController:ovc animated:YES];
}

#pragma mark 初始化整个ScrollView上的组件
- (void)initSubViews
{
    
    //1.创建ScrollView
    [self initScrollView];
    
    //2.创建第二个控件
    [self initPriceAndCollect];
    
    //3.创建商品名字的label
    [self initName];
    
    //4.创建购买数量，商品库存，商品包装
    [self initPurchaseNumAndCountAndPack];
    
    //5.创建商品信息
    [self initGoodsInfo];
    
    //6.创建商品详细信息
    [self initGoodsCriticAndDetailPic];
}

#pragma mark 请求数据
- (void)getData
{
    //处理链接
    NSString *str = [NSString stringWithFormat:@"%@?method=goods_info&goods_id=%@",API_SERVER,self.goodsID];
    NetManager *nm = [NetManager shareManager];
    [nm requestStrUrl:str withSuccessBlock:^(id data) {
        NSDictionary *tempArray = data[@"data"][@"goods_info"];
        NSLog(@"%@",tempArray);
        GoodDetailModel *model = [[GoodDetailModel alloc] initWithDictionary:tempArray error:nil];
        [_imageDataArray addObject:model];
        dispatch_async(dispatch_get_main_queue(),^{
            [self updateImageOnScrollView];
            [self updatePrice];
            [self updateName];
            [self updateGoodInfos];
            [self updateGoodsBrief];
        });
    } withFailedBlock:^(NSError *error) {
        
    }];

}

#pragma mark 1.创建imageView，加到picScrollView上
- (void)initScrollView
{
    _picScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    _picScrollView.delegate = self;
    _picScrollView.pagingEnabled = YES;
    [_bigScrollView addSubview:_picScrollView];
}

//更新ScrollView
- (void)updateImageOnScrollView
{
    GoodDetailModel *model = [[GoodDetailModel alloc] init];
    model = _imageDataArray[0];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    NSLog(@"%@",model.goods_img);
    [imageV sd_setImageWithURL:[NSURL URLWithString:model.goods_img]];
    [_picScrollView addSubview:imageV];
}

#pragma mark 2.创建第二个控件
- (void)initPriceAndCollect
{
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_picScrollView.frame), SCREEN_WIDTH, 30)];
    _view1.backgroundColor = [UIColor redColor];
    
    UILabel *priceL = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH/2, 30)];
    priceL.tag = 21;
    [_view1 addSubview:priceL];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 30)];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if(![ud objectForKey:self.goodsID])
    {
        [btn setTitle:@"收藏" forState:UIControlStateNormal];
    }
    else
    {
        [btn setTitle:[ud objectForKey:self.goodsID] forState:UIControlStateNormal];
    }
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pressCollect:) forControlEvents:UIControlEventTouchUpInside];
    [_view1 addSubview:btn];
    [_bigScrollView addSubview:_view1];
}

- (void)pressCollect:(UIButton *)button
{
    _type = 1;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if(![[ud objectForKey:@"Login"] isEqualToString:@"Logined"])
    {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:@"GoodsDetail" forKey:@"VC"];
        [ud synchronize];
        LoginVC *lvc = [[LoginVC alloc] init];
        lvc.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:lvc];
        nav.navigationBar.barTintColor = [UIColor redColor];
        [self presentViewController:nav animated:YES completion:nil];
        [button setTitle:@"已收藏" forState:UIControlStateNormal];
        [ud setObject:@"已收藏" forKey:self.goodsID];
        [ud synchronize];
        return;
    }
    if([button.titleLabel.text isEqualToString:@"收藏"])
    {
        
        [button setTitle:@"已收藏" forState:UIControlStateNormal];
        [ud setObject:@"已收藏" forKey:self.goodsID];
        [ud synchronize];
        NSString *str = [NSString stringWithFormat:TO_COLLECT_GOODS,[ud objectForKey:@"session"],self.goodsID];
        NSString *urlStr = [NSString stringWithFormat:@"%@?%@",API_SERVER,str];
        [self updateCollection:urlStr];
    }
    else
    {
        [button setTitle:@"收藏" forState:UIControlStateNormal];
        [ud setObject:@"收藏" forKey:self.goodsID];
        [ud synchronize];
        NSString *str = [NSString stringWithFormat:CANCEL_COLLECT_GOODS,[ud objectForKey:@"session"],self.goodsID];
        NSString *urlStr = [NSString stringWithFormat:@"%@?%@",API_SERVER,str];
        [self updateCollection:urlStr];
    }
}

- (void)updateCollection:(NSString *)urlString
{
    NetManager *nm = [NetManager shareManager];
    [nm requestStrUrl:urlString withSuccessBlock:^(id data) {
        
    } withFailedBlock:^(NSError *error) {
        
    }];
}

- (void)updatePrice
{
    GoodDetailModel *model = [[GoodDetailModel alloc] init];
    model = _imageDataArray[0];
    UILabel *label = [self.view viewWithTag:21];
    label.text = [NSString stringWithFormat:@"￥%@",model.shop_price];
    label.textColor = [UIColor whiteColor];
}

#pragma mark 3.创建商品名字的label
- (void)initName
{
    _view2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_view1.frame), SCREEN_WIDTH, 40)];
    _view2.backgroundColor = [UIColor grayColor];
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH, 40)];
    nameL.tag = 22;
    [_view2 addSubview:nameL];
    [_bigScrollView addSubview:_view2];
}

- (void)updateName
{
    GoodDetailModel *model = [[GoodDetailModel alloc] init];
    model = _imageDataArray[0];
    UILabel *label = [_view2 viewWithTag:22];
    NSLog(@"%@",model.goods_short_name);
    label.text = model.goods_short_name;
    label.textColor = [UIColor blackColor];
}

#pragma mark 4.创建购买数量，商品库存，商品包装
- (void)initPurchaseNumAndCountAndPack
{
    _view3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_view2.frame), SCREEN_WIDTH, 130)];
    _view3.backgroundColor = [UIColor greenColor];
    
    UILabel *num = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH/4, 30)];
    num.text = @"购买数量:";
    num.textColor = [UIColor blackColor];
    [_view3 addSubview:num];
    
    //创建 + 和 -
    UIImageView *imageVDes = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(num.frame)+10, num.frame.origin.y, SCREEN_WIDTH/10, 30)];
    imageVDes.userInteractionEnabled = YES;
    imageVDes.image = [UIImage imageNamed:@"cart_des"];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] init];
    [tap1 addTarget:self action:@selector(tapDes)];
    [imageVDes addGestureRecognizer:tap1];
    
    UIImageView *imageVAdd = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageVDes.frame)+50, num.frame.origin.y, SCREEN_WIDTH/10, 30)];
    imageVAdd.userInteractionEnabled = YES;
    imageVAdd.image = [UIImage imageNamed:@"cart_add"];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] init];
    [tap2 addTarget:self action:@selector(tapAdd)];
    [imageVAdd addGestureRecognizer:tap2];
    
    [_view3 addSubview:imageVAdd];
    [_view3 addSubview:imageVDes];
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageVDes.frame), num.frame.origin.y, 50, 30)];
    tf.tag = 50;
    tf.text = @"0";
    _purchaseNum = 0;
    tf.borderStyle = UITextBorderStyleLine;
    tf.textAlignment = NSTextAlignmentCenter;
    tf.delegate = self;
    [_view3 addSubview:tf];
    
    UILabel *storge = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(num.frame)+10, SCREEN_WIDTH, 30)];
    storge.tag = 23;
    [_view3 addSubview:storge];
    UILabel *pack = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(storge.frame)+10, SCREEN_WIDTH, 30)];
    pack.tag = 24;
    [_view3 addSubview:pack];
    [_bigScrollView addSubview:_view3];
}

- (void)tapDes
{
    UITextField *tf = [self.view viewWithTag:50];
    if([tf.text intValue] == 0)
    {
        return;
    }
    else
    {
        _purchaseNum--;
        tf.text = [NSString stringWithFormat:@"%ld",_purchaseNum];
    }
}

- (void)tapAdd
{
    GoodDetailModel *model = [[GoodDetailModel alloc] init];
    model = _imageDataArray[0];
    UITextField *tf = [self.view viewWithTag:50];
    if([model.goods_number intValue] == 0)
    {
        return;
    }
    if([tf.text intValue] == [model.goods_number intValue])
    {
        tf.text = model.goods_number;
    }
    else
    {
        _purchaseNum++;
        tf.text = [NSString stringWithFormat:@"%ld",_purchaseNum];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%@",string);
    GoodDetailModel *model = [[GoodDetailModel alloc] init];
    model = _imageDataArray[0];
    if([string isEqualToString:@""])
    {
        _purchaseNum /= 10;
        return YES;
    }
    NSString *str = [NSString stringWithFormat:@"%ld%@",_purchaseNum,string];
    if([str intValue] > [model.goods_number intValue])
    {
        textField.text = model.goods_number;
        _purchaseNum = [str intValue];
        return YES;
    }
    _purchaseNum = [str intValue];

    return YES;
}

- (void)updateGoodInfos
{
    GoodDetailModel *model = [[GoodDetailModel alloc] init];
    model = _imageDataArray[0];
    UILabel *label1 = [self.view viewWithTag:23];
    label1.text = [NSString stringWithFormat:@"商品库存:      %@",model.goods_number];
    UILabel *label2 = [self.view viewWithTag:24];
    NSString *str = [NSString stringWithFormat:@"商品包装:     %@",model.goods_packing];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range = [str rangeOfString:model.goods_packing];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    label2.attributedText = attr;
}

#pragma mark 创建商品详细信息
- (void)initGoodsInfo
{
    _view4 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_view3.frame), SCREEN_WIDTH, 100)];
    _view4.backgroundColor = [UIColor cyanColor];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-10, 20)];
    label1.text = @"商品信息";
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label1.frame), SCREEN_WIDTH-20, 80)];
    label2.tag = 25;
    label2.numberOfLines = 0;
    [label2 setFont:[UIFont systemFontOfSize:15]];
    [_view4 addSubview:label1];
    [_view4 addSubview:label2];
    [_bigScrollView addSubview:_view4];
}

- (void)updateGoodsBrief
{
    GoodDetailModel *model = [[GoodDetailModel alloc] init];
    model = _imageDataArray[0];
    UILabel *label = [self.view viewWithTag:25];
    NSString *str = [NSString stringWithFormat:@"%@ %@",model.goods_short_name,model.goods_brief];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range = [str rangeOfString:model.goods_brief];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    label.attributedText = attr;
}

#pragma mark 商品评价和图文详情
- (void)initGoodsCriticAndDetailPic
{
    _view4 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_view4.frame), SCREEN_WIDTH, 60)];
    _view4.backgroundColor = [UIColor purpleColor];
    [_bigScrollView addSubview:_view4];
    _bigScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(_view4.frame)+10);
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
