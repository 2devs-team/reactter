// To parse this JSON data, do
//
//     final user = userFromJson(jsonString?);

// ignore_for_file: prefer_null_aware_operators, constant_identifier_names

import 'dart:convert';

Users userFromJson(String? str) => Users.fromJson(json.decode(str ?? ""));

String? userToJson(Users data) => json.encode(data.toJson());

class Users {
  Users({
    this.users,
    this.total,
    this.skip,
    this.limit,
  });

  List<User>? users;
  int? total;
  int? skip;
  int? limit;

  factory Users.fromJson(Map<String?, dynamic> json) => Users(
        users: json["users"] == null
            ? null
            : List<User>.from(json["users"].map((x) => User.fromJson(x))),
        total: json["total"],
        skip: json["skip"],
        limit: json["limit"],
      );

  Map<String?, dynamic> toJson() => {
        "users": users == null
            ? null
            : List<dynamic>.from((users ?? []).map((x) => x.toJson())),
        "total": total,
        "skip": skip,
        "limit": limit,
      };
}

class User {
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.maidenName,
    this.age,
    this.gender,
    this.email,
    this.phone,
    this.username,
    this.password,
    this.birthDate,
    this.image,
    this.bloodGroup,
    this.height,
    this.weight,
    this.eyeColor,
    this.hair,
    this.domain,
    this.ip,
    this.address,
    this.macAddress,
    this.university,
    this.bank,
    this.company,
    this.ein,
    this.ssn,
    this.userAgent,
  });

  int? id;
  String? firstName;
  String? lastName;
  String? maidenName;
  int? age;
  Gender? gender;
  String? email;
  String? phone;
  String? username;
  String? password;
  DateTime? birthDate;
  String? image;
  String? bloodGroup;
  int? height;
  double? weight;
  EyeColor? eyeColor;
  Hair? hair;
  String? domain;
  String? ip;
  Address? address;
  String? macAddress;
  String? university;
  Bank? bank;
  Company? company;
  String? ein;
  String? ssn;
  String? userAgent;

  factory User.fromJson(Map<String?, dynamic> json) => User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        maidenName: json["maidenName"],
        age: json["age"],
        gender:
            json["gender"] == null ? null : genderValues.map[json["gender"]],
        email: json["email"],
        phone: json["phone"],
        username: json["username"],
        password: json["password"],
        birthDate: json["birthDate"] == null
            ? null
            : DateTime.parse(json["birthDate"]),
        image: json["image"],
        bloodGroup: json["bloodGroup"],
        height: json["height"],
        weight: json["weight"] == null ? null : json["weight"].toDouble(),
        eyeColor: json["eyeColor"] == null
            ? null
            : eyeColorValues.map[json["eyeColor"]],
        hair: json["hair"] == null ? null : Hair.fromJson(json["hair"]),
        domain: json["domain"],
        ip: json["ip"],
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
        macAddress: json["macAddress"],
        university: json["university"],
        bank: json["bank"] == null ? null : Bank.fromJson(json["bank"]),
        company:
            json["company"] == null ? null : Company.fromJson(json["company"]),
        ein: json["ein"],
        ssn: json["ssn"],
        userAgent: json["userAgent"],
      );

  Map<String?, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "maidenName": maidenName,
        "age": age,
        "gender": gender == null ? null : genderValues.reverse[gender],
        "email": email,
        "phone": phone,
        "username": username,
        "password": password,
        "birthDate": birthDate == null
            ? null
            : "${birthDate?.year.toString().padLeft(4, '0')}-${birthDate?.month.toString().padLeft(2, '0')}-${birthDate?.day.toString().padLeft(2, '0')}",
        "image": image,
        "bloodGroup": bloodGroup,
        "height": height,
        "weight": weight,
        "eyeColor": eyeColor == null ? null : eyeColorValues.reverse[eyeColor],
        "hair": hair == null ? null : hair?.toJson(),
        "domain": domain,
        "ip": ip,
        "address": address == null ? null : address?.toJson(),
        "macAddress": macAddress,
        "university": university,
        "bank": bank == null ? null : bank?.toJson(),
        "company": company == null ? null : company?.toJson(),
        "ein": ein,
        "ssn": ssn,
        "userAgent": userAgent,
      };
}

