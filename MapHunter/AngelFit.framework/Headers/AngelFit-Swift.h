// Generated by Apple Swift version 3.0.2 (swiftlang-800.0.63 clang-800.0.42.1)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if defined(__has_attribute) && __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if defined(__has_feature) && __has_feature(modules)
@import CoreData;
@import ObjectiveC;
@import Foundation;
@import CoreBluetooth;
@import CoreLocation;
@import UIKit;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
typedef SWIFT_ENUM(NSInteger, ActionType) {
  ActionTypeMacAddress = 0,
  ActionTypeDeviceInfo = 1,
  ActionTypeLiveData = 2,
  ActionTypeFuncTable = 3,
};

@class NSEntityDescription;
@class NSManagedObjectContext;

SWIFT_CLASS("_TtC8AngelFit5Alarm")
@interface Alarm : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end

@class Device;

@interface Alarm (SWIFT_EXTENSION(AngelFit))
@property (nonatomic) int16_t duration;
@property (nonatomic) int16_t hour;
@property (nonatomic) int16_t id;
@property (nonatomic) int16_t minute;
@property (nonatomic) int16_t repeatList;
@property (nonatomic) int16_t status;
@property (nonatomic) BOOL synchronize;
@property (nonatomic) int16_t type;
@property (nonatomic, strong) Device * _Nullable device;
@end

@class User;
@class FuncTable;
@class Unit;
@class HandGesture;
@class HeartInterval;
enum HeartRateMode : NSInteger;
@class SportData;
@class SleepData;
@class HeartRateData;

SWIFT_CLASS("_TtC8AngelFit12AngelManager")
@interface AngelManager : NSObject
@property (nonatomic, copy) NSString * _Nullable macAddress;
+ (AngelManager * _Nullable)share;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
- (void)getUserinfoWithClosure:(SWIFT_NOESCAPE void (^ _Nonnull)(User * _Nullable))closure;
- (void)getDevice:(NSString * _Nullable)macAddress closure:(void (^ _Nonnull)(Device * _Nullable))closure;
- (void)getMacAddressFromBandWithClosure:(void (^ _Nonnull)(int16_t, NSString * _Nonnull))closure;
- (void)getFuncTable:(NSString * _Nullable)macAddress closure:(void (^ _Nonnull)(FuncTable * _Nullable))closure;
- (void)getLiveDataFromBandWithClosure:(void (^ _Nonnull)(int16_t, id _Nullable))closure;
- (void)setUpdateWithClosure:(void (^ _Nonnull)(BOOL))closure;
- (void)setBind:(BOOL)bind closure:(void (^ _Nonnull)(BOOL))closure;
- (void)setDateWithDate:(NSDate * _Nonnull)date closure:(SWIFT_NOESCAPE void (^ _Nonnull)(BOOL))closure;
- (void)getUnit:(NSString * _Nullable)macAddress closure:(SWIFT_NOESCAPE void (^ _Nonnull)(Unit * _Nullable))closure;
- (void)setCamera:(BOOL)open closure:(void (^ _Nonnull)(BOOL))closure;
- (void)setFindPhone:(BOOL)open timeOut:(uint8_t)timeOut macAddress:(NSString * _Nullable)macAddress closure:(SWIFT_NOESCAPE void (^ _Nonnull)(BOOL))closure;
- (void)setGhostWithClosure:(SWIFT_NOESCAPE void (^ _Nonnull)(BOOL))closure;
- (void)setQuickSOS:(BOOL)open macAddress:(NSString * _Nullable)macAddress closure:(SWIFT_NOESCAPE void (^ _Nonnull)(BOOL))closure;
- (void)setRestartWithClosure:(SWIFT_NOESCAPE void (^ _Nonnull)(BOOL))closure;
- (void)setWristRecognition:(BOOL)open lightDuring:(uint8_t)lightDuring closure:(SWIFT_NOESCAPE void (^ _Nonnull)(BOOL))closure;
- (void)getWristRecognition:(NSString * _Nullable)macAddress closure:(SWIFT_NOESCAPE void (^ _Nonnull)(HandGesture * _Nullable))closure;
- (void)getHeartRateInterval:(NSString * _Nullable)macAddress closure:(SWIFT_NOESCAPE void (^ _Nonnull)(HeartInterval * _Nullable))closure;
- (void)setHand:(BOOL)leftHand closure:(SWIFT_NOESCAPE void (^ _Nonnull)(BOOL))closure;
- (void)setHeartRateMode:(enum HeartRateMode)heartRateMode macAddress:(NSString * _Nullable)macAddress closure:(SWIFT_NOESCAPE void (^ _Nonnull)(BOOL))closure;
- (void)setLandscape:(BOOL)flag macAddress:(NSString * _Nullable)macAddress closure:(SWIFT_NOESCAPE void (^ _Nonnull)(BOOL))closure;
- (void)setSynchronizationHealthData:(NSString * _Nullable)macAddress closure:(void (^ _Nonnull)(BOOL, int16_t))closure;
- (void)getSportData:(NSString * _Nullable)macAddress date:(NSDate * _Nonnull)date offset:(NSInteger)offset closure:(SWIFT_NOESCAPE void (^ _Nonnull)(NSArray<SportData *> * _Nonnull))closure;
- (void)getSleepData:(NSString * _Nullable)macAddress date:(NSDate * _Nonnull)date offset:(NSInteger)offset closure:(SWIFT_NOESCAPE void (^ _Nonnull)(NSArray<SleepData *> * _Nonnull))closure;
- (void)getHeartRateData:(NSString * _Nullable)macAddress date:(NSDate * _Nonnull)date offset:(NSInteger)offset closure:(SWIFT_NOESCAPE void (^ _Nonnull)(NSArray<HeartRateData *> * _Nonnull))closure;
- (void)setSynchronizationConfigWithClosure:(void (^ _Nonnull)(BOOL))closure;
- (void)deleteAlarm:(NSString * _Nullable)macAddress alarmId:(int16_t)alarmId closure:(SWIFT_NOESCAPE void (^ _Nonnull)(BOOL))closure;
- (void)getAlarm:(NSString * _Nullable)macAddress alarmId:(int16_t)alarmId closure:(SWIFT_NOESCAPE void (^ _Nonnull)(Alarm * _Nullable))closure;
- (void)getAllAlarmsWithClosure:(SWIFT_NOESCAPE void (^ _Nonnull)(NSArray<Alarm *> * _Nonnull))closure;
- (void)setSynchronizationAlarm:(NSString * _Nullable)macAddress closure:(void (^ _Nonnull)(BOOL))closure;
- (void)getNoticeStatus:(void (^ _Nonnull)(BOOL))closure;
- (void)setMusicSwitch:(BOOL)open macAddress:(NSString * _Nullable)macAddress closure:(void (^ _Nonnull)(BOOL))closure;
- (void)setCallRemind:(BOOL)open delay:(uint8_t)delay macAddress:(NSString * _Nullable)macAddress closure:(void (^ _Nonnull)(BOOL))closure;
@end


