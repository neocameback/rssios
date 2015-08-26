// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Rss.h instead.

#import <CoreData/CoreData.h>

extern const struct RssAttributes {
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *rssLink;
	__unsafe_unretained NSString *rssTitle;
	__unsafe_unretained NSString *shouldCache;
	__unsafe_unretained NSString *updatedAt;
} RssAttributes;

extern const struct RssRelationships {
	__unsafe_unretained NSString *nodeList;
} RssRelationships;

@class RssNode;

@interface RssID : NSManagedObjectID {}
@end

@interface _Rss : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RssID* objectID;

@property (nonatomic, strong) NSDate* createdAt;

//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* rssLink;

//- (BOOL)validateRssLink:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* rssTitle;

//- (BOOL)validateRssTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* shouldCache;

@property (atomic) BOOL shouldCacheValue;
- (BOOL)shouldCacheValue;
- (void)setShouldCacheValue:(BOOL)value_;

//- (BOOL)validateShouldCache:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* updatedAt;

//- (BOOL)validateUpdatedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSOrderedSet *nodeList;

- (NSMutableOrderedSet*)nodeListSet;

@end

@interface _Rss (NodeListCoreDataGeneratedAccessors)
- (void)addNodeList:(NSOrderedSet*)value_;
- (void)removeNodeList:(NSOrderedSet*)value_;
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

- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;

- (NSString*)primitiveRssLink;
- (void)setPrimitiveRssLink:(NSString*)value;

- (NSString*)primitiveRssTitle;
- (void)setPrimitiveRssTitle:(NSString*)value;

- (NSNumber*)primitiveShouldCache;
- (void)setPrimitiveShouldCache:(NSNumber*)value;

- (BOOL)primitiveShouldCacheValue;
- (void)setPrimitiveShouldCacheValue:(BOOL)value_;

- (NSDate*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate*)value;

- (NSMutableOrderedSet*)primitiveNodeList;
- (void)setPrimitiveNodeList:(NSMutableOrderedSet*)value;

@end
