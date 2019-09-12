//
//  MultiselectView.m
//  Multiselect
//
//  Created by 清阳 on 2017/12/22.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "MultiselectView.h"

@implementation MultiselectView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
        
        self.resultArr = [NSMutableArray array];
        
        self.dataArr = [NSMutableArray array];

        self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 50) style:UITableViewStylePlain];
        
        self.tableview.delegate = self;
        
        self.tableview.dataSource = self;
        
        self.tableview.showsVerticalScrollIndicator = NO;
        
        self.tableview.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.tableview];
        
        self.tableview.scrollEnabled = YES;
    
        [self.tableview registerClass:[MultiselectTableViewCell class] forCellReuseIdentifier:@"muselect"];
        
    }
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.tableview.frame.size.height + 10, self.frame.size.width/3, self.frame.size.height - self.tableview.frame.size.height - 15)];
    
    [self addSubview:confirmBtn];
    
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    confirmBtn.layer.cornerRadius = 5;
    
    confirmBtn.layer.borderColor = [UIColor blueColor].CGColor;
    
    confirmBtn.layer.borderWidth = 1;
    
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - self.frame.size.width/3 - 20, self.tableview.frame.size.height + 10, self.frame.size.width/3, confirmBtn.frame.size.height)];
    
    [self addSubview:cancelBtn];
    
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    cancelBtn.layer.cornerRadius = 5;
    
    cancelBtn.layer.borderColor = [UIColor blueColor].CGColor;
    
    cancelBtn.layer.borderWidth = 1;
    
    [cancelBtn addTarget:self action:@selector(canceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
    
}

- (void)confirmBtnClick{
    
    
    self.SelectBlock(self.resultArr);
    
    [self disMiss];
    
}

-(void)canceBtnClick{
    
    self.SelectBlock(nil);

    [self disMiss];

}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MultiselectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"muselect"];

    cell.backgroundColor = [UIColor clearColor];
    
    cell.lbName.text = self.dataArr[indexPath.row];
    
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    
    if (self.resultArr.count != 0) {
        
        for (int i = 0; i < self.resultArr.count; i ++) {
        
            int row = [self.resultArr[i] intValue];
            
            if (indexPath.row == row) {
                
                cell.selectImage.image = [UIImage imageNamed:@"checked"];
                
                break;
                
            }else{
            
                cell.selectImage.image = [UIImage imageNamed:@"unchecked"];
            
            }
            
        }
    
    }else{
        
        cell.selectImage.image = [UIImage imageNamed:@"unchecked"];

    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.resultArr.count != 0) {
    
    for (int i = 0; i < self.resultArr.count; i ++) {
        
        int row = [self.resultArr[i] intValue];
        
        if (indexPath.row == row) {
            
            [self.resultArr removeObjectAtIndex:i];
            break;
            
        }
        
        if (i == self.resultArr.count - 1) {
        
            if (indexPath.row != row) {
                
                [self.resultArr addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
               
            }
            
            break;

        }
        
    }
    
    }else{
        
        [self.resultArr addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    
    }
    
    [self.tableview reloadData];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 50;

}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.frame.size.width, 50)];

    header.backgroundColor = self.backgroundColor;

    UILabel *lbTitle = [[UILabel alloc] initWithFrame:header.bounds];

    [header addSubview:lbTitle];
    lbTitle.text = @"请选择必备信用材料";
    lbTitle.textColor = [UIColor blueColor];
    lbTitle.textAlignment = NSTextAlignmentCenter;
    return header;

}

-(void)disMiss{
    
    [self removeFromSuperview];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