@interface AngelManager (SWIFT_EXTENSION(AngelFit))
@end

typedef SWIFT_ENUM(NSInteger, BandMode) {
  BandModeUnbind = 0,
  BandModeBind = 1,
  BandModeLevelup = 2,
};


@interface CBPeripheral (SWIFT_EXTENSION(AngelFit))
@end

typedef SWIFT_ENUM(NSInteger, CommondType) {
  CommondTypeSetTime = 0,
};


SWIFT_CLASS("_TtC8AngelFit6Device")
@interface Device : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end

@class Track;
@class NSSet;

@interface Device (SWIFT_EXTENSION(AngelFit))
- (void)addTracksObject:(Track * _Nonnull)value;
- (void)removeTracksObject:(Track * _Nonnull)value;
- (void)addTracks:(NSSet * _Nonnull)values;
- (void)removeTracks:(NSSet * _Nonnull)values;
@end


@interface Device (SWIFT_EXTENSION(AngelFit))
- (void)addHeartRateDatasObject:(HeartRateData * _Nonnull)value;
- (void)removeHeartRateDatasObject:(HeartRateData * _Nonnull)value;
- (void)addHeartRateDatas:(NSSet * _Nonnull)values;
- (void)removeHeartRateDatas:(NSSet * _Nonnull)values;
@end


@interface Device (SWIFT_EXTENSION(AngelFit))
- (void)addSleepDatasObject:(SleepData * _Nonnull)value;
- (void)removeSleepDatasObject:(SleepData * _Nonnull)value;
- (void)addSleepDatas:(NSSet * _Nonnull)values;
- (void)removeSleepDatas:(NSSet * _Nonnull)values;
@end


@interface Device (SWIFT_EXTENSION(AngelFit))
- (void)addSportDatasObject:(SportData * _Nonnull)value;
- (void)removeSportDatasObject:(SportData * _Nonnull)value;
- (void)addSportDatas:(NSSet * _Nonnull)values;
- (void)removeSportDatas:(NSSet * _Nonnull)values;
@end

@class NSIndexSet;
@class NSOrderedSet;

