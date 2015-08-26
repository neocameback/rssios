// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RssNode.h instead.

#import <CoreData/CoreData.h>

extern const struct RssNodeAttributes {
	__unsafe_unretained NSString *bookmarkStatus;
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *isAddedToBoomark;
	__unsafe_unretained NSString *isDeletedFlag;
	__unsafe_unretained NSString *nodeDesc;
	__unsafe_unretained NSString *nodeImage;
	__unsafe_unretained NSString *nodeSource;
	__unsafe_unretained NSString *nodeTitle;
	__unsafe_unretained NSString *nodeType;
	__unsafe_unretained NSString *nodeUrl;
	__unsafe_unretained NSString *updatedAt;
} RssNodeAttributes;

extern const struct RssNodeRelationships {
	__unsafe_unretained NSString *rss;
} RssNodeRelationships;

@class Rss;

@interface RssNodeID : NSManagedObjectID {}
@end

@interface _RssNode : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RssNodeID* objectID;

@property (nonatomic, strong) NSString* bookmarkStatus;

//- (BOOL)validateBookmarkStatus:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* createdAt;

//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* isAddedToBoomark;

@property (atomic) BOOL isAddedToBoomarkValue;
- (BOOL)isAddedToBoomarkValue;
- (void)setIsAddedToBoomarkValue:(BOOL)value_;

//- (BOOL)validateIsAddedToBoomark:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* isDeletedFlag;

@property (atomic) BOOL isDeletedFlagValue;
- (BOOL)isDeletedFlagValue;
- (void)setIsDeletedFlagValue:(BOOL)value_;

//- (BOOL)validateIsDeletedFlag:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* nodeDesc;

//- (BOOL)validateNodeDesc:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* nodeImage;

//- (BOOL)validateNodeImage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* nodeSource;

//- (BOOL)validateNodeSource:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* nodeTitle;

//- (BOOL)validateNodeTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* nodeType;

//- (BOOL)validateNodeType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* nodeUrl;

//- (BOOL)validateNodeUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* updatedAt;

//- (BOOL)validateUpdatedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Rss *rss;

//- (BOOL)validateRss:(id*)value_ error:(NSError**)error_;

@end

@interface _RssNode (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveBookmarkStatus;
- (void)setPrimitiveBookmarkStatus:(NSString*)value;

- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;

- (NSNumber*)primitiveIsAddedToBoomark;
- (void)setPrimitiveIsAddedToBoomark:(NSNumber*)value;

- (BOOL)primitiveIsAddedToBoomarkValue;
- (void)setPrimitiveIsAddedToBoomarkValue:(BOOL)value_;

- (NSNumber*)primitiveIsDeletedFlag;
- (void)setPrimitiveIsDeletedFlag:(NSNumber*)value;

- (BOOL)primitiveIsDeletedFlagValue;
- (void)setPrimitiveIsDeletedFlagValue:(BOOL)value_;

- (NSString*)primitiveNodeDesc;
- (void)setPrimitiveNodeDesc:(NSString*)value;

- (NSString*)primitiveNodeImage;
- (void)setPrimitiveNodeImage:(NSString*)value;

- (NSString*)primitiveNodeSource;
- (void)setPrimitiveNodeSource:(NSString*)value;

- (NSString*)primitiveNodeTitle;
- (void)setPrimitiveNodeTitle:(NSString*)value;

- (NSString*)primitiveNodeType;
- (void)setPrimitiveNodeType:(NSString*)value;

- (NSString*)primitiveNodeUrl;
- (void)setPrimitiveNodeUrl:(NSString*)value;

- (NSDate*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate*)value;

- (Rss*)primitiveRss;
- (void)setPrimitiveRss:(Rss*)value;

@end
