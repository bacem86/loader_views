//
//  FirstViewController.m
//  BFLoaders
//
//  Created by Bacem on 16/03/2015.
//  Copyright (c) 2015 BF. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellID = @"cellID";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if(indexPath.row == 0){
        cell.textLabel.text = @"linear loader";
    }else{
        cell.textLabel.text = @"circular loader";
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SecondViewController * controller = [[SecondViewController alloc] init];
    controller.linearLoader = indexPath.row == 0;
    
    [self.navigationController pushViewController:controller animated:YES];
}
@end
