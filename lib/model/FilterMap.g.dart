// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FilterMap.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterMap _$FilterMapFromJson(Map<String, dynamic> json) => FilterMap(
      type: json['type'] as String?,
      main_park_id: json['main_park_id'] as String?,
      status: json['status'] as String?,
      frm_keyword: json['frm_keyword'] as String?,
      popupDatepickerFromDateSearch:
          json['popupDatepickerFromDateSearch'] as String?,
      popupDatepickerToDateSearch:
          json['popupDatepickerToDateSearch'] as String?,
      assignedTo: json['assignedTo'] as String?,
      functionType: json['functionType'] as String?,
    );

Map<String, dynamic> _$FilterMapToJson(FilterMap instance) => <String, dynamic>{
      'type': instance.type,
      'main_park_id': instance.main_park_id,
      'status': instance.status,
      'frm_keyword': instance.frm_keyword,
      'popupDatepickerFromDateSearch': instance.popupDatepickerFromDateSearch,
      'popupDatepickerToDateSearch': instance.popupDatepickerToDateSearch,
      'functionType': instance.functionType,
      'assignedTo': instance.assignedTo,
    };
