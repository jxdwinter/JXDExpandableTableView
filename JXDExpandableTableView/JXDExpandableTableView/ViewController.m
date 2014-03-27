//
//  ViewController.m
//  JXDExpandableTableView
//
//  Created by JiangXiaodong on 3/27/14.
//  Copyright (c) 2014 jxdwinter. All rights reserved.
//

#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height

#import "ViewController.h"

#import "Model.h"
#import "SubModel.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL isOpen;
@property (nonatomic,strong) NSIndexPath *selectIndex;
@property (nonatomic,strong) UITableView *expansionTableView;
@property (nonatomic,strong) NSMutableArray *dataSource;;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];

    self.expansionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, SCREENHEIGHT - 64.0)style:UITableViewStylePlain];
    self.expansionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.expansionTableView.backgroundView = nil;
    self.expansionTableView.backgroundColor = [UIColor whiteColor];
    self.expansionTableView.delegate = self;
    self.expansionTableView.dataSource = self;
    [self.expansionTableView setBackgroundView:nil];
    [self.view addSubview:self.expansionTableView];

    self.expansionTableView.sectionFooterHeight = 0;
    self.expansionTableView.sectionHeaderHeight = 0;
    self.isOpen = NO;
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:50];

    SubModel *subModelOne = [[SubModel alloc] initWithTitle:@"1"];
    SubModel *subModelTwo = [[SubModel alloc] initWithTitle:@"2"];
    NSMutableArray *arrayOne = [[NSMutableArray alloc] initWithObjects:subModelOne,subModelTwo, nil];
    Model *modelOne = [[Model alloc] initWithTitle:@"One" withSubModels:arrayOne];

    [self.dataSource addObject:modelOne];

    SubModel *subModelThree = [[SubModel alloc] initWithTitle:@"3"];
    SubModel *subModelFour = [[SubModel alloc] initWithTitle:@"4"];
    NSMutableArray *arrayTwo = [[NSMutableArray alloc] initWithObjects:subModelThree,subModelFour, nil];
    Model *modelTwo = [[Model alloc] initWithTitle:@"Two" withSubModels:arrayTwo];

    [self.dataSource addObject:modelTwo];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isOpen) {
        if (self.selectIndex.section == section) {
            return [[self.dataSource[section] subModels] count] + 1;
        }
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0) {
        static NSString *MODELCELL = @"MODELCELL";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MODELCELL];
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MODELCELL];
        }
        NSArray *array = [[self.dataSource objectAtIndex:self.selectIndex.section] subModels];
        cell.textLabel.text = [array[(indexPath.row) - 1] title];
        return cell;

    }else{
        static NSString *SUBMODELCELL = @"SUBMODELCELL";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier :SUBMODELCELL];
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SUBMODELCELL];
        }
        cell.textLabel.text = [self.dataSource[indexPath.section] title];
        return cell;
    }
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([indexPath isEqual:self.selectIndex]) {
            self.isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];
            self.selectIndex = nil;
        }else{
            if (!self.selectIndex) {
                self.selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];
            }else{
                [self didSelectCellRowFirstDo:NO nextDo:YES];
            }
        }

    }else{

        Model *model = self.dataSource[indexPath.section];
        SubModel *subModel = [model subModels][indexPath.row - 1];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:subModel.title
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles: nil];
        [alert show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    [self.expansionTableView beginUpdates];

    NSUInteger section = self.selectIndex.section;
    NSUInteger contentCount = [[self.dataSource[section] subModels] count];
	NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
	for (NSUInteger i = 1; i < contentCount + 1; i++) {
		NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
		[rowToInsert addObject:indexPathToInsert];
	}

	if (firstDoInsert){
        [self.expansionTableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationLeft];
    }else{
        [self.expansionTableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationRight];
    }

	[self.expansionTableView endUpdates];

    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [self.expansionTableView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }

    if (self.isOpen) [self.expansionTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}




@end
