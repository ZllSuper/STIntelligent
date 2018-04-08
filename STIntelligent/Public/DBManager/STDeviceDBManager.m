//
//  STDeviceDBManager.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/1.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "STDeviceDBManager.h"
#import <sqlite3.h>

@interface STDeviceDBManager ()
{
    CFMutableDictionaryRef _dbStmtCache;
    sqlite3 *_db;
}
@property (nonatomic, copy) NSString *dbPath;

@end

@implementation STDeviceDBManager

+ (STDeviceDBManager *)shareInstace
{
    static dispatch_once_t onceToken;
    static STDeviceDBManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[STDeviceDBManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init])
    {
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.dbPath = [documentsPath stringByAppendingPathComponent:@"STDevice.db"];
        [self copyDatabaseIfNeeded];
        [self dbOpen];
        if (![self dbOpen])
        {
            [self dbClose];
            if (![self dbOpen])
            {
                [self dbClose];
                return nil;
            }
        }
    }
    return self;
}

- (void)copyDatabaseIfNeeded
{
    NSFileManager *fm = [[NSFileManager alloc] init];
    void (^copyDb)(void) = ^(void)
    {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"STDevice" ofType:@"db"];
        NSAssert1(sourcePath, @"source db does not exist at path %@",sourcePath);
        
        NSError *copyError = nil;
        if( ![fm copyItemAtPath:sourcePath toPath:self.dbPath error:&copyError] )
        {
            BXHLog(@"ERROR | db could not be copied: %@", copyError);
        }
    };
    if( ![fm fileExistsAtPath:self.dbPath] )
    {
        BXHLog(@"INFO | db file needs copying");
        copyDb();
    }
}

