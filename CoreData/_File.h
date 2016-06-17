// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to File.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface FileID : NSManagedObjectID {}
@end

@interface _File : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) FileID *objectID;

@property (nonatomic, strong, nullable) NSString* absoluteUrl;

@property (nonatomic, strong, nullable) NSDate* createdAt;

@property (nonatomic, strong, nullable) NSString* desc;

@property (nonatomic, strong, nullable) NSNumber* downloadedBytes;

@property (atomic) double downloadedBytesValue;
- (double)downloadedBytesValue;
- (void)setDownloadedBytesValue:(double)value_;

@property (nonatomic, strong, nullable) NSNumber* expectedBytes;

@property (atomic) double expectedBytesValue;
- (double)expectedBytesValue;
- (void)setExpectedBytesValue:(double)value_;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSNumber* progress;

@property (atomic) int16_t progressValue;
- (int16_t)progressValue;
- (void)setProgressValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSString* type;

@property (nonatomic, strong, nullable) NSDate* updatedAt;

@property (nonatomic, strong, nullable) NSString* url;

@end

@interface _File (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAbsoluteUrl;
- (void)setPrimitiveAbsoluteUrl:(NSString*)value;

- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;

- (NSString*)primitiveDesc;
- (void)setPrimitiveDesc:(NSString*)value;

- (NSNumber*)primitiveDownloadedBytes;
- (void)setPrimitiveDownloadedBytes:(NSNumber*)value;

- (double)primitiveDownloadedBytesValue;
- (void)setPrimitiveDownloadedBytesValue:(double)value_;

- (NSNumber*)primitiveExpectedBytes;
- (void)setPrimitiveExpectedBytes:(NSNumber*)value;

- (double)primitiveExpectedBytesValue;
- (void)setPrimitiveExpectedBytesValue:(double)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSNumber*)primitiveProgress;
- (void)setPrimitiveProgress:(NSNumber*)value;

- (int16_t)primitiveProgressValue;
- (void)setPrimitiveProgressValue:(int16_t)value_;

- (NSDate*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate*)value;

- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;

@end

@interface FileAttributes: NSObject 
+ (NSString *)absoluteUrl;
+ (NSString *)createdAt;
+ (NSString *)desc;
+ (NSString *)downloadedBytes;
+ (NSString *)expectedBytes;
+ (NSString *)name;
+ (NSString *)progress;
+ (NSString *)type;
+ (NSString *)updatedAt;
+ (NSString *)url;
@end

NS_ASSUME_NONNULL_END
