import 'dart:math';

import 'package:flutter/material.dart';

class Vector {
  Vector(this.x, this.y);

  double x;
  double y;

  factory Vector.zero() => Vector(0, 0);

  factory Vector.random() => Vector(
        Random().nextDouble() * 2 - 1,
        Random().nextDouble() * 2 - 1,
      );

  double get angle => atan2(y, x);

  void add(Vector other) {
    x += other.x;
    y += other.y;
  }

  void subtract(Vector other) {
    x -= other.x;
    y -= other.y;
  }

  void multiply(Vector other) {
    x *= other.x;
    y *= other.y;
  }

  void divide(double scalar) {
    x /= scalar;
    y /= scalar;
  }

  double distance(Vector other) =>
      sqrt((x - other.x) * (x - other.x) + (y - other.y) * (y - other.y));

  void limit(double max) {
    if (magnitude > max) {
      normalize();
      scale(max);
    }
  }

  double get magnitude => sqrt(x * x + y * y);

  void normalize() {
    final mag = magnitude;

    if (mag > 0) {
      x /= mag;
      y /= mag;
    }
  }

  void scale(double scalar) {
    x *= scalar;
    y *= scalar;
  }

  void setBound(Size size) {
    if (x < 0) {
      x = size.width;
    } else if (x > size.width) {
      x = 0;
    }

    if (y < 0) {
      y = size.height;
    } else if (y > size.height) {
      y = 0;
    }
  }

  Offset toOffset() => Offset(x, y);

  @override
  String toString() => 'Vector($x, $y)';
}
