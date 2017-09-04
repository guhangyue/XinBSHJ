//
//  AppDelegate.h
//  HuiJu
//
//  Created by IMAC on 2017/9/1.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

