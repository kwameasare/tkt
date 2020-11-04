import 'package:flutter/material.dart';

class Category {

  final String name;
  final String organiser;
  final String banner;
  final String location;
  final String description;
  final String pricing;
  final List sessions;
  final String lat;
  final String lng;
  final String venue;
  final List ticket_types;
  String event_id;
  // final String start_date;
  // final String start_time;

  Category(
    {
      @required this.name,
      @required this.organiser,
       @required this.banner,
        @required this.location,
       @required this.description,
        @required this.pricing,
        @required this.sessions,
         @required this.lat,
        @required this.lng,
        @required this.venue,
         @required this.ticket_types,
         @required this.event_id,
    }
  );
}