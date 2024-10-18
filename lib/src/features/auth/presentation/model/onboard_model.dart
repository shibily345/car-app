import 'dart:convert';
import 'package:flutter/services.dart';

class OnboardingContent {
  final String title;
  final String paragraph;
  final String image;

  OnboardingContent({
    required this.title,
    required this.paragraph,
    required this.image,
  });

  factory OnboardingContent.fromJson(Map<String, dynamic> json) {
    return OnboardingContent(
      title: json['title'],
      paragraph: json['paragraph'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'paragraph': paragraph,
      'image': image,
    };
  }
}

class OnboardingData {
  final List<OnboardingContent> onboarding;

  OnboardingData({required this.onboarding});

  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    var list = json['onboarding'] as List;
    List<OnboardingContent> onboardingList =
        list.map((i) => OnboardingContent.fromJson(i)).toList();

    return OnboardingData(onboarding: onboardingList);
  }

  Map<String, dynamic> toJson() {
    return {
      'onboarding': onboarding.map((content) => content.toJson()).toList(),
    };
  }
}

Future<OnboardingData> loadOnboardingData() async {
  final String response =
      await rootBundle.loadString('assets/data/onboarding_data.json');
  final data = await json.decode(response);
  return OnboardingData.fromJson(data);
}
