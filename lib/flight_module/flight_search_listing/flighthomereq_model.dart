/*
Auther Name: Animesh Banerjee
Discription : This is the request holder for search Page
*/

import 'dart:convert';

import 'package:gems_revamp/flight_module/passenger_class.dart';

class FlightRequestHolder {
  CabinClassModel? cabinClassModel;
  PassengerModel? passengerModel;
  int? tripTypevalue;

  String? originCity,
      destinationCity,
      originCode,
      destinationCode,
      boundType,
      airportOriginCode,
      airportDestinationCode,
      formattedDepartureDate,
      formattedReturnDate;
  String departureDate, returnDate;
  var signlejourneyDetails;
  var domesticSingleReturnJourneyDetails;
  var domesticReturnReturnJourneyDetails;
  SingingCharacter? character;

  FlightRequestHolder(
    this.tripTypevalue,
    this.originCity,
    this.destinationCity,
    this.originCode,
    this.destinationCode,
    this.departureDate,
    this.returnDate,
    this.cabinClassModel,
    this.boundType,
  );
}

String flightsRecentSearchToJson(FlightsRecentSearch data) =>
    json.encode(data.toJson());

class FlightsRecentSearch {
  int? id;
  String? fromAirportCode;
  String? fromCityName;
  String? toAirportCode;
  String? toCityName;
  String? departDate;
  String? returnDate;
  String? passengersAdults;
  String? passengersChild;
  String? passengersInfants;
  String? cabinClassName;
  String? cabinClassValue;
  String? trip;
  String? timeStamp;
  String? airportnametocity;
  String? airportnamefromcity;

  FlightsRecentSearch(
      {this.id,
      this.fromAirportCode,
      this.fromCityName,
      this.toAirportCode,
      this.toCityName,
      this.departDate,
      this.returnDate,
      this.passengersAdults,
      this.passengersChild,
      this.passengersInfants,
      this.cabinClassName,
      this.cabinClassValue,
      this.trip,
      this.timeStamp,
      this.airportnametocity,
      this.airportnamefromcity});

  factory FlightsRecentSearch.fromJson(Map<String, dynamic> json) =>
      FlightsRecentSearch(
          id: json["id"] == null ? null : json["id"],
          fromAirportCode: json["FROM_AIRPORT_CODE"] == null
              ? null
              : json["FROM_AIRPORT_CODE"],
          fromCityName:
              json["FROM_CITY_NAME"] == null ? null : json["FROM_CITY_NAME"],
          toAirportCode:
              json["TO_AIRPORT_CODE"] == null ? null : json["TO_AIRPORT_CODE"],
          toCityName:
              json["TO_CITY_NAME"] == null ? null : json["TO_CITY_NAME"],
          departDate: json["DEPART_DATE"] == null ? null : json["DEPART_DATE"],
          returnDate: json["RETURN_DATE"] == null ? null : json["RETURN_DATE"],
          passengersAdults: json["PASSENGERS_ADULTS"] == null
              ? null
              : json["PASSENGERS_ADULTS"],
          passengersChild: json["PASSENGERS_CHILD"] == null
              ? null
              : json["PASSENGERS_CHILD"],
          passengersInfants: json["PASSENGERS_INFANTS"] == null
              ? null
              : json["PASSENGERS_INFANTS"],
          cabinClassName:
              json["CABIN_CLASS"] == null ? null : json["CABIN_CLASS"],
          cabinClassValue:
              json["CABIN_VALUE"] == null ? null : json["CABIN_VALUE"],
          trip: json["TRIP"] == null ? null : json["TRIP"],
          timeStamp: json["TIMESTAMP"] == null ? null : json["TIMESTAMP"],
          airportnametocity: json["AIRPORTNAMETOCITY"] == null
              ? null
              : json["AIRPORTNAMETOCITY"],
          airportnamefromcity: json["AIRPORTNAMEFROMCITY"] == null
              ? null
              : json["AIRPORTNAMEFROMCITY"]);
  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "FROM_AIRPORT_CODE": fromAirportCode == null ? null : fromAirportCode,
        "FROM_CITY_NAME": fromCityName == null ? null : fromCityName,
        "TO_AIRPORT_CODE": toAirportCode == null ? null : toAirportCode,
        "TO_CITY_NAME": toCityName == null ? null : toCityName,
        "DEPART_DATE": departDate == null ? null : departDate,
        "RETURN_DATE": returnDate == null ? null : returnDate,
        "PASSENGERS_ADULTS": passengersAdults == null ? null : passengersAdults,
        "PASSENGERS_CHILD": passengersChild == null ? null : passengersChild,
        "PASSENGERS_INFANTS":
            passengersInfants == null ? null : passengersInfants,
        "CABIN_CLASS": cabinClassName == null ? null : cabinClassName,
        "CABIN_VALUE": cabinClassValue == null ? null : cabinClassValue,
        "TRIP": trip == null ? null : trip,
        "TIMESTAMP": timeStamp == null ? null : timeStamp,
        "AIRPORTNAMETOCITY":
            airportnametocity == null ? null : airportnametocity,
        "AIRPORTNAMEFROMCITY":
            airportnamefromcity == null ? null : airportnamefromcity
      };
}

enum SingingCharacter { business, leisure, personal }
