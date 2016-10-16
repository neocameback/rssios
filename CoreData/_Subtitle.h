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
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SubtitleID *objectID;

@property (nonatomic, strong, nullable) NSString* absoluteUrl;

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

- (NSString*)primitiveAbsoluteUrl;
- (void)setPrimitiveAbsoluteUrl:(NSString*)value;

- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;

- (NSString*)primitiveExtension;
- (void)setPrimitiveExtension:(NSString*)value;

- (NSString*)primitiveLanguageCode;
- (void)setPrimitiveLanguageCode:(NSString*)value;

- (NSString*)primitiveLink;
- (void)setPrimitiveLink:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSDate*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate*)value;

- (Node*)primitiveBookmarkedNode;
- (void)setPrimitiveBookmarkedNode:(Node*)value;

- (File*)primitiveFile;
- (void)setPrimitiveFile:(File*)value;

- (RssNode*)primitiveRssNode;
- (void)setPrimitiveRssNode:(RssNode*)value;

@end

@interface SubtitleAttributes: NSObject 
+ (NSString *)absoluteUrl;
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
