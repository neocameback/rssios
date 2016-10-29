// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Subtitle.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class Node;
@class File;
@class RssNode;

@interface SubtitleID : NSManagedObjectID {}
@end

@interface _Subtitle : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SubtitleID *objectID;

@property (nonatomic, strong, nullable) NSString* absoluteUrl;

@property (nonatomic, strong, nullable) NSNumber* castable;

@property (atomic) BOOL castableValue;
- (BOOL)castableValue;
- (void)setCastableValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSDate* createdAt;

@property (nonatomic, strong, nullable) NSString* extension;

@property (nonatomic, strong, nullable) NSString* languageCode;

@property (nonatomic, strong, nullable) NSString* link;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSString* type;

@property (nonatomic, strong, nullable) NSDate* updatedAt;

@property (nonatomic, strong, nullable) Node *bookmarkedNode;

@property (nonatomic, strong, nullable) File *file;

@property (nonatomic, strong, nullable) RssNode *rssNode;

@end

@interface _Subtitle (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveAbsoluteUrl;
- (void)setPrimitiveAbsoluteUrl:(nullable NSString*)value;

- (nullable NSNumber*)primitiveCastable;
- (void)setPrimitiveCastable:(nullable NSNumber*)value;

- (BOOL)primitiveCastableValue;
- (void)setPrimitiveCastableValue:(BOOL)value_;

- (nullable NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(nullable NSDate*)value;

- (nullable NSString*)primitiveExtension;
- (void)setPrimitiveExtension:(nullable NSString*)value;

- (nullable NSString*)primitiveLanguageCode;
- (void)setPrimitiveLanguageCode:(nullable NSString*)value;

- (nullable NSString*)primitiveLink;
- (void)setPrimitiveLink:(nullable NSString*)value;

- (nullable NSString*)primitiveName;
- (void)setPrimitiveName:(nullable NSString*)value;

- (nullable NSDate*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(nullable NSDate*)value;

- (Node*)primitiveBookmarkedNode;
- (void)setPrimitiveBookmarkedNode:(Node*)value;

- (File*)primitiveFile;
- (void)setPrimitiveFile:(File*)value;

- (RssNode*)primitiveRssNode;
- (void)setPrimitiveRssNode:(RssNode*)value;

@end

@interface SubtitleAttributes: NSObject 
+ (NSString *)absoluteUrl;
+ (NSString *)castable;
+ (NSString *)createdAt;
+ (NSString *)extension;
+ (NSString *)languageCode;
+ (NSString *)link;
+ (NSString *)name;
+ (NSString *)type;
+ (NSString *)updatedAt;
@end

@interface SubtitleRelationships: NSObject
+ (NSString *)bookmarkedNode;
+ (NSString *)file;
+ (NSString *)rssNode;
@end

NS_ASSUME_NONNULL_END
