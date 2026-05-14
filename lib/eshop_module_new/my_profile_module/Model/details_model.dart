// To parse this JSON data, do
//
//     final detailsModel = detailsModelFromJson(jsonString);

import 'dart:convert';

List<DetailsModel> detailsModelFromJson(String str) => List<DetailsModel>.from(json.decode(str).map((x) => DetailsModel.fromJson(x)));

String detailsModelToJson(List<DetailsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DetailsModel {
  DetailsModel({
    this.success,
    this.message,
    this.headerPromotion,
    this.header,
    this.footer,
  });

  String? success;
  String? message;
  HeaderPromotion? headerPromotion;
  Header? header;
  Footer? footer;

  factory DetailsModel.fromJson(Map<String, dynamic> json) => DetailsModel(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    headerPromotion: json["header_promotion"] == null ? null : HeaderPromotion.fromJson(json["header_promotion"]),
    header: json["header"] == null ? null : Header.fromJson(json["header"]),
    footer: json["footer"] == null ? null : Footer.fromJson(json["footer"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "header_promotion": headerPromotion == null ? null : headerPromotion!.toJson(),
    "header": header == null ? null : header?.toJson(),
    "footer": footer == null ? null : footer?.toJson(),
  };
}

class Footer {
  Footer({
    this.aboutUs,
    this.customerServices,
    this.contactUs,
  });

  List<AboutUs>? aboutUs;
  List<ContactUs>? customerServices;
  List<ContactUs>? contactUs;

  factory Footer.fromJson(Map<String, dynamic> json) => Footer(
    aboutUs: json["about_us"] == null ? null : List<AboutUs>.from(json["about_us"].map((x) => AboutUs.fromJson(x))),
    customerServices: json["customer_services"] == null ? null : List<ContactUs>.from(json["customer_services"].map((x) => ContactUs.fromJson(x))),
    contactUs: json["contact_us"] == null ? null : List<ContactUs>.from(json["contact_us"].map((x) => ContactUs.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "about_us": aboutUs == null ? null : List<dynamic>.from(aboutUs!.map((x) => x.toJson())),
    "customer_services": customerServices == null ? null : List<dynamic>.from(customerServices!.map((x) => x.toJson())),
    "contact_us": contactUs == null ? null : List<dynamic>.from(contactUs!.map((x) => x.toJson())),
  };
}

class AboutUs {
  AboutUs({
    this.title,
    this.link,
    this.urlKey,
    this.cmsPage,
  });

  String? title;
  String? link;
  String? urlKey;
  int? cmsPage;

  factory AboutUs.fromJson(Map<String, dynamic> json) => AboutUs(
    title: json["title"] == null ? null : json["title"],
    link: json["link"] == null ? null : json["link"],
    urlKey: json["url_key"] == null ? null : json["url_key"],
    cmsPage: json["cms_page"] == null ? null : json["cms_page"],
  );

  Map<String, dynamic> toJson() => {
    "title": title == null ? null : title,
    "link": link == null ? null : link,
    "url_key": urlKey == null ? null : urlKey,
    "cms_page": cmsPage == null ? null : cmsPage,
  };
}

class ContactUs {
  ContactUs({
    this.title,
    this.link,
    this.urlKey,
    this.cmsPage,
  });

  String? title;
  String? link;
  String? urlKey;
  int? cmsPage;

  factory ContactUs.fromJson(Map<String, dynamic> json) => ContactUs(
    title: json["title"] == null ? null : json["title"],
    link: json["link"] == null ? null : json["link"],
    urlKey: json["url_key"] == null ? null : json["url_key"],
    cmsPage: json["cms_page"] == null ? null : json["cms_page"],
  );

  Map<String, dynamic> toJson() => {
    "title": title == null ? null : title,
    "link": link == null ? null : link,
    "url_key": urlKey == null ? null : urlKey,
    "cms_page": cmsPage == null ? null : cmsPage,
  };
}

class Header {
  Header({
    this.cartCount,
    this.wishlistCount,
    this.user,
    this.websites,
  });

  int? cartCount;
  int? wishlistCount;
  User? user;
  List<Website>? websites;

  factory Header.fromJson(Map<String, dynamic> json) => Header(
    cartCount: json["cart_count"] == null ? null : json["cart_count"],
    wishlistCount: json["wishlist_count"] == null ? null : json["wishlist_count"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    websites: json["websites"] == null ? null : List<Website>.from(json["websites"].map((x) => Website.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cart_count": cartCount == null ? null : cartCount,
    "wishlist_count": wishlistCount == null ? null : wishlistCount,
    "user": user == null ? null : user!.toJson(),
    "websites": websites == null ? null : List<dynamic>.from(websites!.map((x) => x.toJson())),
  };
}

class User {
  User({
    this.email,
    this.lastName,
    this.firstName,
    this.fullName,
  });

  String? email;
  String? lastName;
  String? firstName;
  String? fullName;

  factory User.fromJson(Map<String, dynamic> json) => User(
    email: json["email"] == null ? null : json["email"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    fullName: json["fullName"] == null ? null : json["fullName"],
  );

  Map<String, dynamic> toJson() => {
    "email": email == null ? null : email,
    "lastName": lastName == null ? null : lastName,
    "firstName": firstName == null ? null : firstName,
    "fullName": fullName == null ? null : fullName,
  };
}

class Website {
  Website({
    this.id,
    this.name,
    this.selected,
    this.stores,
  });

  String? id;
  String? name;
  String? selected;
  List<Store>? stores;

  factory Website.fromJson(Map<String, dynamic> json) => Website(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    selected: json["selected"] == null ? null : json["selected"],
    stores: json["stores"] == null ? null : List<Store>.from(json["stores"].map((x) => Store.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "selected": selected == null ? null : selected,
    "stores": stores == null ? null : List<dynamic>.from(stores!.map((x) => x.toJson())),
  };
}

class Store {
  Store({
    this.storeId,
    this.code,
    this.websiteId,
    this.groupId,
    this.name,
    this.sortOrder,
    this.isActive,
    this.selected,
    this.storeUrl,
  });

  String? storeId;
  String? code;
  String? websiteId;
  String? groupId;
  String? name;
  String? sortOrder;
  String? isActive;
  String? selected;
  String? storeUrl;

  factory Store.fromJson(Map<String, dynamic> json) => Store(
    storeId: json["store_id"] == null ? null : json["store_id"],
    code: json["code"] == null ? null : json["code"],
    websiteId: json["website_id"] == null ? null : json["website_id"],
    groupId: json["group_id"] == null ? null : json["group_id"],
    name: json["name"] == null ? null : json["name"],
    sortOrder: json["sort_order"] == null ? null : json["sort_order"],
    isActive: json["is_active"] == null ? null : json["is_active"],
    selected: json["selected"] == null ? null : json["selected"],
    storeUrl: json["store_url"] == null ? null : json["store_url"],
  );

  Map<String, dynamic> toJson() => {
    "store_id": storeId == null ? null : storeId,
    "code": code == null ? null : code,
    "website_id": websiteId == null ? null : websiteId,
    "group_id": groupId == null ? null : groupId,
    "name": name == null ? null : name,
    "sort_order": sortOrder == null ? null : sortOrder,
    "is_active": isActive == null ? null : isActive,
    "selected": selected == null ? null : selected,
    "store_url": storeUrl == null ? null : storeUrl,
  };
}

class HeaderPromotion {
  HeaderPromotion({
    this.enabled,
    this.headerText,
    this.headerTextBttom,
    this.banners,
  });

  String? enabled;
  String? headerText;
  String? headerTextBttom;
  List<Banner>? banners;

  factory HeaderPromotion.fromJson(Map<String, dynamic> json) => HeaderPromotion(
    enabled: json["enabled"] == null ? null : json["enabled"],
    headerText: json["header_text"] == null ? null : json["header_text"],
    headerTextBttom: json["header_text_bttom"] == null ? null : json["header_text_bttom"],
    banners: json["banners"] == null ? null : List<Banner>.from(json["banners"].map((x) => Banner.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "enabled": enabled == null ? null : enabled,
    "header_text": headerText == null ? null : headerText,
    "header_text_bttom": headerTextBttom == null ? null : headerTextBttom,
    "banners": banners == null ? null : List<dynamic>.from(banners!.map((x) => x.toJson())),
  };
}

class Banner {
  Banner({
    this.id,
    this.title,
    this.image,
    this.link,
    this.content,
  });

  String? id;
  String? title;
  String? image;
  String? link;
  dynamic content;

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    image: json["image"] == null ? null : json["image"],
    link: json["link"] == null ? null : json["link"],
    content: json["content"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "image": image == null ? null : image,
    "link": link == null ? null : link,
    "content": content,
  };
}
