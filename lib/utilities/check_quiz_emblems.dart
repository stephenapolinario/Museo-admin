import 'package:museo_admin_application/models/emblem.dart';

bool checkEmblemRanges(List<Emblem> emblems) {
  if (emblems.isEmpty) {
    return false;
  }

  emblems.sort((a, b) => a.minPoints.compareTo(b.minPoints));

  for (int i = 0; i < emblems.length - 1; i++) {
    Emblem currentEmblem = emblems[i];
    Emblem nextEmblem = emblems[i + 1];

    if (currentEmblem.maxPoints < nextEmblem.minPoints) {
      return false;
    }

    if (currentEmblem.maxPoints >= nextEmblem.maxPoints) {
      return false;
    } else {
      nextEmblem.minPoints = currentEmblem.maxPoints;
    }
  }

  if (emblems.last.maxPoints < 100) {
    return false;
  }

  return true;
}
