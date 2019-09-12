//
//  AboutTeamVC.m
//  CLT
//
//  Created by 清阳 on 2018/1/5.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "AboutTeamVC.h"
#import "AboutViewCell.h"
@interface AboutTeamVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AboutTeamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
}
- (void)setUpView{
    self.navigationItem.title = @"关于我们";
    [self baseSetup:PageGobackTypePop];
    self.view.backgroundColor = Color_TABBG;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = Color_White;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"AboutViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    _tableView.rowHeight = UITableViewAutomaticDimension;//设置cell高度自动计算，只有在xib或者storyboard上自定义的cell才会生效
    _tableView.estimatedRowHeight = 525;//预估值
    return _tableView.estimatedRowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    AboutViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.jushouText.numberOfLines = 0;
    cell.jushouText.text  = @"上海绝灵科技有限公司是一家基于人工智能、大数据分析、云计算及智能信审风控的移动互联网风控公司，核心层由风控专家及IT精英组成。是一支集互联网产品运营、风控、人工智能、大数据分析等各路高手组成的意气风发的团队。公司推出的风控系统产品，已服务于多家企业，基于服务现有客户的经验基础，我们持续追求前沿科技在产品设计中的应用，不断提升创新能力，立志为企业提供优质、可靠、稳定的服务";
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.alignment = NSTextAlignmentLeft;
    style.headIndent = 0.0f; //行首缩进
    CGFloat emptylen = cell.jushouText.font.pointSize * 2; //参数 （字体大小17号字乘以2，34f即首行空出两个字符）
    style.firstLineHeadIndent = emptylen; //首行缩进
    NSAttributedString *text = [[NSAttributedString alloc]initWithString:cell.jushouText.text attributes:@{NSParagraphStyleAttributeName:style}];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.jushouText.attributedText = text;
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