@interface Device (SWIFT_EXTENSION(AngelFit))
- (void)insertObject:(Alarm * _Nonnull)value inAlarmsAtIndex:(NSInteger)idx;
- (void)removeObjectFromAlarmsAtIndex:(NSInteger)idx;
- (void)insertAlarms:(NSArray<Alarm *> * _Nonnull)values atIndexes:(NSIndexSet * _Nonnull)indexes;
- (void)removeAlarmsAtIndexes:(NSIndexSet * _Nonnull)indexes;
- (void)replaceObjectInAlarmsAtIndex:(NSInteger)idx withObject:(Alarm * _Nonnull)value;
- (void)replaceAlarmsAtIndexes:(NSIndexSet * _Nonnull)indexes withAlarms:(NSArray<Alarm *> * _Nonnull)values;
- (void)addAlarmsObject:(Alarm * _Nonnull)value;
- (void)removeAlarmsObject:(Alarm * _Nonnull)value;
- (void)addAlarms:(NSOrderedSet * _Nonnull)values;
- (void)removeAlarms:(NSOrderedSet * _Nonnull)values;
@end

@class NSDate;
@class LongSit;
@class LostFind;
@class Notice;
@class SilentDistrube;

@interface Device (SWIFT_EXTENSION(AngelFit))
@property (nonatomic) int16_t bandStatus;
@property (nonatomic) int16_t battLevel;
@property (nonatomic) int16_t battStatus;
@property (nonatomic) int16_t deviceId;
@property (nonatomic, copy) NSString * _Nullable deviceUUID;
@property (nonatomic) BOOL findPhoneSwitch;
@property (nonatomic) BOOL landscape;
@property (nonatomic, copy) NSString * _Nullable macAddress;
@property (nonatomic) int16_t mode;
@property (nonatomic) BOOL pairFlag;
@property (nonatomic) BOOL rebootFlag;
@property (nonatomic) BOOL sos;
@property (nonatomic) int16_t type;
@property (nonatomic) int16_t version;
@property (nonatomic, strong) NSDate * _Nullable synDate;
@property (nonatomic, strong) NSOrderedSet * _Nullable alarms;
@property (nonatomic, strong) FuncTable * _Nullable funcTable;
@property (nonatomic, strong) HandGesture * _Nullable handGesture;
@property (nonatomic, strong) HeartInterval * _Nullable heartInterval;
@property (nonatomic, strong) NSSet * _Nullable heartRateDatas;
@property (nonatomic, strong) LongSit * _Nullable longSit;
@property (nonatomic, strong) LostFind * _Nullable lostFind;
@property (nonatomic, strong) Notice * _Nullable notice;
@property (nonatomic, strong) SilentDistrube * _Nullable silentDistrube;
@property (nonatomic, strong) NSSet * _Nullable sleepDatas;
@property (nonatomic, strong) NSSet * _Nullable sportDatas;
@property (nonatomic, strong) NSSet * _Nullable tracks;
@property (nonatomic, strong) Unit * _Nullable unit;
@property (nonatomic, strong) User * _Nullable user;
@end


