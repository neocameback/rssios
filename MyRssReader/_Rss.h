// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Rss.h instead.

#import <CoreData/CoreData.h>

extern const struct RssAttributes {
	__unsafe_unretained NSString *rssLink;
	__unsafe_unretained NSString *rssTitle;
} RssAttributes;

@interface RssID : NSManagedObjectID {}
@end

@interface _Rss : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RssID* objectID;

@property (nonatomic, strong) NSString* rssLink;

//- (BOOL)validateRssLink:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* rssTitle;

//- (BOOL)validateRssTitle:(id*)value_ error:(NSError**)error_;

@end

@interface _Rss (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveRssLink;
- (void)setPrimitiveRssLink:(NSString*)value;

- (NSString*)primitiveRssTitle;
- (void)setPrimitiveRssTitle:(NSString*)value;

@end
