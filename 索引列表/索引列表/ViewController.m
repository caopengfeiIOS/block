//
//  ViewController.m
//  索引列表
//
//  Created by hbgl on 16/8/19.
//  Copyright © 2016年 hbgl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSMutableArray *sectionTitles; // 每个分区的标题
    NSMutableArray *contentsArray; // 每行的内容
    
}
@property(nonatomic,strong)NSMutableArray*selectIndexPaths; //定义一个可以存被点击后的indexpath的可变数组

@property(nonatomic,strong)NSIndexPath*selectPath; //存放被点击的哪一行的标志


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectIndexPaths = [NSMutableArray array];
    // Do any additional setup after loading the view, typically from a nib.
    [self addUI];
    [self readySource];
}
-(UITableView*)tableView
{
    if (_tableView==nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionIndexColor = [UIColor blueColor];
        _tableView.sectionIndexTrackingBackgroundColor = [UIColor redColor];
    }
    return _tableView;
}
-(void)addUI
{
    [self.view addSubview:self.tableView];
}
/** @brief 准备数据源 在viewDidLoad方法中调用*/
- (void)readySource
{
    
    NSArray * arr2       = [[NSArray alloc] initWithObjects:
                           @"A",@"C",@"F",@"G",@"H",@"M",@"S",@"T",@"X",@"Z", nil];
    sectionTitles = [NSMutableArray arrayWithArray:arr2];
    NSArray *arr       = [[NSArray alloc] initWithObjects:
                           @[@"阿伟",@"阿姨",@"阿三"],
                           @[@"蔡芯",@"成龙",@"陈鑫",@"陈丹",@"成名"],
                           @[@"芳仔",@"房祖名",@"方大同",@"芳芳",@"范伟"],
                           @[@"郭靖",@"郭美美",@"过儿",@"过山车"],
                           @[@"何仙姑",@"和珅",@"郝歌",@"好人"],
                           @[@"妈妈",@"毛主席"],
                           @[@"孙中山",@"沈冰",@"婶婶"],
                           @[@"涛涛",@"淘宝",@"套娃"],
                           @[@"小二",@"夏紫薇",@"许巍",@"许晴"],
                           @[@"周恩来",@"周杰伦",@"张柏芝",@"张大仙"],nil];
    contentsArray = [NSMutableArray arrayWithArray:arr];
}
// 每个分区的页眉
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sectionTitles objectAtIndex:section];
}
// 索引目录
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return sectionTitles;
}
// 点击目录
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    // 获取所点目录对应的indexPath值
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    
    // 让table滚动到对应的indexPath位置
    [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    return index;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [contentsArray[section] count] ;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return contentsArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if([self.selectIndexPaths containsObject:indexPath])//如果这个数组中有当前所点击的下标，那就标记为打钩
        
    {
        
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        
    }
    
    else
        
    {
        
        cell.accessoryType=UITableViewCellAccessoryNone;
        
    }
    
    cell.textLabel.text = contentsArray[indexPath.section][indexPath.row];
    return cell;
}
-(void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath

{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([self.selectIndexPaths containsObject:indexPath])//在NSMutableArray中用（bool）类型的containsObject判断这个对象是否存在这个数组中（判断的是内存地址）contains：包含
        
    {
        
        //存在以选中的，就执行（为真就执行）把存在的移除
        
        [self.selectIndexPaths removeObject:indexPath];//把这个cell的标记移除
        
    }
    
    else//不存在这个标记，那点击后就添加到这个数组中
        
    {
        
        [self.selectIndexPaths addObject:indexPath];
        
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationFade];//重新刷新这行
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    editingStyle = UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                //点击删除按钮调用这里的代码
                //数据源删除
                [tableView beginUpdates];
                NSMutableArray *arr = [NSMutableArray arrayWithArray:contentsArray[indexPath.section]];
                [arr  removeObjectAtIndex:indexPath.row];
                if (arr.count==0) {
                    [contentsArray removeObjectAtIndex:indexPath.section];
                    [sectionTitles removeObjectAtIndex:indexPath.section];
                    [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                }else
                {
                    [contentsArray replaceObjectAtIndex:indexPath.section withObject:arr];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                [tableView endUpdates];

    }];
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了编辑");
    }];
    editAction.backgroundColor = [UIColor grayColor];
    return @[deleteAction, editAction];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
