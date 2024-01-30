// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FeedbackStatusDetails.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedbackStatusDetails _$FeedbackStatusDetailsFromJson(
        Map<String, dynamic> json) =>
    FeedbackStatusDetails(
      park_id: json['park_id'] as String?,
      park_name: json['park_name'] as String?,
      user_name: json['user_name'] as String?,
      email_address: json['email_address'] as String?,
      anonymous_user: json['anonymous_user'] as String?,
      send_updates: json['send_updates'] as String?,
      lat: json['lat'] as String?,
      longi: json['longi'] as String?,
      user_location: json['user_location'] as String?,
      rating: json['rating'] as String?,
      recommend: json['recommend'] as String?,
      descrpt: json['descrpt'] as String?,
      how_safe_feel: json['how_safe_feel'] as String?,
      zip_code_live: json['zip_code_live'] as String?,
      comment: (json['comment'] as List<dynamic>?)
          ?.map((e) => CommentsData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FeedbackStatusDetailsToJson(
        FeedbackStatusDetails instance) =>
    <String, dynamic>{
      'park_id': instance.park_id,
      'park_name': instance.park_name,
      'user_name': instance.user_name,
      'email_address': instance.email_address,
      'anonymous_user': instance.anonymous_user,
      'send_updates': instance.send_updates,
      'lat': instance.lat,
      'longi': instance.longi,
      'user_location': instance.user_location,
      'rating': instance.rating,
      'recommend': instance.recommend,
      'descrpt': instance.descrpt,
      'how_safe_feel': instance.how_safe_feel,
      'zip_code_live': instance.zip_code_live,
      'comment': instance.comment,
    };