#pragma mark - pubiic
- (BOOL)autoInsertUser:(AccountInfo *)accountInfo
{
    NSString *sql = @"insert or replace into ST_User (userId, name) values (?1, ?2);";
    sqlite3_stmt *stmt = [self dbPrepareStmt:sql];
    if (!stmt) return NO;
    
    sqlite3_bind_text(stmt, 1, accountInfo.userId.UTF8String, -1, NULL);
    sqlite3_bind_text(stmt, 2, accountInfo.name.UTF8String, -1, NULL);
    
    int result = sqlite3_step(stmt);
    if (result != SQLITE_DONE)
    {
        NSLog(@"%s line:%d sqlite insert error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
        return NO;
    }
    return YES;
}

- (NSMutableArray<DeveicePageModel *> *)getDevicePages
{
    NSString *sql = @"select pageId, cameraOne, cameraTwo, cameraThree, cameraFour, catEye, name from ST_DevicePage where userId = ?1;";
    sqlite3_stmt *stmt = [self dbPrepareStmt:sql];
    if (!stmt) return nil;
    sqlite3_bind_text(stmt, 1, [KAccountInfo.userId UTF8String], -1, NULL);
    
    NSMutableArray *items = [NSMutableArray new];
    do {
        int result = sqlite3_step(stmt);
        if (result == SQLITE_ROW)
        {
            char *pageId = (char *)sqlite3_column_text(stmt, 0);
            char *cameraOne = (char *)sqlite3_column_text(stmt, 1);
            char *cameraTwo = (char *)sqlite3_column_text(stmt, 2);
            char *cameraThree = (char *)sqlite3_column_text(stmt, 3);
            char *cameraFour = (char *)sqlite3_column_text(stmt, 4);
            char *catEye = (char *)sqlite3_column_text(stmt, 5);
            char *name = (char *)sqlite3_column_text(stmt, 5);
            
            DeveicePageModel *pageModel = [[DeveicePageModel alloc] init];
            pageModel.pageId = [NSString stringWithUTF8String:pageId];
            if(cameraOne) pageModel.cameraOne.cameraId = [NSString stringWithUTF8String:cameraOne];
            if(cameraTwo) pageModel.cameraTwo.cameraId = [NSString stringWithUTF8String:cameraTwo];
            if(cameraThree) pageModel.cameraThree.cameraId = [NSString stringWithUTF8String:cameraThree];
            if(cameraFour) pageModel.cameraFour.cameraId = [NSString stringWithUTF8String:cameraFour];
            if (catEye) pageModel.maoYanModel.uid = [NSString stringWithUTF8String:catEye];
            if (name) pageModel.name = [NSString stringWithUTF8String:name];
            [items addObject:pageModel];
        }
        else if (result == SQLITE_DONE)
        {
            break;
        }
        else
        {
            BXHLog(@"%s line:%d sqlite query error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
            break;
        }
    } while (1);
    return items;
}

- (void)fillPageModelWithPageModel:(DeveicePageModel *)pageModel
{
    if (!StringIsEmpty(pageModel.maoYanModel.uid))
    {
        [self fillMaoYanModelWithMaoYanModelID:pageModel.maoYanModel.uid maoYanModel:pageModel.maoYanModel];
    }
    
    if (!StringIsEmpty(pageModel.cameraOne.cameraId))
    {
        [self fillSheXiangTouWithSheXiangTou:pageModel.cameraOne.cameraId sheXiangTouModel:pageModel.cameraOne];
    }
    
    if (!StringIsEmpty(pageModel.cameraTwo.cameraId))
    {
        [self fillSheXiangTouWithSheXiangTou:pageModel.cameraTwo.cameraId sheXiangTouModel:pageModel.cameraTwo];
    }

    if (!StringIsEmpty(pageModel.cameraThree.cameraId))
    {
        [self fillSheXiangTouWithSheXiangTou:pageModel.cameraThree.cameraId sheXiangTouModel:pageModel.cameraThree];
    }

    if (!StringIsEmpty(pageModel.cameraFour.cameraId))
    {
        [self fillSheXiangTouWithSheXiangTou:pageModel.cameraFour.cameraId sheXiangTouModel:pageModel.cameraFour];
    }
}

- (MaoYanModel *)fillMaoYanModelWithMaoYanModelID:(NSString *)maoYanId maoYanModel:(MaoYanModel *)maoYanModel
{
    if (!maoYanModel)
    {
        maoYanModel = [[MaoYanModel alloc] init];
    }
    
    NSString *sql = @"select name, image, reqid, bid from ST_CatEye where catEyeId = ?1;";
    sqlite3_stmt *stmt = [self dbPrepareStmt:sql];
    if (!stmt) return nil;
    sqlite3_bind_text(stmt, 1, [maoYanId UTF8String], -1, NULL);
    
    int result = sqlite3_step(stmt);
    if (result == SQLITE_ROW)
    {
        char *name = (char *)sqlite3_column_text(stmt, 0);
        char *image = (char *)sqlite3_column_text(stmt, 1);
        char *repid = (char *)sqlite3_column_text(stmt, 2);
        char *bid = (char *)sqlite3_column_text(stmt, 3);
        
        if(name) maoYanModel.name = [NSString stringWithUTF8String:name];
        if(image) maoYanModel.image = [NSString stringWithUTF8String:image];
        if(repid) maoYanModel.reqid = [NSString stringWithUTF8String:repid];
        if(bid) maoYanModel.bid = [NSString stringWithUTF8String:bid];
    }
    else
    {
        if (result == SQLITE_DONE)
        {
            
            BXHLog(@"%s line:%d sqlite query error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
        }
    }
    
    return maoYanModel;
}

- (SheXiangTouModel *)fillSheXiangTouWithSheXiangTou:(NSString *)sheXiangTouId sheXiangTouModel:(SheXiangTouModel *)sheXiangTouModel
{
    if (!sheXiangTouModel)
    {
        sheXiangTouModel = [[SheXiangTouModel alloc] init];
    }
    
    NSString *sql = @"select name, image from ST_Camera where cameraId = ?1;";
    sqlite3_stmt *stmt = [self dbPrepareStmt:sql];
    if (!stmt) return nil;
    sqlite3_bind_text(stmt, 1, [sheXiangTouId UTF8String], -1, NULL);
    
    int result = sqlite3_step(stmt);
    if (result == SQLITE_ROW)
    {
        char *name = (char *)sqlite3_column_text(stmt, 0);
        char *image = (char *)sqlite3_column_text(stmt, 1);
        
        if(name) sheXiangTouModel.name = [NSString stringWithUTF8String:name];
        if(image) sheXiangTouModel.image = [NSString stringWithUTF8String:image];
    }
    else
    {
        if (result == SQLITE_DONE)
        {
            
            BXHLog(@"%s line:%d sqlite query error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
        }
    }
    return sheXiangTouModel;

}

- (BOOL)insertOrUpdatePageModel:(DeveicePageModel *)pageModel
{
    NSString *sql = @"insert or replace into ST_DevicePage (pageId, cameraOne, cameraTwo, cameraThree, cameraFour, catEye, name, userId, defaultImage, defaultIndex) values (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10);";
    sqlite3_stmt *stmt = [self dbPrepareStmt:sql];
    if (!stmt) return NO;
    sqlite3_bind_text(stmt, 1, pageModel.pageId.UTF8String, -1, NULL);
    sqlite3_bind_text(stmt, 2, StringIsEmpty(pageModel.cameraOne.cameraId)? NULL : pageModel.cameraOne.cameraId.UTF8String, -1, NULL);
    sqlite3_bind_text(stmt, 3, StringIsEmpty(pageModel.cameraTwo.cameraId)? NULL : pageModel.cameraTwo.cameraId.UTF8String, -1, NULL);
    sqlite3_bind_text(stmt, 4, StringIsEmpty(pageModel.cameraThree.cameraId)? NULL : pageModel.cameraThree.cameraId.UTF8String, -1, NULL);
    sqlite3_bind_text(stmt, 5, StringIsEmpty(pageModel.cameraFour.cameraId)? NULL : pageModel.cameraFour.cameraId.UTF8String, -1, NULL);
    sqlite3_bind_text(stmt, 6, StringIsEmpty(pageModel.maoYanModel.uid)? NULL : pageModel.maoYanModel.uid.UTF8String, -1, NULL);
    sqlite3_bind_text(stmt, 7, StringIsEmpty(pageModel.name)? NULL : pageModel.name.UTF8String, -1, NULL);
    sqlite3_bind_text(stmt, 8, KAccountInfo.userId.UTF8String, -1, NULL);
    sqlite3_bind_text(stmt, 9, StringIsEmpty(pageModel.defaultImage)? NULL : pageModel.defaultImage.UTF8String, -1, NULL);
    sqlite3_bind_int(stmt, 10, pageModel.defaultIndex);

    
    int result = sqlite3_step(stmt);
    if (result != SQLITE_DONE)
    {
        NSLog(@"%s line:%d sqlite insert error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
        return NO;
    }
    return YES;
}

- (BOOL)insertOrUpdateMaoYanModel:(MaoYanModel *)maoYanModel
{
    NSString *sql = @"insert or replace into ST_CatEye (catEyeId, name, image, reqid, bid) values (?1, ?2, ?3, ?4, ?5);";
    sqlite3_stmt *stmt = [self dbPrepareStmt:sql];
    if (!stmt) return NO;
    sqlite3_bind_text(stmt, 1, maoYanModel.uid.UTF8String, -1, NULL);
    sqlite3_bind_text(stmt, 2, StringIsEmpty(maoYanModel.name)? NULL : maoYanModel.name.UTF8String, -1, NULL);
    sqlite3_bind_text(stmt, 3, StringIsEmpty(maoYanModel.image)? NULL : maoYanModel.image.UTF8String, -1, NULL);
    sqlite3_bind_text(stmt, 4, StringIsEmpty(maoYanModel.reqid)? NULL : maoYanModel.reqid.UTF8String, -1, NULL);
    sqlite3_bind_text(stmt, 5, StringIsEmpty(maoYanModel.bid)? NULL : maoYanModel.bid.UTF8String, -1, NULL);
    int result = sqlite3_step(stmt);
    if (result != SQLITE_DONE)
    {
        NSLog(@"%s line:%d sqlite insert error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
        return NO;
    }
    return YES;
}

- (BOOL)insertOrUpdateSheXiangTouModel:(SheXiangTouModel *)sheXiangTouModel
{
    NSString *sql = @"insert or replace into ST_CatEye (cameraId, name, image) values (?1, ?2, ?3);";
    sqlite3_stmt *stmt = [self dbPrepareStmt:sql];
    if (!stmt) return NO;
    sqlite3_bind_text(stmt, 1, sheXiangTouModel.cameraId.UTF8String, -1, NULL);
    sqlite3_bind_text(stmt, 2, StringIsEmpty(sheXiangTouModel.name)? NULL : sheXiangTouModel.name.UTF8String, -1, NULL);
    sqlite3_bind_text(stmt, 3, StringIsEmpty(sheXiangTouModel.image)? NULL : sheXiangTouModel.image.UTF8String, -1, NULL);
    int result = sqlite3_step(stmt);
    if (result != SQLITE_DONE)
    {
        NSLog(@"%s line:%d sqlite insert error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
        return NO;
    }
    return YES;
}

#pragma mark - private
- (BOOL)dbOpen
{
    if (_db) return YES;
    int result = sqlite3_open(self.dbPath.UTF8String, &_db);
    if (result == SQLITE_OK)
    {
        CFDictionaryKeyCallBacks keyCallbacks = kCFCopyStringDictionaryKeyCallBacks;
        CFDictionaryValueCallBacks valueCallbacks = {0};
        _dbStmtCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &keyCallbacks, &valueCallbacks);
        return YES;
    } else {
        _db = NULL;
        if (_dbStmtCache) CFRelease(_dbStmtCache);
        _dbStmtCache = NULL;
        [self dbClose];
        NSLog(@"%s line:%d sqlite open failed (%d).", __FUNCTION__, __LINE__, result);
        return NO;
    }
}

- (BOOL)dbClose
{
    if (!_db) return YES;
    
    int  result = 0;
    BOOL retry = NO;
    BOOL stmtFinalized = NO;
    
    if (_dbStmtCache) CFRelease(_dbStmtCache);
    _dbStmtCache = NULL;
    
    do {
        retry = NO;
        result = sqlite3_close(_db);
        if (result == SQLITE_BUSY || result == SQLITE_LOCKED)
        {
            if (!stmtFinalized)
            {
                stmtFinalized = YES;
                sqlite3_stmt *stmt;
                while ((stmt = sqlite3_next_stmt(_db, nil)) != 0)
                {
                    sqlite3_finalize(stmt);
                    retry = YES;
                }
            }
        }
        else if (result != SQLITE_OK)
        {
            NSLog(@"%s line:%d sqlite close failed (%d).", __FUNCTION__, __LINE__, result);
        }
    } while (retry);
    _db = NULL;
    return YES;
}

- (sqlite3_stmt *)dbPrepareStmt:(NSString *)sql
{
    if (![self dbOpen] || sql.length == 0 || !_dbStmtCache) return NULL;
    sqlite3_stmt *stmt = (sqlite3_stmt *)CFDictionaryGetValue(_dbStmtCache, (__bridge const void *)(sql));
    if (!stmt)
    {
        int result = sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL);
        if (result != SQLITE_OK)
        {
            NSLog(@"%s line:%d sqlite stmt prepare error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
            return NULL;
        }
        CFDictionarySetValue(_dbStmtCache, (__bridge const void *)(sql), stmt);
    }
    else
    {
        sqlite3_reset(stmt);
    }
    return stmt;
}



@end
