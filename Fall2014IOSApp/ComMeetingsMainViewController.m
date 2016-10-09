//
//  ComMeetingsMainViewController.m
//  Canada2014IOSApp
//
//  Created by Barry on 2/15/14.
//  Copyright (c) 2014 BICSI. All rights reserved.
//

#import "ComMeetingsMainViewController.h"
#import "SessionsDetailViewController.h"
#import "MBProgressHUD.h"
#import "Fall2013IOSAppAppDelegate.h"
#import <CoreData/CoreData.h>
#import "StartPageViewController.h"
#import "SVWebViewController.h"
#import "ComMeetingsViewCell.h"

@interface ComMeetingsMainViewController ()

@end

@implementation ComMeetingsMainViewController

@synthesize myTableView;
@synthesize results;
@synthesize objects;
@synthesize tempDict;
@synthesize dateArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (NSManagedObjectContext *)managedObjectContext
//{
//    NSManagedObjectContext *context = nil;
//    id delegate = [[UIApplication sharedApplication] delegate];
//
//    if ([delegate performSelector:@selector(managedObjectContext)])
//    {
//        context = [delegate managedObjectContext];
//    }
//    return context;
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButtonItem;
    
    //    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"green"]];
    //    [tempImageView setFrame:self.myTableView.frame];
    //
    //    self.myTableView.backgroundView = tempImageView;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    //self.refreshControl  = refreshControl;
    
    [refreshControl beginRefreshing];
    
    
    [self refreshTable];
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchThroughData
{
    self.results = nil;
    
    NSPredicate * resultsPredicate = [NSPredicate predicateWithFormat:@"sessionName contains [cd] %@", self.searchBar.text];
    self.results = [[self.objects filteredArrayUsingPredicate:resultsPredicate] mutableCopy];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchThroughData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    if (tableView == self.myTableView)
    {
        return [dateArray count];
    }
    
    return 1;
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Set the text color of our header/footer text.
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
    header.textLabel.textAlignment = NSTextAlignmentCenter;
    
    // Set the background color of our header/footer.
    header.contentView.backgroundColor = [UIColor colorWithRed:249/255.0 green:255/255.0 blue:235/255.0 alpha:1.0];;
    
    // You can also do this to set the background color of our header/footer,
    //    but the gradients/other effects will be retained.
    // view.tintColor = [UIColor blackColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return sessionsArray.count;
    
    if (tableView == self.myTableView)
    {
        NSString *strDate = [dateArray objectAtIndex:section];
        NSArray *dateSection = [tempDict objectForKey:strDate];
        return [dateSection count];
    }
    else
    {
        [self searchThroughData];
        return self.results.count;
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.myTableView)
    {
        return dateArray[section];
    }
    
    return @"";
    
}//End

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    ComMeetingsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    //cell.backgroundColor = [UIColor colorWithRed:130/255.0 green:171/255.0 blue:50/255.0 alpha:1.0];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (!cell)
    {
        cell = [[ComMeetingsViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (tableView == self.myTableView)
    {
        NSString *strDate = [dateArray objectAtIndex:indexPath.section];
        NSMutableArray *dateSection = [tempDict objectForKey:strDate];
        
        NSManagedObject *object = [dateSection objectAtIndex:indexPath.row];
        cell.textLabel.text = [object valueForKey:@"sessionName"];
        cell.location.text = [object valueForKey:@"location"];
        cell.location.textColor = [UIColor blueColor];
        
        
        
        
        NSString * planner = [NSString stringWithFormat:@"%@", [object valueForKey:@"planner"]];
        
        if ([planner isEqualToString:@"Yes"]) {
            
            cell.textLabel.textColor = [UIColor redColor];
        }
        else{
            
            //cell.textLabel.textColor = [UIColor colorWithRed:30/255.0 green:37/255.0 blue:89/255.0 alpha:1.0];
            cell.textLabel.textColor = [UIColor colorWithRed:30/255.0 green:37/255.0 blue:89/255.0 alpha:1.0];
        }
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setDateFormat:@"MM/dd/yy hh:mm"];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        NSDate *date = (NSDate*) [object valueForKey:@"sessionDate"];
        
        NSString *stringDate = [dateFormatter stringFromDate:date];
        
        NSLog(@"Session Date is: %@", stringDate);
        
        NSDateFormatter *timeFormatter1 = [[NSDateFormatter alloc] init];
        [timeFormatter1 setDateFormat:@"hh:mm a"];
        
        NSDate *time1 = (NSDate*) [object valueForKey:@"startTime"];
        
        NSString *stringStartTime = [timeFormatter1 stringFromDate:time1];
        
        NSDateFormatter *timeFormatter2 = [[NSDateFormatter alloc] init];
        [timeFormatter2 setDateFormat:@"hh:mm a"];
        
        NSDate *time2 = (NSDate*) [object valueForKey:@"endTime"];
        
        NSString *stringEndTime = [timeFormatter2 stringFromDate:time2];
        
        NSString *sessionTime = [[NSString alloc] initWithFormat:@"%@ - %@", stringStartTime,stringEndTime];
        cell.detailTextLabel.text = sessionTime;
        cell.detailTextLabel.textColor = [UIColor blackColor];
        //cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:10.0];
        //cell.textLabel.font = [UIFont fontWithName:@"Arial-Bold" size:10.0];
        //cell.textLabel.textColor = [UIColor brownColor];
        //cell.textLabel.font = [UIFont systemFontOfSize:11.0];
        //cell.textLabel.textColor = [UIColor brownColor];
        
        
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
    }
    else
    {
        NSManagedObject *object = [self.results objectAtIndex:indexPath.row];
        cell.textLabel.text = [object valueForKey:@"sessionName"];
        cell.location.text = [object valueForKey:@"location"];
        cell.location.textColor = [UIColor blueColor];
        
        NSString * planner = [NSString stringWithFormat:@"%@", [object valueForKey:@"planner"]];
        
        if ([planner isEqualToString:@"Yes"]) {
            
            cell.textLabel.textColor = [UIColor redColor];
        }
        else{
            
            cell.textLabel.textColor = [UIColor colorWithRed:30/255.0 green:37/255.0 blue:89/255.0 alpha:1.0];
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setDateFormat:@"MM/dd/yy hh:mm"];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        NSDate *date = (NSDate*) [object valueForKey:@"sessionDate"];
        
        NSString *stringDate = [dateFormatter stringFromDate:date];
        
        NSLog(@"Session Date is: %@", stringDate);
        
        NSDateFormatter *timeFormatter1 = [[NSDateFormatter alloc] init];
        [timeFormatter1 setDateFormat:@"hh:mm a"];
        
        NSDate *time1 = (NSDate*) [object valueForKey:@"startTime"];
        
        NSString *stringStartTime = [timeFormatter1 stringFromDate:time1];
        
        NSDateFormatter *timeFormatter2 = [[NSDateFormatter alloc] init];
        [timeFormatter2 setDateFormat:@"hh:mm a"];
        
        NSDate *time2 = (NSDate*) [object valueForKey:@"endTime"];
        
        NSString *stringEndTime = [timeFormatter2 stringFromDate:time2];
        
        NSString *sessionTime = [[NSString alloc] initWithFormat:@"%@ - %@", stringStartTime,stringEndTime];
        cell.detailTextLabel.text = sessionTime;
        cell.detailTextLabel.textColor = [UIColor blackColor];
        //cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:11.0];
        //cell.textLabel.font = [UIFont fontWithName:@"Arial-Bold" size:10.0];
        //cell.textLabel.textColor = [UIColor brownColor];
        //cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        //cell.textLabel.textColor = [UIColor brownColor];
        
        //cell.textLabel.numberOfLines = 0;
        //cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    return cell;
}

-(void)refreshTable{
    
    printf("\n Refresh Table is called \n");
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sessions" inManagedObjectContext:[[CoreDataHelper sharedHelper] context]];
    
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"sessionID CONTAINS 'COM' && NOT(sessionID CONTAINS 'COMP')"]];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"sessionDate" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *myResults = [[[CoreDataHelper sharedHelper] context] executeFetchRequest:fetchRequest error:nil];
    
    
    if (!myResults || !myResults.count) {
        NSString *message = @"Either there is no data to display or an error updating data has occurred. Please go back to the Home screen and press the Update Data button at the bottom of the screen. If this error occurs after pressing the Update Data Button, then there is no data to display.";
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"No Data to Display"
                                                           message:message
                                                          delegate:self
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil,nil];
        [alertView show];
    }
    else{
        
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                            init];
        
        [refreshControl endRefreshing];
        self.objects = myResults;
        
        
        
        
        
        tempDict = nil;
        tempDict = [[NSMutableDictionary alloc] init];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        NSDate *date = (NSDate*) [[myResults objectAtIndex:0] valueForKey:@"sessionDate"];
        
        NSString *stringDate = [dateFormatter stringFromDate:date];
        
        NSLog(@"sessionDate is: %@", stringDate);
        
        NSString *strPrevDate= stringDate;
        NSString *strCurrDate = nil;
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        //Add the Similar Date data in An Array then add this array to Dictionary
        //With date name as a Key. It helps to easily create section in table.
        for(int i=0; i< [myResults count]; i++)
        {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            
            NSDate *date = (NSDate*) [[myResults objectAtIndex:i] valueForKey:@"sessionDate"];
            
            NSString *stringDate2 = [dateFormatter stringFromDate:date];
            
            strCurrDate = stringDate2;
            
            if ([strCurrDate isEqualToString:strPrevDate])
            {
                
                [tempArray addObject:[myResults objectAtIndex:i]];
            }
            else
            {
                [tempDict setValue:[tempArray copy] forKey:strPrevDate];
                
                strPrevDate = strCurrDate;
                [tempArray removeAllObjects];
                [tempArray addObject:[myResults objectAtIndex:i]];
            }
        }
        //Set the last date array in dictionary
        [tempDict setValue:[tempArray copy] forKey:strPrevDate];
        
        NSArray *tArray = [tempDict allKeys];
        //Sort the array in ascending order
        
        NSMutableArray *arrDate = [[NSMutableArray alloc]init];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateStyle:NSDateFormatterMediumStyle];
        for (int i = 0; i<tArray.count; i++) {
            [arrDate addObject:[dateFormat dateFromString:tArray[i]]];
            NSLog(@"%d", i);
        }
        
        
        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"" ascending:YES];
        NSArray * newDateArray = [arrDate sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        NSMutableArray * newStringArray = [[NSMutableArray alloc]init];
        NSDateFormatter *stringFormat = [[NSDateFormatter alloc] init];
        [stringFormat setDateStyle:NSDateFormatterMediumStyle];
        for (int i = 0; i<newDateArray.count; i++){
            
            [newStringArray addObject:[stringFormat stringFromDate:newDateArray[i]]];
        }
        
        dateArray = newStringArray;
        
        //NSLog(@"PRINT ARRAY %@", dateArray);
        
        
        
        [self.myTableView reloadData];
    }
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    
    if(indexPath.row % 2 == 0){
        UIColor *altCellColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
        cell.backgroundColor = altCellColor;
    }
    else{
        cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sessions" inManagedObjectContext:[[CoreDataHelper sharedHelper] context]];
    
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"sessionID CONTAINS 'COM' && NOT(sessionID CONTAINS 'COMP')"]];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"sessionDate" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *myResults = [[[CoreDataHelper sharedHelper] context] executeFetchRequest:fetchRequest error:nil];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    
    [refreshControl endRefreshing];
    self.objects = myResults;
    
    [self.myTableView reloadData];
    
}

