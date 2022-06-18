import 'package:domain_models/domain_models.dart';

extension TagDomainToRM on Tag {
  String toRemoteModel() {
    switch (this) {
      case Tag.life:
        return 'life';
      case Tag.happiness:
        return 'happiness';
      case Tag.work:
        return 'work';
      case Tag.nature:
        return 'nature';
      case Tag.science:
        return 'science';
      case Tag.love:
        return 'love';
      case Tag.funny:
        return 'funny';
    }
  }
}
