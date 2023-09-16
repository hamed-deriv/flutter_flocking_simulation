import 'package:flutter/material.dart';

import 'package:flutter_flocking_simulation/vector.dart';

class Boid {
  Vector position = Vector.zero();
  Vector velocity = Vector.zero();
  Vector acceleration = Vector.zero();

  final double perceptionRadius = 50;
  final double maxSpeed = 4;
  final double maxForce = 0.04;

  void show(Canvas canvas, Size size) {
    // final path = Path()
    //   ..moveTo(0, -6)
    //   ..lineTo(-6, 6)
    //   ..lineTo(0, 10)
    //   ..lineTo(6, 6)
    //   ..close();

    canvas.save();

    position.setBound(size);
    canvas.translate(position.x, position.y);
    // canvas.rotate(velocity.angle + pi / 2);

    // canvas.drawPath(
    //   path,
    //   Paint()
    //     ..color = Colors.white
    //     ..style = PaintingStyle.fill,
    // );

    canvas.drawCircle(
      Offset.zero,
      5,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );

    canvas.restore();
  }

  Vector getAlign(List<Boid> other) {
    double total = 0;
    Vector force = Vector.zero();

    for (final boid in other) {
      final distance = position.distance(boid.position);

      if (boid != this && distance < perceptionRadius) {
        force.add(boid.velocity);
        total++;
      }
    }

    if (total > 0) {
      force.divide(total);
      force.subtract(velocity);
      force.normalize();
      force.scale(maxSpeed);
      force.limit(maxForce);
    }

    return force;
  }

  Vector getCohesion(List<Boid> other) {
    double total = 0;
    Vector force = Vector.zero();

    for (final boid in other) {
      final distance = position.distance(boid.position);

      if (boid != this && distance < perceptionRadius) {
        force.add(boid.position);
        total++;
      }
    }

    if (total > 0) {
      force.divide(total);
      force.subtract(velocity);
      force.normalize();
      force.scale(maxSpeed);
      force.limit(maxForce);
    }

    return force;
  }

  Vector getSeparation(List<Boid> other) {
    double total = 0;
    Vector force = Vector.zero();

    for (final boid in other) {
      final distance = position.distance(boid.position);

      if (boid != this && distance < perceptionRadius) {
        final diff = Vector(position.x, position.y);
        diff.subtract(boid.position);
        diff.divide(distance);

        force.add(diff);
        total++;
      }
    }

    if (total > 0) {
      force.divide(total);
      force.subtract(velocity);
      force.normalize();
      force.scale(maxSpeed);
      force.limit(maxForce);
    }

    return force;
  }

  void flock(List<Boid> other) {
    final alignment = getAlign(other);
    final cohesion = getCohesion(other);
    final separation = getSeparation(other);

    acceleration.add(alignment);
    acceleration.add(cohesion);
    acceleration.add(separation);
  }

  void update() {
    position.add(velocity);
    velocity.add(acceleration);
    velocity.limit(maxSpeed);

    acceleration = Vector.zero();
  }
}
