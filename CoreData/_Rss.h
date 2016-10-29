// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Rss.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class RssNode;

@interface RssID : NSManagedObjectID {}
@end

@interface _Rss : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RssID *objectID;

@property (nonatomic, strong, nullable) NSDate* createdAt;

@property (nonatomic, strong, nullable) NSNumber* isBookmarkRss;

@property (atomic) BOOL isBookmarkRssValue;
- (BOOL)isBookmarkRssValue;
- (void)setIsBookmarkRssValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSString* rssLink;

@property (nonatomic, strong, nullable) NSString* rssTitle;

@property (nonatomic, strong, nullable) NSNumber* shouldCache;

@property (atomic) BOOL shouldCacheValue;
- (BOOL)shouldCacheValue;
- (void)setShouldCacheValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSDate* updatedAt;

@property (nonatomic, strong, nullable) NSOrderedSet<RssNode*> *nodeList;
- (nullable NSMutableOrderedSet<RssNode*>*)nodeListSet;

@end

@interface _Rss (NodeListCoreDataGeneratedAccessors)
- (void)addNodeList:(NSOrderedSet<RssNode*>*)value_;
- (void)removeNodeList:(NSOrderedSet<RssNode*>*)value_;
- (void)addNodeListObject:(RssNode*)value_;
- (void)removeNodeListObject:(RssNode*)value_;

- (void)insertObject:(RssNode*)value inNodeListAtIndex:(NSUInteger)idx;
- (void)removeObjectFromNodeListAtIndex:(NSUInteger)idx;
- (void)insertNodeList:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeNodeListAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInNodeListAtIndex:(NSUInteger)idx withObject:(RssNode*)value;
- (void)replaceNodeListAtIndexes:(NSIndexSet *)indexes withNodeList:(NSArray *)values;

@end

@interface _Rss (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(nullable NSDate*)value;

- (nullable NSNumber*)primitiveIsBookmarkRss;
- (void)setPrimitiveIsBookmarkRss:(nullable NSNumber*)value;

- (BOOL)primitiveIsBookmarkRssValue;
- (void)setPrimitiveIsBookmarkRssValue:(BOOL)value_;

- (nullable NSString*)primitiveRssLink;
- (void)setPrimitiveRssLink:(nullable NSString*)value;

- (nullable NSString*)primitiveRssTitle;
- (void)setPrimitiveRssTitle:(nullable NSString*)value;

- (nullable NSNumber*)primitiveShouldCache;
- (void)setPrimitiveShouldCache:(nullable NSNumber*)value;

- (BOOL)primitiveShouldCacheValue;
- (void)setPrimitiveShouldCacheValue:(BOOL)value_;

- (nullable NSDate*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(nullable NSDate*)value;

- (NSMutableOrderedSet<RssNode*>*)primitiveNodeList;
- (void)setPrimitiveNodeList:(NSMutableOrderedSet<RssNode*>*)value;

@end

@interface RssAttributes: NSObject 
+ (NSString *)createdAt;
+ (NSString *)isBookmarkRss;
+ (NSString *)rssLink;
+ (NSString *)rssTitle;
+ (NSString *)shouldCache;
+ (NSString *)updatedAt;
@end

@interface RssRelationships: NSObject
+ (NSString *)nodeList;
@end

NS_ASSUME_NONNULL_END