SWIFT_CLASS("_TtC8AngelFit9FuncTable")
@interface FuncTable : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@interface FuncTable (SWIFT_EXTENSION(AngelFit))
@property (nonatomic) BOOL main_stepCalculation;
@property (nonatomic) BOOL main_sleepMonitor;
@property (nonatomic) BOOL main_singleSport;
@property (nonatomic) BOOL main_realtimeData;
@property (nonatomic) BOOL main_deviceUpdate;
@property (nonatomic) BOOL main_heartRate;
@property (nonatomic) BOOL main_ancs;
@property (nonatomic) BOOL main_timeLine;
@property (nonatomic) int16_t alarmCount;
@property (nonatomic) BOOL alarmType_wakeUp;
@property (nonatomic) BOOL alarmType_sleep;
@property (nonatomic) BOOL alarmType_sport;
@property (nonatomic) BOOL alarmType_medicine;
@property (nonatomic) BOOL alarmType_dating;
@property (nonatomic) BOOL alarmType_party;
@property (nonatomic) BOOL alarmType_metting;
@property (nonatomic) BOOL alarmType_custom;
@property (nonatomic) BOOL control_takePhoto;
@property (nonatomic) BOOL control_music;
@property (nonatomic) BOOL call_calling;
@property (nonatomic) BOOL call_callingContact;
@property (nonatomic) BOOL call_callingNum;
@property (nonatomic) BOOL notify_message;
@property (nonatomic) BOOL notify_email;
@property (nonatomic) BOOL notify_qq;
@property (nonatomic) BOOL notify_weixin;
@property (nonatomic) BOOL notify_sinaWeibo;
@property (nonatomic) BOOL notify_facebook;
@property (nonatomic) BOOL notify_twitter;
@property (nonatomic) BOOL notify2_whatsapp;
@property (nonatomic) BOOL notify2_message;
@property (nonatomic) BOOL notify2_instagram;
@property (nonatomic) BOOL notify2_linkedIn;
@property (nonatomic) BOOL notify2_calendar;
@property (nonatomic) BOOL notify2_skype;
@property (nonatomic) BOOL notify2_alarmClock;
@property (nonatomic) BOOL other_sedentariness;
@property (nonatomic) BOOL other_antilost;
@property (nonatomic) BOOL other_oneTouchCalling;
@property (nonatomic) BOOL other_findPhone;
@property (nonatomic) BOOL other_findDevice;
@property (nonatomic) BOOL other_configDefault;
@property (nonatomic) BOOL other_upHandGesture;
@property (nonatomic) BOOL other_weather;
@property (nonatomic) BOOL sms_tipInfoContact;
@property (nonatomic) BOOL sms_tipInfoNum;
@property (nonatomic) BOOL sms_tipInfoContent;
@property (nonatomic) BOOL other2_staticHR;
@property (nonatomic) BOOL other2_doNotDisturb;
@property (nonatomic) BOOL other2_displayMode;
@property (nonatomic) BOOL other2_heartRateMonitor;
@property (nonatomic) BOOL other2_bilateralAntiLost;
@property (nonatomic) BOOL other2_allAppNotice;
@property (nonatomic) BOOL other2_flipScreen;
@property (nonatomic) BOOL sport_walk;
@property (nonatomic) BOOL sport_run;
@property (nonatomic) BOOL sport_bike;
@property (nonatomic) BOOL sport_foot;
@property (nonatomic) BOOL sport_swim;
@property (nonatomic) BOOL sport_climbing;
@property (nonatomic) BOOL sport_badminton;
@property (nonatomic) BOOL sport_other;
@property (nonatomic) BOOL sport2_fitness;
@property (nonatomic) BOOL sport2_spinning;
@property (nonatomic) BOOL sport2_ellipsoid;
@property (nonatomic) BOOL sport2_treadmill;
@property (nonatomic) BOOL sport2_sitUp;
@property (nonatomic) BOOL sport_pushUp;
@property (nonatomic) BOOL sport2_dumbbell;
@property (nonatomic) BOOL sport2_weightLifting;
@property (nonatomic) BOOL sport3_bodybuildingExercise;
@property (nonatomic) BOOL sport3_yoga;
@property (nonatomic) BOOL sport3_ropeSkipping;
@property (nonatomic) BOOL sport3_pingpang;
@property (nonatomic) BOOL sport3_basketball;
@property (nonatomic) BOOL sport3_football;
@property (nonatomic) BOOL sport3_volleyball;
@property (nonatomic) BOOL sport3_tennis;
@property (nonatomic) BOOL sport4_golf;
@property (nonatomic) BOOL sport4_baseball;
@property (nonatomic) BOOL sport4_skiing;
@property (nonatomic) BOOL sport4_rollerSkating;
@property (nonatomic) BOOL sport4_dance;
@property (nonatomic) BOOL main2_logIn;
@end

@protocol GodManagerDelegate;

SWIFT_CLASS("_TtC8AngelFit10GodManager")
@interface GodManager : NSObject
@property (nonatomic, strong) id <GodManagerDelegate> _Nullable delegate;
@property (nonatomic) BOOL isAutoReconnect;
+ (GodManager * _Nonnull)share;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (void)startScanWithClosure:(void (^ _Nullable)(void))closure;
- (void)stopScan;
- (void)connect:(CBPeripheral * _Nonnull)peripheral;
- (void)disconnect:(CBPeripheral * _Nonnull)peripheral closure:(void (^ _Nonnull)(BOOL))closure;
@end

@class CBCharacteristic;
@class CBService;

@interface GodManager (SWIFT_EXTENSION(AngelFit)) <CBPeripheralDelegate>
- (void)peripheral:(CBPeripheral * _Nonnull)peripheral didDiscoverServices:(NSError * _Nullable)error;
- (void)peripheral:(CBPeripheral * _Nonnull)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic * _Nonnull)characteristic error:(NSError * _Nullable)error;
- (void)peripheral:(CBPeripheral * _Nonnull)peripheral didDiscoverCharacteristicsForService:(CBService * _Nonnull)service error:(NSError * _Nullable)error;
- (void)peripheral:(CBPeripheral * _Nonnull)peripheral didUpdateValueForCharacteristic:(CBCharacteristic * _Nonnull)characteristic error:(NSError * _Nullable)error;
@end

@class CBCentralManager;
@class NSNumber;

