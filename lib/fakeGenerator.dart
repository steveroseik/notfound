import 'dart:convert';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'objects.dart';

final faker = Faker();

List<SizeChart> generateSizeCharts(int count) {
  return List.generate(count, (index) {
    return SizeChart(
      id: faker.guid.guid(),
      name: faker.randomGenerator.string(10),
      photo: faker.image.image(),
    );
  });
}

List<Category> generateCategories(int count) {
  return List.generate(count, (index) {
    return Category(
      id: faker.randomGenerator.integer(100),
      name: faker.lorem.word(),
      urlName: faker.lorem.word(),
      active: faker.randomGenerator.boolean(),
      displayOrder: faker.randomGenerator.integer(100),
      metaTitle: faker.lorem.sentence(),
      metaDescription: faker.lorem.sentences(2).join(" "),
    );
  });
}

List<Collection> generateCollections(int count) {
  return List.generate(count, (index) {
    return Collection(
      id: faker.guid.guid(),
      name: faker.conference.name(),
      urlName: faker.lorem.word(),
      comingSoon: faker.randomGenerator.boolean(),
      bannerPhoto: faker.image.image(),
      description: faker.lorem.sentence(),
      active: faker.randomGenerator.boolean(),
      displayOrder: faker.randomGenerator.integer(100),
      metaTitle: faker.lorem.sentence(),
      metaDescription: faker.lorem.sentences(2).join(" "),
      shopBanner: faker.image.image(),
    );
  });
}

List<ShippingZone> generateShippingZones(int count) {
  return List.generate(count, (index) {
    return ShippingZone(
      id: faker.randomGenerator.integer(100),
      countryId: faker.randomGenerator.integer(100),
      name: faker.address.country(),
      priceEgp: faker.randomGenerator.integer(100),
      priceUsd: faker.randomGenerator.integer(100),
      priceEur: faker.randomGenerator.integer(100),
    );
  });
}

List<Product> generateProducts(int count) {
  return List.generate(count, (index) {
    return Product(
      id: faker.randomGenerator.integer(100),
      categoryId: faker.randomGenerator.integer(100),
      collectionId: faker.randomGenerator.integer(100),
      sizingChartId: faker.randomGenerator.integer(100),
      name: faker.company.name(),
      description: faker.lorem.sentence(),
      urlName: faker.lorem.word(),
      sku: faker.food.random.toString(),
      priceEgp: faker.randomGenerator.integer(100),
      priceUsd: faker.randomGenerator.integer(100),
      priceEur: faker.randomGenerator.integer(100),
      careInstructions: faker.lorem.sentence(),
      composition: faker.lorem.sentence(),
      metaTitle: faker.lorem.sentence(),
      metaDescription: faker.lorem.sentences(2).join(" "),
      discountEgp: faker.randomGenerator.integer(100),
      discountUsd: faker.randomGenerator.integer(100),
      discountEur: faker.randomGenerator.integer(100).toDouble(),
      active: faker.randomGenerator.boolean(),
    );
  });
}