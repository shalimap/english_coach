import 'package:flutter/material.dart';

class SliderModel {
  String? imageAssetPath;
  String? title;
  String? desc;

  SliderModel({this.imageAssetPath, this.title, this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String getImageAssetPath() {
    return imageAssetPath!;
  }

  String getTitle() {
    return title!;
  }

  String getDesc() {
    return desc!;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = [];
  SliderModel sliderModel = new SliderModel();

  //1

  sliderModel.setImageAssetPath("assets/intro/01.jpg");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2

  sliderModel.setImageAssetPath("assets/intro/02.jpg");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //3

  sliderModel.setImageAssetPath("assets/intro/03.jpg");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //4

  sliderModel.setImageAssetPath("assets/intro/04.jpg");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //5

  sliderModel.setImageAssetPath("assets/intro/05.jpg");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //6

  // sliderModel.setImageAssetPath("assets/intro/slider-06.jpg");
  // slides.add(sliderModel);

  // sliderModel = new SliderModel();

  return slides;
}