@interface GodManager (SWIFT_EXTENSION(AngelFit)) <CBCentralManagerDelegate>
- (void)centralManager:(CBCentralManager * _Nonnull)central didDiscoverPeripheral:(CBPeripheral * _Nonnull)peripheral advertisementData:(NSDictionary<NSString *, id> * _Nonnull)advertisementData RSSI:(NSNumber * _Nonnull)RSSI;
- (void)centralManagerDidUpdateState:(CBCentralManager * _Nonnull)central;
- (void)centralManager:(CBCentralManager * _Nonnull)central didDisconnectPeripheral:(CBPeripheral * _Nonnull)peripheral error:(NSError * _Nullable)error;
- (void)centralManager:(CBCentralManager * _Nonnull)central didConnectPeripheral:(CBPeripheral * _Nonnull)peripheral;
- (void)centralManager:(CBCentralManager * _Nonnull)central didFailToConnectPeripheral:(CBPeripheral * _Nonnull)peripheral error:(NSError * _Nullable)error;
- (void)centralManager:(CBCentralManager * _Nonnull)central willRestoreState:(NSDictionary<NSString *, id> * _Nonnull)dict;
@end

typedef SWIFT_ENUM(NSInteger, GodManagerConnectState) {
  GodManagerConnectStateConnect = 0,
  GodManagerConnectStateFailed = 1,
  GodManagerConnectStateDisConnect = 2,
};

enum GodManagerState : NSInteger;

SWIFT_PROTOCOL("_TtP8AngelFit18GodManagerDelegate_")
@protocol GodManagerDelegate
- (void)godManagerWithCurrentConnectPeripheral:(CBPeripheral * _Nonnull)peripheral peripheralName:(NSString * _Nonnull)name;
- (void)godManagerWithDidDiscoverPeripheral:(CBPeripheral * _Nonnull)peripheral withRSSI:(NSNumber * _Nonnull)RSSI peripheralName:(NSString * _Nonnull)name;
- (void)godManagerWithDidUpdateCentralState:(enum GodManagerState)state;
- (void)godManagerWithDidUpdateConnectState:(enum GodManagerConnectState)state withPeripheral:(CBPeripheral * _Nonnull)peripheral withError:(NSError * _Nullable)error;
- (void)godManagerWithDidConnectedPeripheral:(CBPeripheral * _Nonnull)peripheral connectState:(BOOL)isSuccess;
- (void)godManagerWithBindingPeripheralsUUID:(NSArray<NSString *> * _Nonnull)UUIDList;
@end

typedef SWIFT_ENUM(NSInteger, GodManagerState) {
  GodManagerStateUnknown = 0,
  GodManagerStateResetting = 1,
  GodManagerStateUnsupported = 2,
  GodManagerStateUnauthorized = 3,
  GodManagerStatePoweredOff = 4,
  GodManagerStatePoweredOn = 5,
};


SWIFT_CLASS("_TtC8AngelFit11HandGesture")
@interface HandGesture : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@interface HandGesture (SWIFT_EXTENSION(AngelFit))
@property (nonatomic) int16_t displayTime;
@property (nonatomic) BOOL isOpen;
@property (nonatomic) BOOL leftHand;
@end

typedef SWIFT_ENUM(NSInteger, HealthDataType) {
  HealthDataTypeSport = 0,
  HealthDataTypeSleep = 1,
  HealthDataTypeHeartRate = 2,
};


SWIFT_CLASS("_TtC8AngelFit13HeartInterval")
@interface HeartInterval : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@interface HeartInterval (SWIFT_EXTENSION(AngelFit))
@property (nonatomic) int16_t aerobic;
@property (nonatomic) int16_t burnFat;
@property (nonatomic) int16_t heartRateMode;
@property (nonatomic) int16_t limit;
@end


SWIFT_CLASS("_TtC8AngelFit13HeartRateData")
@interface HeartRateData : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end

@class HeartRateItem;

@interface HeartRateData (SWIFT_EXTENSION(AngelFit))
- (void)addHeartRateItemObject:(HeartRateItem * _Nonnull)value;
- (void)removeHeartRateItemObject:(HeartRateItem * _Nonnull)value;
- (void)addHeartRateItem:(NSSet * _Nonnull)values;
- (void)removeHeartRateItem:(NSSet * _Nonnull)values;
@end


@interface HeartRateData (SWIFT_EXTENSION(AngelFit))
@property (nonatomic) int16_t aerobicMinutes;
@property (nonatomic) int16_t aerobicThreshold;
@property (nonatomic) int16_t burnFatMinutes;
@property (nonatomic) int16_t burnFatThreshold;
@property (nonatomic, strong) NSDate * _Nullable date;
@property (nonatomic) int16_t id;
@property (nonatomic) int16_t itemCount;
@property (nonatomic) int16_t limitMinutes;
@property (nonatomic) int16_t limitThreshold;
@property (nonatomic) int16_t minuteOffset;
@property (nonatomic) int16_t silentHeartRate;
@property (nonatomic) int16_t packetsCount;
@property (nonatomic, strong) Device * _Nullable device;
@property (nonatomic, strong) NSSet * _Nullable heartRateItem;
@end


