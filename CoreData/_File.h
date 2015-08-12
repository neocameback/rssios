// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to File.h instead.

#import <CoreData/CoreData.h>

extern const struct FileAttributes {
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *desc;
	__unsafe_unretained NSString *downloadedBytes;
	__unsafe_unretained NSString *expectedBytes;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *type;
	__unsafe_unretained NSString *updatedAt;
	__unsafe_unretained NSString *url;
} FileAttributes;

@interface FileID : NSManagedObjectID {}
@end

@interface _File : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) FileID* objectID;

@property (nonatomic, strong) NSDate* createdAt;

//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* desc;

//- (BOOL)validateDesc:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* downloadedBytes;

@property (atomic) double downloadedBytesValue;
- (double)downloadedBytesValue;
- (void)setDownloadedBytesValue:(double)value_;

//- (BOOL)validateDownloadedBytes:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* expectedBytes;

@property (atomic) double expectedBytesValue;
- (double)expectedBytesValue;
- (void)setExpectedBytesValue:(double)value_;

//- (BOOL)validateExpectedBytes:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* type;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* updatedAt;

//- (BOOL)validateUpdatedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* url;

//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;

@end

@interface _File (CoreDataGeneratedPrimitiveAccessors)

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

- (NSDate*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate*)value;

- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;

@end
