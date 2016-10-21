//
//  ViewController.m
//  EncryDemo
//
//  Created by feiyangkl on 16/10/21.
//  Copyright © 2016年 feiyangkl. All rights reserved.
//

#import "ViewController.h"
#import "JSONKit.h"

#import "EncryptUtil.h"
#define gkey @"LmMGStGtOpF4xNyvYt54EQ=="

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lb_show;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickBtn:(UIButton *)sender {
    
    if (sender.tag == 0) {
        
      
        ///解密
        self.lb_show.text = [EncryptUtil decryptUseDES:self.lb_show.text key:gkey];
    }else {
        /// 加密
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        [dic setValue:@"111111" forKey:@"password"];
        [dic setValue:@"admin" forKey:@"userName"];
//
//        NSData *data = [NSJSONSerialization  dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
//        NSString *name= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
/*
 加密{"userName":"admin","password":"111111"}和
         {
         "userName" : "admin",
         "password" : "111111"
         }
 加密后结果是不一样的,一定要确定公司后台是怎么加密的,要不然有可能会错误
 */
        NSString *jsonstr = [dic JSONString];
        self.lb_show.text = [EncryptUtil encryptUseDES:jsonstr key:gkey];
    }
}

@end
