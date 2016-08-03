//
//  TodayViewController.m
//  Today
//
//  Created by 李堪阶 on 16/8/3.
//  Copyright © 2016年 DM. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *chineseCalendarLabel;

@property (strong ,nonatomic) NSTimer *timer;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.preferredContentSize = CGSizeMake(0, 60);
    
    //时间
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"M月d日 HH:mm:ss"];
    NSString *strDate = [dataFormatter stringFromDate:[NSDate date]];
    
    //获取星期几
    NSString *weekStr =  [self getweekDayWithDate:[NSDate date]];
    
    //农历
    NSString *chineseCalendar =  [self dateWithDate:[NSDate date]];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",strDate,weekStr];
    
    self.chineseCalendarLabel.text = chineseCalendar;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTimer) userInfo:nil repeats:YES];
    
}

/**
 *  显示农历
 */
- (NSString *)dateWithDate:(NSDate *)date{
    
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    
    
    NSArray *monthArr = [NSArray arrayWithObjects:
                         @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                         @"九月", @"十月", @"冬月", @"腊月", nil];
    
    NSArray *dayArr = [NSArray arrayWithObjects:
                       @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                       @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                       @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *localeComp = [localeCalendar components:unit fromDate:date];
    
    // localeComp.year;
    NSString *yearStr = [chineseYears objectAtIndex:localeComp.year - 1];
    NSString *monthStr = [monthArr objectAtIndex:localeComp.month-1];
    NSString *dayString = [dayArr objectAtIndex:localeComp.day-1];
    
    
    return [NSString stringWithFormat:@"%@年%@%@",yearStr,monthStr,dayString];
}

/**
 *  获得某天的数据
 *
 *  获取指定的日期是星期几
 */
- (NSString *) getweekDayWithDate:(NSDate *) date{
    
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:date];
    
    NSArray *weeks = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    
    // 1 是周日，2是周一 3.以此类推
    NSNumber *weekNumber = @([comps weekday]);
    
    NSString *weekStr = weeks[[weekNumber intValue]-1];
    
    return weekStr;
    
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets{
    return UIEdgeInsetsZero;
}


- (void)changeTimer{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dfm = [[NSDateFormatter alloc]init];
    
    dfm.dateFormat = @"M月d日 HH:mm:ss";
    
    NSString *dateString = [dfm stringFromDate:date];
    
    //获取星期几
    NSString *weekStr =  [self getweekDayWithDate:[NSDate date]];
    
    //农历
    NSString *chineseCalendar =  [self dateWithDate:[NSDate date]];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",dateString,weekStr];
    
    self.chineseCalendarLabel.text = chineseCalendar;
}



- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {

    completionHandler(NCUpdateResultNewData);
}

@end