//-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//
//    //u need to change 0 to other value(,1,2,3) if u have more buttons.then u can check which button was pressed.
//
//    if (buttonIndex == 0) {
//
//        [self updateData];
//
//
//    }
//
//
//
//}


//- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
//{
//
//    if(indexPath.row % 2 == 0){
//        //UIColor *altCellColor = [UIColor colorWithRed:235/255.0 green:240/255.0 blue:233/255.0 alpha:1.0];
//        UIColor *altCellColor = [UIColor colorWithRed:246/255.0 green:235/255.0 blue:253/255.0 alpha:1.0];
//        cell.backgroundColor = altCellColor;
//    }
//    else{
//        cell.backgroundColor = [UIColor whiteColor];
//    }
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchDisplayController.isActive)
    {
        [self performSegueWithIdentifier:@"sessionsDetailCell" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"sessionsDetailCell"])
    {
        if (self.searchDisplayController.isActive)
        {
            NSIndexPath * indexPath = [[self.searchDisplayController searchResultsTableView] indexPathForSelectedRow];
            
            SessionsDetailViewController *destViewController = segue.destinationViewController;
            destViewController.mySessions = [results objectAtIndex:indexPath.row];
        }
        else
        {
            NSIndexPath *indexPath = [self.myTableView indexPathForSelectedRow];
            NSString *strDate = [dateArray objectAtIndex:indexPath.section];
            NSMutableArray *dateSection = [tempDict objectForKey:strDate];
            
            SessionsDetailViewController *destViewController = segue.destinationViewController;
            destViewController.mySessions = [dateSection objectAtIndex:indexPath.row];
        }
    }
}


@end