SWIFT_CLASS("_TtC8AngelFit13HeartRateItem")
@interface HeartRateItem : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@interface HeartRateItem (SWIFT_EXTENSION(AngelFit))
@property (nonatomic) int16_t data;
@property (nonatomic) int16_t id;
@property (nonatomic) int16_t offset;
@property (nonatomic, strong) HeartRateData * _Nullable heartRateData;
@end

typedef SWIFT_ENUM(NSInteger, HeartRateMode) {
  HeartRateModeManual = 0,
  HeartRateModeAuto = 1,
  HeartRateModeClose = 2,
};


SWIFT_CLASS("_TtC8AngelFit7LongSit")
@interface LongSit : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@interface LongSit (SWIFT_EXTENSION(AngelFit))
@property (nonatomic, strong) NSDate * _Nullable endDate;
@property (nonatomic) int16_t interval;
@property (nonatomic) BOOL isOpen;
@property (nonatomic, strong) NSDate * _Nullable startDate;
@property (nonatomic, strong) NSObject * _Nullable weekdayList;
@end


SWIFT_CLASS("_TtC8AngelFit8LostFind")
@interface LostFind : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@interface LostFind (SWIFT_EXTENSION(AngelFit))
@property (nonatomic) BOOL type;
@end


SWIFT_CLASS("_TtC8AngelFit6Notice")
@interface Notice : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@interface Notice (SWIFT_EXTENSION(AngelFit))
@property (nonatomic) int16_t callDelay;
@property (nonatomic) BOOL callSwitch;
@property (nonatomic) int16_t notifyItem0;
@property (nonatomic) BOOL notifySwitch;
@property (nonatomic) int16_t notifyItem1;
@property (nonatomic) BOOL musicSwitch;
@end


SWIFT_CLASS("_TtC8AngelFit17PeripheralManager")
@interface PeripheralManager : NSObject
+ (PeripheralManager * _Nonnull)share;
@property (nonatomic, copy) NSString * _Nullable UUID;
@property (nonatomic, readonly, strong) CBPeripheral * _Nullable currentPeripheral;
- (NSArray<NSString *> * _Nonnull)selectUUIDStringList;
- (BOOL)addWithNewUUIDString:(NSString * _Nonnull)uuidString;
- (BOOL)deleteWithUUIDString:(NSString * _Nonnull)uuidString;
- (BOOL)selectWithUUIDString:(NSString * _Nonnull)uuidString;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@protocol SatanManagerDelegate;

SWIFT_CLASS("_TtC8AngelFit12SatanManager")
@interface SatanManager : NSObject
@property (nonatomic, weak) id <SatanManagerDelegate> _Nullable delegate;
+ (SatanManager * _Nullable)share;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
- (void)addTrackWithCoordinate:(CLLocationCoordinate2D)coordinate withInterval:(NSTimeInterval)interval totalDistance:(double)distance childDistance:(double)subDistance;
- (void)resetTrack;
- (void)setSynchronizationActiveData:(NSString * _Nullable)macAddress closure:(void (^ _Nonnull)(BOOL, int16_t, BOOL))closure;
- (void)getSynchronizationActiveCount:(NSString * _Nullable)macAddress closure:(void (^ _Nonnull)(uint8_t))closure;
@end

enum SatanManagerState : NSInteger;

SWIFT_PROTOCOL("_TtP8AngelFit20SatanManagerDelegate_")
@protocol SatanManagerDelegate
- (void)satanManagerWithDidUpdateState:(enum SatanManagerState)state;
- (uint32_t)satanManagerDistanceByLocationWithBleDistance:(uint32_t)distance;
- (NSInteger)satanManagerDuration;
- (void)satanManagerWithDidSwitchingReplyCalories:(uint32_t)calories distance:(uint32_t)distance step:(uint32_t)step curHeartrate:(uint8_t)curHeartrate heartrateSerial:(uint8_t)heartrateSerial available:(BOOL)available heartrateValue:(NSArray<NSNumber *> * _Nonnull)heartrateValue;
@end

typedef SWIFT_ENUM(NSInteger, SatanManagerState) {
  SatanManagerStateStart = 0,
  SatanManagerStatePause = 1,
  SatanManagerStateRestore = 2,
  SatanManagerStateEnd = 3,
};


SWIFT_CLASS("_TtC8AngelFit14SilentDistrube")
@interface SilentDistrube : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@interface SilentDistrube (SWIFT_EXTENSION(AngelFit))
@property (nonatomic) int16_t endHour;
@property (nonatomic) int16_t endMinute;
@property (nonatomic) BOOL isOpen;
@property (nonatomic) int16_t startHour;
@property (nonatomic) int16_t startMinute;
@end