class Address {
  Address({
    this.address,
    this.city,
    this.coordinates,
    this.postalCode,
    this.state,
  });

  String? address;
  String? city;
  Coordinates? coordinates;
  String? postalCode;
  String? state;

  factory Address.fromJson(Map<String?, dynamic> json) => Address(
        address: json["address"],
        city: json["city"],
        coordinates: json["coordinates"] == null
            ? null
            : Coordinates.fromJson(json["coordinates"]),
        postalCode: json["postalCode"],
        state: json["state"],
      );

  Map<String?, dynamic> toJson() => {
        "address": address,
        "city": city,
        "coordinates": coordinates == null ? null : coordinates?.toJson(),
        "postalCode": postalCode,
        "state": state,
      };
}

class Coordinates {
  Coordinates({
    this.lat,
    this.lng,
  });

  double? lat;
  double? lng;

  factory Coordinates.fromJson(Map<String?, dynamic> json) => Coordinates(
        lat: json["lat"] == null ? null : json["lat"].toDouble(),
        lng: json["lng"] == null ? null : json["lng"].toDouble(),
      );

  Map<String?, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

class Bank {
  Bank({
    this.cardExpire,
    this.cardNumber,
    this.cardType,
    this.currency,
    this.iban,
  });

  String? cardExpire;
  String? cardNumber;
  String? cardType;
  String? currency;
  String? iban;

  factory Bank.fromJson(Map<String?, dynamic> json) => Bank(
        cardExpire: json["cardExpire"],
        cardNumber: json["cardNumber"],
        cardType: json["cardType"],
        currency: json["currency"],
        iban: json["iban"],
      );

  Map<String?, dynamic> toJson() => {
        "cardExpire": cardExpire,
        "cardNumber": cardNumber,
        "cardType": cardType,
        "currency": currency,
        "iban": iban,
      };
}

class Company {
  Company({
    this.address,
    this.department,
    this.name,
    this.title,
  });

  Address? address;
  String? department;
  String? name;
  String? title;

  factory Company.fromJson(Map<String?, dynamic> json) => Company(
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
        department: json["department"],
        name: json["name"],
        title: json["title"],
      );

  Map<String?, dynamic> toJson() => {
        "address": address == null ? null : address?.toJson(),
        "department": department,
        "name": name,
        "title": title,
      };
}

enum EyeColor { GREEN, BROWN, GRAY, AMBER, BLUE }

final eyeColorValues = EnumValues({
  "Amber": EyeColor.AMBER,
  "Blue": EyeColor.BLUE,
  "Brown": EyeColor.BROWN,
  "Gray": EyeColor.GRAY,
  "Green": EyeColor.GREEN
});

enum Gender { MALE, FEMALE }

final genderValues = EnumValues({"female": Gender.FEMALE, "male": Gender.MALE});

class Hair {
  Hair({
    this.color,
    this.type,
  });

  Color? color;
  Type? type;

  factory Hair.fromJson(Map<String?, dynamic> json) => Hair(
        color: json["color"] == null ? null : colorValues.map[json["color"]],
        type: json["type"] == null ? null : typeValues.map[json["type"]],
      );

  Map<String?, dynamic> toJson() => {
        "color": color == null ? null : colorValues.reverse[color],
        "type": type == null ? null : typeValues.reverse[type],
      };
}

enum Color { BLACK, BLOND, BROWN, CHESTNUT, AUBURN }

final colorValues = EnumValues({
  "Auburn": Color.AUBURN,
  "Black": Color.BLACK,
  "Blond": Color.BLOND,
  "Brown": Color.BROWN,
  "Chestnut": Color.CHESTNUT
});

enum Type { STRANDS, CURLY, VERY_CURLY, STRAIGHT, WAVY }

final typeValues = EnumValues({
  "Curly": Type.CURLY,
  "Straight": Type.STRAIGHT,
  "Strands": Type.STRANDS,
  "Very curly": Type.VERY_CURLY,
  "Wavy": Type.WAVY
});

class EnumValues<T> {
  Map<String?, T> map;
  late Map<T, String?> reverseMap;

  EnumValues(this.map);

  Map<T, String?> get reverse {
    reverseMap;
    return reverseMap;
  }
}
