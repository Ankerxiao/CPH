//
//  ChatVC.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/27.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "ChatVC.h"
#import "CZMessage.h"
#import "CZMessageFrame.h"
#import "CZMessageCell.h"

@interface ChatVC () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *txtInput;

// 用来保存所有的消息的frame模型对象
@property (nonatomic, strong) NSMutableArray *messageFrames;

@end

@implementation ChatVC

#pragma mark - /********** 懒加载数据 *********/
- (NSMutableArray *)messageFrames
{
    if (_messageFrames == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"messages.plist" ofType:nil];
        NSArray *arrayDict = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *arrayModels = [NSMutableArray array];
        for (NSDictionary *dict in arrayDict) {
            // 创建一个数据模型
            CZMessage *model = [CZMessage messageWithDict:dict];
            
            // 获取上一个数据模型
            CZMessage *lastMessage = (CZMessage *)[[arrayModels lastObject] message];
            
            // 判断当前模型的“消息发送时间”是否和上一个模型的“消息发送时间”一致， 如果一致做个标记
            if ([model.time isEqualToString:lastMessage.time]) {
                model.hideTime = YES;
            }
            
            // 创建一个frame 模型
            CZMessageFrame *modelFrame = [[CZMessageFrame alloc] init];
            
            modelFrame.message = model;
            
            
            // 把frame 模型加到arrayModels
            [arrayModels addObject:modelFrame];
        }
        _messageFrames = arrayModels;
    }
    return _messageFrames;
}


#pragma mark - /********** 文本框的代理方法 *********/
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    return YES;
//}

// 当键盘上的return键被单击的时候触发
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 1. 获取用户输入的文本
    NSString *text = textField.text;
    
    // 2. 发送用户的消息
    [self sendMessage:text withType:CZMessageTypeMe];
    
    // 3. 发送一个系统消息
    [self sendMessage:@"不认识!" withType:CZMessageTypeOther];
    
    // 清空文本框
    textField.text = nil;
    
    return YES;
}

// 发送消息
- (void)sendMessage:(NSString *)msg withType:(CZMessageType)type
{
    // 2. 创建一个数据模型和frame 模型
    CZMessage *model = [[CZMessage alloc] init];
    
    // 获取当前系统时间
    NSDate *nowDate = [NSDate date];
    // 创建一个日期时间格式化器
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置格式
    formatter.dateFormat = @"今天 HH:mm";
    // 进行日期时间的格式化
    model.time = [formatter stringFromDate:nowDate];
    model.type = type;
    model.text = msg;
    
    
    
    // 根据当前消息的时间和上一条消息的时间, 来设置是否需要隐藏时间Label
    CZMessageFrame *lastMessageFrame = [self.messageFrames lastObject];
    NSString *lastTime = lastMessageFrame.message.time;
    if ([model.time isEqualToString:lastTime]) {
        model.hideTime = YES;
    }
    
    //***** 注意: 要先设置数据模型的hideTime属性, 然后再设置modelFrame.message = model;
    // 因为在设置modelFrame.message = model;的时候set方法中, 内部会用到model.hideTime属性。
    
    // 创建一个frame 模型
    CZMessageFrame *modelFrame = [[CZMessageFrame alloc] init];
    modelFrame.message = model;
    
    
    
    // 3. 把frame 模型加到集合中
    [self.messageFrames addObject:modelFrame];
    
    
    
    
    // 4. 刷新UITableView的数据
    [self.tableView reloadData];
    
    // 5. 把最后一行滚动到最上面
    NSIndexPath *idxPath = [NSIndexPath indexPathForRow:self.messageFrames.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}



#pragma mark - /********** UITableView的代理方法 *********/
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 把键盘叫回去, 思路: 让控制器所管理的UIView结束编辑
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"★★★★★★★★★");
}



#pragma mark - /********** 数据源方法 *********/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1. 获取模型数据
    CZMessageFrame *modelFrame = self.messageFrames[indexPath.row];
    
    // 2. 创建单元格
    
    CZMessageCell *cell = [CZMessageCell messageCellWithTableView:tableView];
    
    // 3. 把模型设置给单元格对象
    cell.messageFrame = modelFrame;
    
    // 4.返回单元格
    return cell;
}

// 返回每一行的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZMessageFrame *messageFrame = self.messageFrames[indexPath.row];
    return messageFrame.rowHeight;
}



#pragma mark - /********** 其他 *********/
- (void)viewDidLoad {
    [super viewDidLoad];
    // 取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置UITableView的背景色
    self.tableView.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:236 / 255.0 blue:236 / 255.0 alpha:1.0];
    
    // 设置UITableView的行不允许被选中
    self.tableView.allowsSelection = NO;
    
    // 设置文本框最左侧有一段间距
    UIView *leftVw = [[UIView alloc] init];
    leftVw.frame = CGRectMake(0, 0, 5, 1);
    
    // 把leftVw设置给文本框
    self.txtInput.leftView = leftVw;
    self.txtInput.leftViewMode = UITextFieldViewModeAlways;
    
    
    // 监听键盘的弹出事件
    // 1. 创建一个NSNotificationCenter对象。
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    // 2. 监听键盘的弹出通知
    [center addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)keyboardWillChangeFrame:(NSNotification *)noteInfo
{
    //    NSLog(@"通知名称: %@", noteInfo.name);
    //
    //    NSLog(@"通知的发布者: %@", noteInfo.object);
    //
    //    NSLog(@"通知的具体内容: %@", noteInfo.userInfo);
    // 1. 获取当键盘显示完毕或者隐藏完毕后的Y值
    CGRect rectEnd = [noteInfo.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = rectEnd.origin.y;
    
    // 用键盘的Y值减去屏幕的高度计算出平移的值
    // 1. 如果是键盘弹出事件, 那么计算出的值就是负的键盘的高度
    // 2. 如果是键盘的隐藏事件, 那么计算出的值就是零， 因为键盘在隐藏以后, 键盘的Y值就等于屏幕的高度。
    CGFloat tranformValue = keyboardY - self.view.frame.size.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        // 让控制器的View执行一次“平移”
        self.view.transform = CGAffineTransformMakeTranslation(0, tranformValue);
    }];
    
    
    
    // 让UITableView的最后一行滚动到最上面
    NSIndexPath *lastRowIdxPath = [NSIndexPath indexPathForRow:self.messageFrames.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastRowIdxPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


// ***************** 注意: 监听通知以后一定要在监听通知的对象的dealloc方法中移除监听 *************/.

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
