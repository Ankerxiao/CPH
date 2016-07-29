//
//  SessionVC.m
//  ChePinHui
//
//  Created by Anker Xiao on 16/7/26.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "SessionVC.h"
#import "EMSDK.h"

@interface SessionVC () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *textMessage;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation SessionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-100) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor grayColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.userInteractionEnabled = NO;
    [self.view addSubview:_tableView];
    
    self.textMessage.delegate = self;

}

- (IBAction)toSendMessage:(id)sender
{
    //1.获取要发送的文本
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:self.textMessage.text];
    NSString *from = [[EMClient sharedClient] currentUsername];
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:@"6001" from:from to:nil body:body ext:nil];
    message.chatType = EMChatTypeChat;// 设置为单聊消息
    //message.chatType = EMChatTypeGroupChat;// 设置为群聊消息
    //message.chatType = EMChatTypeChatRoom;// 设置为聊天室消息
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, self.view.frame.origin.y-260, self.view.frame.size.width, self.view.frame.size.height);
    }];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textMessage resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, self.view.frame.origin.y+260, self.view.frame.size.width, self.view.frame.size.height);
    }];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textMessage resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, self.view.frame.origin.y+260, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

#pragma mark tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
    
    return cell;
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
