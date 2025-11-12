class Course {
  final String id;
  final String? slug;
  final String title;
  final String description;
  final List<String> technologies;
  final List<CourseDetail> details;
  final String category;
  final String duration;
  final String level;
  final String deliveryMode;
  final String? imageUrl;

  Course({
    required this.id,
    this.slug,
    required this.title,
    required this.description,
    required this.technologies,
    List<CourseDetail>? details,
    required this.category,
    this.duration = '6 weeks',
    this.level = 'Beginner',
    this.deliveryMode = 'Hybrid',
    this.imageUrl,
  }) : details = details ?? [];

  // Convert a Course to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'slug': slug,
      'title': title,
      'description': description,
      'technologies': technologies,
      'details': details.map((detail) => detail.toMap()).toList(),
      'category': category,
      'duration': duration,
      'level': level,
      'deliveryMode': deliveryMode,
      'imageUrl': imageUrl,
    };
  }

  // Create a Course from a Map
  factory Course.fromMap(Map<String, dynamic> map) {
    final idValue = map['id'];
    final titleValue = map['title'] ?? map['name'];
    final descriptionValue = map['description'] ?? map['summary'];
    final technologiesValue = map['technologies'] ?? map['technology_stack'];
    final levelValue = map['level'] ?? map['difficulty_level'];
    final durationValue = map['duration'] ?? map['duration_weeks'];
    final detailsValue = map['details'];

    final technologiesList = technologiesValue is List
        ? technologiesValue
            .map((item) => item.toString())
            .where((item) => item.isNotEmpty)
            .toList()
        : technologiesValue is String
            ? technologiesValue
                .split(',')
                .map((item) => item.trim())
                .where((item) => item.isNotEmpty)
                .toList()
            : <String>[];

    final durationString = durationValue is String
        ? durationValue
        : durationValue is num
            ? '${durationValue.toInt()} weeks'
            : '6 weeks';

    return Course(
      id: idValue.toString(),
      slug: map['slug'] as String?,
      title: titleValue?.toString() ?? 'Untitled Course',
      description: descriptionValue?.toString() ?? '',
      technologies: technologiesList,
      details: detailsValue is List
          ? detailsValue
              .map((item) => CourseDetail.fromMap(
                    (item as Map).map(
                      (key, value) => MapEntry(key.toString(), value),
                    ),
                  ))
              .toList()
          : [],
      category: (map['category'] ?? '').toString(),
      duration: durationString,
      level: levelValue?.toString() ?? 'Beginner',
      deliveryMode: (map['deliveryMode'] ?? map['delivery_mode'] ?? 'Hybrid').toString(),
      imageUrl: map['imageUrl'] as String?,
    );
  }

  // Create a copy of the course with some updated fields
  Course copyWith({
    String? id,
    String? slug,
    String? title,
    String? description,
    List<String>? technologies,
    List<CourseDetail>? details,
    String? category,
    String? duration,
    String? level,
    String? deliveryMode,
    String? imageUrl,
  }) {
    return Course(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      title: title ?? this.title,
      description: description ?? this.description,
      technologies: technologies ?? this.technologies,
      details: details ?? this.details,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      level: level ?? this.level,
      deliveryMode: deliveryMode ?? this.deliveryMode,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class CourseDetail {
  final int? id;
  final String techStack;
  final String description;
  final String? headline;
  final String? techStacks;
  final int? displayOrder;

  CourseDetail({
    this.id,
    required this.techStack,
    required this.description,
    this.headline,
    this.techStacks,
    this.displayOrder,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'techStack': techStack,
        'description': description,
        'headline': headline,
        'techStacks': techStacks,
        'displayOrder': displayOrder,
      };

  factory CourseDetail.fromMap(Map<String, dynamic> map) => CourseDetail(
        id: map['id'] is int ? map['id'] as int : int.tryParse(map['id']?.toString() ?? ''),
        techStack: (map['techStack'] ?? map['tech_name'] ?? map['techName'] ?? '').toString(),
        description:
            (map['description'] ?? map['long_description'] ?? map['longDescription'] ?? '').toString(),
        headline: (map['headline'] ?? map['techStack'] ?? map['tech_name'])?.toString(),
        techStacks: (map['techStacks'] ?? map['tech_stacks'] ?? map['techStats'])?.toString(),
        displayOrder: map['displayOrder'] is int
            ? map['displayOrder'] as int
            : map['display_order'] is int
                ? map['display_order'] as int
                : int.tryParse(map['displayOrder']?.toString() ?? map['display_order']?.toString() ?? ''),
      );

  CourseDetail copyWith({
    int? id,
    String? techStack,
    String? description,
    String? headline,
    String? techStacks,
    int? displayOrder,
  }) => CourseDetail(
        id: id ?? this.id,
        techStack: techStack ?? this.techStack,
        description: description ?? this.description,
        headline: headline ?? this.headline,
        techStacks: techStacks ?? this.techStacks,
        displayOrder: displayOrder ?? this.displayOrder,
      );
}
