import 'dart:convert';

List<DialogContent> dialogContentFromJson(String str) => List<DialogContent>.from(json.decode(str).map((x) => DialogContent.fromJson(x)));

String dialogContentToJson(List<DialogContent> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DialogContent {
  DialogContent({
    this.success,
    this.cookieLifetime,
    this.popTitle,
    this.contentMsg,
    this.showTermCondition,
    this.termConditionText,
    this.submitbuttontxt,
  });

  final String? success;
  final String? cookieLifetime;
  final String? popTitle;
  final String? contentMsg;
  final String? showTermCondition;
  final String? termConditionText;
  final String? submitbuttontxt;

  factory DialogContent.fromJson(Map<String, dynamic> json) => DialogContent(
    success: json["success"] == null ? null : json["success"],
    cookieLifetime: json["cookie_lifetime"] == null ? null : json["cookie_lifetime"],
    popTitle: json["pop_title"] == null ? null : json["pop_title"],
    contentMsg: json["content_msg"] == null ? null : json["content_msg"],
    showTermCondition: json["show_term_condition"] == null ? null : json["show_term_condition"],
    termConditionText: json["term_condition_text"] == null ? null : json["term_condition_text"],
    submitbuttontxt: json["submitbuttontxt"] == null ? null : json["submitbuttontxt"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "cookie_lifetime": cookieLifetime == null ? null : cookieLifetime,
    "pop_title": popTitle == null ? null : popTitle,
    "content_msg": contentMsg == null ? null : contentMsg,
    "show_term_condition": showTermCondition == null ? null : showTermCondition,
    "term_condition_text": termConditionText == null ? null : termConditionText,
    "submitbuttontxt": submitbuttontxt == null ? null : submitbuttontxt,
  };
}