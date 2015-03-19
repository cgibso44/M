//
//	Copyright © 2012 - 2015 Roman Priebe
//
//	This file is part of M - Safe email made simple.
//
//	M is free software: you can redistribute it and/or modify
//	it under the terms of the GNU General Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	(at your option) any later version.
//
//	M is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU General Public License for more details.
//
//	You should have received a copy of the GNU General Public License
//	along with M.  If not, see <http://www.gnu.org/licenses/>.
//





#import <XCTest/XCTest.h>
#import "TestHarness.h"
#import "AppDelegate.h"

@interface CoreData_Tests : TestHarness

@end

@implementation CoreData_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)d_testCoreDataStoreCompatibility
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Mynigma" withExtension:@"momd"];

    NSManagedObjectModel* managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    NSError *error = nil;
    NSPersistentStoreCoordinator* persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:managedObjectModel];

    NSURL *storeUrl = [BUNDLE URLForResource:@"OldMynigmaStore" withExtension:@"storedata"];

    XCTAssertNotNil(storeUrl, @"Store URL is nil!");

    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@YES,
                              NSInferMappingModelAutomaticallyOption:@YES};

    if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil URL:storeUrl options:options error:&error])
    {
        XCTFail(@"Failed to merge store: %@", error);
    }
}

- (void)testThatTheStoreIsSetUpCorrectly
{
    NSPersistentStoreCoordinator* coordinator = [[CoreDataHelper sharedInstance] persistentStoreCoordinator];

    XCTAssertEqual(coordinator.persistentStores.count, 1);

    for(NSPersistentStore* store in coordinator.persistentStores)
    {
        XCTAssertEqualObjects(store.type, NSInMemoryStoreType);
    }
}

@end