//
//  LoginVC.h
//  
//
//  Created by Anker Xiao on 16/7/15.
//
//

#import <UIKit/UIKit.h>

@protocol LoginVCDelegate <NSObject>

@optional
- (void)passValue:(BOOL)boolean;
- (void)showWhichVC;

@end

@interface LoginVC : UIViewController

@property (nonatomic,weak) id <LoginVCDelegate> delegate;

@end
