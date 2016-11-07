// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RssNode.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class Rss;
@class Subtitle;

@interface RssNodeID : NSManagedObjectID {}
@end

@interface _RssNode : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RssNodeID *objectID;

@property (nonatomic, strong, nullable) NSString* bookmarkStatus;

@property (nonatomic, strong, nullable) NSNumber* castable;

@property (atomic) BOOL castableValue;
- (BOOL)castableValue;
- (void)setCastableValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSDate* createdAt;

@property (nonatomic, strong, nullable) NSNumber* isAddedToBoomark;

@property (atomic) BOOL isAddedToBoomarkValue;
- (BOOL)isAddedToBoomarkValue;
- (void)setIsAddedToBoomarkValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSNumber* isDeletedFlag;

@property (atomic) BOOL isDeletedFlagValue;
- (BOOL)isDeletedFlagValue;
- (void)setIsDeletedFlagValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSString* nodeDesc;

@property (nonatomic, strong, nullable) NSString* nodeImage;

@property (nonatomic, strong, nullable) NSString* nodeLink;

@property (nonatomic, strong, nullable) NSString* nodeSource;

@property (nonatomic, strong, nullable) NSString* nodeTitle;

@property (nonatomic, strong, nullable) NSString* nodeType;

@property (nonatomic, strong, nullable) NSString* nodeUrl;

@property (nonatomic, strong, nullable) NSDate* updatedAt;

@property (nonatomic, strong, nullable) Rss *rss;

@property (nonatomic, strong, nullable) NSOrderedSet<Subtitle*> *subtitles;
- (nullable NSMutableOrderedSet<Subtitle*>*)subtitlesSet;

@end

@interface _RssNode (SubtitlesCoreDataGeneratedAccessors)
- (void)addSubtitles:(NSOrderedSet<Subtitle*>*)value_;
- (void)removeSubtitles:(NSOrderedSet<Subtitle*>*)value_;
- (void)addSubtitlesObject:(Subtitle*)value_;
- (void)removeSubtitlesObject:(Subtitle*)value_;

- (void)insertObject:(Subtitle*)value inSubtitlesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSubtitlesAtIndex:(NSUInteger)idx;
- (void)insertSubtitles:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSubtitlesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSubtitlesAtIndex:(NSUInteger)idx withObject:(Subtitle*)value;
- (void)replaceSubtitlesAtIndexes:(NSIndexSet *)indexes withSubtitles:(NSArray *)values;

@end

@interface _RssNode (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveBookmarkStatus;
- (void)setPrimitiveBookmarkStatus:(nullable NSString*)value;

- (nullable NSNumber*)primitiveCastable;
- (void)setPrimitiveCastable:(nullable NSNumber*)value;

- (BOOL)primitiveCastableValue;
- (void)setPrimitiveCastableValue:(BOOL)value_;

- (nullable NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(nullable NSDate*)value;

- (nullable NSNumber*)primitiveIsAddedToBoomark;
- (void)setPrimitiveIsAddedToBoomark:(nullable NSNumber*)value;

- (BOOL)primitiveIsAddedToBoomarkValue;
- (void)setPrimitiveIsAddedToBoomarkValue:(BOOL)value_;

- (nullable NSNumber*)primitiveIsDeletedFlag;
- (void)setPrimitiveIsDeletedFlag:(nullable NSNumber*)value;

- (BOOL)primitiveIsDeletedFlagValue;
- (void)setPrimitiveIsDeletedFlagValue:(BOOL)value_;

- (nullable NSString*)primitiveNodeDesc;
- (void)setPrimitiveNodeDesc:(nullable NSString*)value;

- (nullable NSString*)primitiveNodeImage;
- (void)setPrimitiveNodeImage:(nullable NSString*)value;

- (nullable NSString*)primitiveNodeLink;
- (void)setPrimitiveNodeLink:(nullable NSString*)value;

- (nullable NSString*)primitiveNodeSource;
- (void)setPrimitiveNodeSource:(nullable NSString*)value;

- (nullable NSString*)primitiveNodeTitle;
- (void)setPrimitiveNodeTitle:(nullable NSString*)value;

- (nullable NSString*)primitiveNodeType;
- (void)setPrimitiveNodeType:(nullable NSString*)value;

- (nullable NSString*)primitiveNodeUrl;
- (void)setPrimitiveNodeUrl:(nullable NSString*)value;

- (nullable NSDate*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(nullable NSDate*)value;

- (Rss*)primitiveRss;
- (void)setPrimitiveRss:(Rss*)value;

- (NSMutableOrderedSet<Subtitle*>*)primitiveSubtitles;
- (void)setPrimitiveSubtitles:(NSMutableOrderedSet<Subtitle*>*)value;

@end

@interface RssNodeAttributes: NSObject 
+ (NSString *)bookmarkStatus;
+ (NSString *)castable;
+ (NSString *)createdAt;
+ (NSString *)isAddedToBoomark;
+ (NSString *)isDeletedFlag;
+ (NSString *)nodeDesc;
+ (NSString *)nodeImage;
+ (NSString *)nodeLink;
+ (NSString *)nodeSource;
+ (NSString *)nodeTitle;
+ (NSString *)nodeType;
+ (NSString *)nodeUrl;
+ (NSString *)updatedAt;
@end

@interface RssNodeRelationships: NSObject
+ (NSString *)rss;
+ (NSString *)subtitles;
@end

NS_ASSUME_NONNULL_END