SWIFT_CLASS("_TtC8AngelFit9SleepData")
@interface SleepData : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end

@class SleepItem;

@interface SleepData (SWIFT_EXTENSION(AngelFit))
- (void)addSleepItemObject:(SleepItem * _Nonnull)value;
- (void)removeSleepItemObject:(SleepItem * _Nonnull)value;
- (void)addSleepItem:(NSSet * _Nonnull)values;
- (void)removeSleepItem:(NSSet * _Nonnull)values;
@end


@interface SleepData (SWIFT_EXTENSION(AngelFit))
@property (nonatomic, strong) NSDate * _Nullable date;
@property (nonatomic) int16_t deepSleepCount;
@property (nonatomic) int16_t id;
@property (nonatomic) int16_t sleepItemCount;
@property (nonatomic) int16_t lightSleepCount;
@property (nonatomic) int16_t totalMinute;
@property (nonatomic) int16_t wakeCount;
@property (nonatomic) int16_t endTimeHour;
@property (nonatomic) int16_t endTimeMinute;
@property (nonatomic) int16_t startTimeHour;
@property (nonatomic) int16_t startTimeMinute;
@property (nonatomic) int16_t serial;
@property (nonatomic) int16_t packetCount;
@property (nonatomic) int16_t lightSleepMinute;
@property (nonatomic) int16_t deepSleepMinute;
@property (nonatomic) int16_t itemsCount;
@property (nonatomic, strong) Device * _Nullable device;
@property (nonatomic, strong) NSSet * _Nullable sleepItem;
@end


SWIFT_CLASS("_TtC8AngelFit9SleepItem")
@interface SleepItem : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@interface SleepItem (SWIFT_EXTENSION(AngelFit))
@property (nonatomic) int16_t durations;
@property (nonatomic) int16_t id;
@property (nonatomic) int16_t sleepStatus;
@property (nonatomic, strong) SleepData * _Nullable sleepData;
@end


SWIFT_CLASS("_TtC8AngelFit9SportData")
@interface SportData : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end

@class SportItem;

@interface SportData (SWIFT_EXTENSION(AngelFit))
- (void)addSportItemObject:(SportItem * _Nonnull)value;
- (void)removeSportItemObject:(SportItem * _Nonnull)value;
- (void)addSportItem:(NSSet * _Nonnull)values;
- (void)removeSportItem:(NSSet * _Nonnull)values;
@end


@interface SportData (SWIFT_EXTENSION(AngelFit))
@property (nonatomic, strong) NSDate * _Nullable date;
@property (nonatomic) int16_t id;
@property (nonatomic) int16_t itemCount;
@property (nonatomic) int16_t minuteDuration;
@property (nonatomic) int16_t minuteOffset;
@property (nonatomic) int16_t totalActiveTime;
@property (nonatomic) int16_t totalCal;
@property (nonatomic) int16_t totalDistance;
@property (nonatomic) int16_t perMinute;
@property (nonatomic) int16_t packetCount;
@property (nonatomic) int16_t reserved;
@property (nonatomic) int16_t totalStep;
@property (nonatomic, strong) Device * _Nullable device;
@property (nonatomic, strong) NSSet * _Nullable sportItem;
@end


SWIFT_CLASS("_TtC8AngelFit9SportItem")
@interface SportItem : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@interface SportItem (SWIFT_EXTENSION(AngelFit))
@property (nonatomic) int16_t activeTime;
@property (nonatomic) int16_t calories;
@property (nonatomic) int16_t distance;
@property (nonatomic) int16_t id;
@property (nonatomic) int16_t mode;
@property (nonatomic) int16_t sportCount;
@property (nonatomic, strong) SportData * _Nullable sportData;
@end


SWIFT_CLASS("_TtC8AngelFit5Track")
@interface Track : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end

@class TrackItem;

@interface Track (SWIFT_EXTENSION(AngelFit))
- (void)addTrackItemsObject:(TrackItem * _Nonnull)value;
- (void)removeTrackItemsObject:(TrackItem * _Nonnull)value;
- (void)addTrackItems:(NSSet * _Nonnull)values;
- (void)removeTrackItems:(NSSet * _Nonnull)values;
@end

@class TrackHeartrateItem;

@interface Track (SWIFT_EXTENSION(AngelFit))
- (void)addTrackHeartrateItemsObject:(TrackHeartrateItem * _Nonnull)value;
- (void)removeTrackHeartrateItemsObject:(TrackHeartrateItem * _Nonnull)value;
- (void)addTrackHeartrateItems:(NSSet * _Nonnull)values;
- (void)removeTrackHeartrateItems:(NSSet * _Nonnull)values;
@end


