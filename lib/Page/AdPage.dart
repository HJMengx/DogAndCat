import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:firebase_admob/firebase_admob.dart';

class AdPage {
  MobileAdTargetingInfo targetingInfo;

  InterstitialAd interstitial;

  BannerAd banner;

  void initAttributes() {
    if (this.targetingInfo == null) {
      this.targetingInfo = MobileAdTargetingInfo(
//          keywords: ["pet", "animal"],
          testDevices: ["Your Phone", "Simulator"]);

      bool android = Platform.isAndroid;

      this.interstitial = InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId,
        targetingInfo: this.targetingInfo,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.closed) {
            // 点击关闭
            print("InterstitialAd Closed");
            this.interstitial.dispose();
            this.interstitial = null;
          } else if (event == MobileAdEvent.clicked) {
            // 关闭
            print("InterstitialAd Clicked");
            this.interstitial.dispose();
            this.interstitial = null;
          } else if (event == MobileAdEvent.loaded) {
            // 加载
            print("InterstitialAd Loaded");
          }
          print("InterstitialAd event is $event");
        },
      );

//      this.banner = BannerAd(
//          adUnitId: android ? InterstitialAd.testAdUnitId : InterstitialAd.testAdUnitId,
//          targetingInfo: this.targetingInfo,
//          size: AdSize.smartBanner,
//          listener: (MobileAdEvent event) {
//            if (event == MobileAdEvent.closed) {
//              // 点击关闭
//              print("InterstitialAd Closed");
//              this.interstitial.dispose();
//              this.interstitial = null;
//            } else if (event == MobileAdEvent.clicked) {
//              // 关闭
//              print("InterstitialAd Clicked");
//              this.interstitial.dispose();
//              this.interstitial = null;
//            } else if (event == MobileAdEvent.loaded) {
//              // 加载
//              print("InterstitialAd Loaded");
//            }
//            print("InterstitialAd event is $event");
//          });
    }
  }

  @override
  void show() {
    // 初始化数据
    this.initAttributes();
    // 然后控制跳转
    if (this.interstitial != null) {
      this.interstitial.load();
      this.interstitial.show(
            anchorType: AnchorType.bottom,
            anchorOffset: 0.0,
          );
    }
  }
}
