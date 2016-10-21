//
//  ViewController.m
//  EncryDemo
//
//  Created by feiyangkl on 16/10/21.
//  Copyright © 2016年 feiyangkl. All rights reserved.
//

#import "ViewController.h"

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
        self.lb_show.text = [EncryptUtil encryptUseDES:self.lb_show.text key:gkey];
    }
}

@end