@interface Track (SWIFT_EXTENSION(AngelFit))
@property (nonatomic) int16_t aerobicMinutes;
@property (nonatomic) int16_t avgrageHeartrate;
@property (nonatomic) int16_t burnFatMinutes;
@property (nonatomic) int16_t calories;
@property (nonatomic, strong) NSDate * _Nullable date;
@property (nonatomic) double distance;
@property (nonatomic) int16_t durations;
@property (nonatomic) int16_t limitMinutes;
@property (nonatomic) int16_t maxHeartrate;
@property (nonatomic) int16_t serial;
@property (nonatomic) int16_t step;
@property (nonatomic) int16_t type;
@property (nonatomic, strong) Device * _Nullable device;
@property (nonatomic, strong) NSSet * _Nullable trackItems;
@property (nonatomic, strong) NSSet * _Nullable trackHeartrateItems;
@end


SWIFT_CLASS("_TtC8AngelFit18TrackHeartrateItem")
@interface TrackHeartrateItem : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@interface TrackHeartrateItem (SWIFT_EXTENSION(AngelFit))
@property (nonatomic) int16_t data;
@property (nonatomic) int16_t offset;
@property (nonatomic) int16_t id;
@property (nonatomic, strong) Track * _Nullable track;
@end


SWIFT_CLASS("_TtC8AngelFit9TrackItem")
@interface TrackItem : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@interface TrackItem (SWIFT_EXTENSION(AngelFit))
@property (nonatomic, strong) NSDate * _Nullable date;
@property (nonatomic) double interval;
@property (nonatomic) double subDistance;
@property (nonatomic) double longtitude;
@property (nonatomic) double latitude;
@property (nonatomic, strong) Track * _Nullable track;
@end


@interface UIViewController (SWIFT_EXTENSION(AngelFit)) <CBPeripheralDelegate>
@end


SWIFT_CLASS("_TtC8AngelFit4Unit")
@interface Unit : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@interface Unit (SWIFT_EXTENSION(AngelFit))
@property (nonatomic) int16_t distance;
@property (nonatomic) int16_t language;
@property (nonatomic) int16_t stride;
@property (nonatomic) int16_t temperature;
@property (nonatomic) int16_t timeFormat;
@property (nonatomic) int16_t weight;
@end

typedef SWIFT_ENUM(NSInteger, UnitType) {
  UnitTypeDistance_KM = 0,
  UnitTypeDistance_MI = 1,
  UnitTypeWeight_KG = 2,
  UnitTypeWeight_LB = 3,
  UnitTypeTemp_C = 4,
  UnitTypeTemp_F = 5,
  UnitTypeLangure_ZH = 6,
  UnitTypeLangure_EN = 7,
  UnitTypeTimeFormat_24 = 8,
  UnitTypeTimeFormat_12 = 9,
};


SWIFT_CLASS("_TtC8AngelFit4User")
@interface User : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end

@class Weight;

@interface User (SWIFT_EXTENSION(AngelFit))
- (void)addWeightsObject:(Weight * _Nonnull)value;
- (void)removeWeightsObject:(Weight * _Nonnull)value;
- (void)addWeights:(NSSet * _Nonnull)values;
- (void)removeWeights:(NSSet * _Nonnull)values;
@end


@interface User (SWIFT_EXTENSION(AngelFit))
- (void)addDevicesObject:(Device * _Nonnull)value;
- (void)removeDevicesObject:(Device * _Nonnull)value;
- (void)addDevices:(NSSet * _Nonnull)values;
- (void)removeDevices:(NSSet * _Nonnull)values;
@end


@interface User (SWIFT_EXTENSION(AngelFit))
@property (nonatomic, strong) NSDate * _Nullable birthday;
@property (nonatomic) int16_t gender;
@property (nonatomic) int16_t goalCal;
@property (nonatomic) int16_t goalDistance;
@property (nonatomic) int16_t goalStep;
@property (nonatomic) int16_t height;
@property (nonatomic) int16_t userId;
@property (nonatomic) float goalWeight;
@property (nonatomic) int16_t sleepHour;
@property (nonatomic) int16_t sleepMinute;
@property (nonatomic) int16_t wakeHour;
@property (nonatomic) int16_t wakeMinute;
@property (nonatomic) float currentWeight;
@property (nonatomic, strong) NSSet * _Nullable devices;
@property (nonatomic, strong) NSSet * _Nullable weights;
@end


SWIFT_CLASS("_TtC8AngelFit6Weight")
@interface Weight : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@interface Weight (SWIFT_EXTENSION(AngelFit))
@property (nonatomic, strong) NSDate * _Nullable date;
@property (nonatomic) float value;
@property (nonatomic, strong) User * _Nullable user;
@end

#pragma clang diagnostic pop
