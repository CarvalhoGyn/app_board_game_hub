// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _xpMeta = const VerificationMeta('xp');
  @override
  late final GeneratedColumn<int> xp = GeneratedColumn<int>(
    'xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _prestigeMeta = const VerificationMeta(
    'prestige',
  );
  @override
  late final GeneratedColumn<int> prestige = GeneratedColumn<int>(
    'prestige',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    username,
    email,
    password,
    firstName,
    lastName,
    phone,
    country,
    birthDate,
    avatarUrl,
    latitude,
    longitude,
    xp,
    prestige,
    title,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('xp')) {
      context.handle(_xpMeta, xp.isAcceptableOrUnknown(data['xp']!, _xpMeta));
    }
    if (data.containsKey('prestige')) {
      context.handle(
        _prestigeMeta,
        prestige.isAcceptableOrUnknown(data['prestige']!, _prestigeMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      ),
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      ),
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      ),
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      xp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp'],
      )!,
      prestige: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prestige'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String username;
  final String email;
  final String password;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? country;
  final DateTime? birthDate;
  final String? avatarUrl;
  final double? latitude;
  final double? longitude;
  final int xp;
  final int prestige;
  final String? title;
  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    this.firstName,
    this.lastName,
    this.phone,
    this.country,
    this.birthDate,
    this.avatarUrl,
    this.latitude,
    this.longitude,
    required this.xp,
    required this.prestige,
    this.title,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['email'] = Variable<String>(email);
    map['password'] = Variable<String>(password);
    if (!nullToAbsent || firstName != null) {
      map['first_name'] = Variable<String>(firstName);
    }
    if (!nullToAbsent || lastName != null) {
      map['last_name'] = Variable<String>(lastName);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<DateTime>(birthDate);
    }
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    map['xp'] = Variable<int>(xp);
    map['prestige'] = Variable<int>(prestige);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      email: Value(email),
      password: Value(password),
      firstName: firstName == null && nullToAbsent
          ? const Value.absent()
          : Value(firstName),
      lastName: lastName == null && nullToAbsent
          ? const Value.absent()
          : Value(lastName),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      birthDate: birthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDate),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      xp: Value(xp),
      prestige: Value(prestige),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      email: serializer.fromJson<String>(json['email']),
      password: serializer.fromJson<String>(json['password']),
      firstName: serializer.fromJson<String?>(json['firstName']),
      lastName: serializer.fromJson<String?>(json['lastName']),
      phone: serializer.fromJson<String?>(json['phone']),
      country: serializer.fromJson<String?>(json['country']),
      birthDate: serializer.fromJson<DateTime?>(json['birthDate']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      xp: serializer.fromJson<int>(json['xp']),
      prestige: serializer.fromJson<int>(json['prestige']),
      title: serializer.fromJson<String?>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'email': serializer.toJson<String>(email),
      'password': serializer.toJson<String>(password),
      'firstName': serializer.toJson<String?>(firstName),
      'lastName': serializer.toJson<String?>(lastName),
      'phone': serializer.toJson<String?>(phone),
      'country': serializer.toJson<String?>(country),
      'birthDate': serializer.toJson<DateTime?>(birthDate),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'xp': serializer.toJson<int>(xp),
      'prestige': serializer.toJson<int>(prestige),
      'title': serializer.toJson<String?>(title),
    };
  }

  User copyWith({
    int? id,
    String? username,
    String? email,
    String? password,
    Value<String?> firstName = const Value.absent(),
    Value<String?> lastName = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> country = const Value.absent(),
    Value<DateTime?> birthDate = const Value.absent(),
    Value<String?> avatarUrl = const Value.absent(),
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    int? xp,
    int? prestige,
    Value<String?> title = const Value.absent(),
  }) => User(
    id: id ?? this.id,
    username: username ?? this.username,
    email: email ?? this.email,
    password: password ?? this.password,
    firstName: firstName.present ? firstName.value : this.firstName,
    lastName: lastName.present ? lastName.value : this.lastName,
    phone: phone.present ? phone.value : this.phone,
    country: country.present ? country.value : this.country,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    xp: xp ?? this.xp,
    prestige: prestige ?? this.prestige,
    title: title.present ? title.value : this.title,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      email: data.email.present ? data.email.value : this.email,
      password: data.password.present ? data.password.value : this.password,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      phone: data.phone.present ? data.phone.value : this.phone,
      country: data.country.present ? data.country.value : this.country,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      xp: data.xp.present ? data.xp.value : this.xp,
      prestige: data.prestige.present ? data.prestige.value : this.prestige,
      title: data.title.present ? data.title.value : this.title,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('phone: $phone, ')
          ..write('country: $country, ')
          ..write('birthDate: $birthDate, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('xp: $xp, ')
          ..write('prestige: $prestige, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    username,
    email,
    password,
    firstName,
    lastName,
    phone,
    country,
    birthDate,
    avatarUrl,
    latitude,
    longitude,
    xp,
    prestige,
    title,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.email == this.email &&
          other.password == this.password &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.phone == this.phone &&
          other.country == this.country &&
          other.birthDate == this.birthDate &&
          other.avatarUrl == this.avatarUrl &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.xp == this.xp &&
          other.prestige == this.prestige &&
          other.title == this.title);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> email;
  final Value<String> password;
  final Value<String?> firstName;
  final Value<String?> lastName;
  final Value<String?> phone;
  final Value<String?> country;
  final Value<DateTime?> birthDate;
  final Value<String?> avatarUrl;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<int> xp;
  final Value<int> prestige;
  final Value<String?> title;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.email = const Value.absent(),
    this.password = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.phone = const Value.absent(),
    this.country = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.xp = const Value.absent(),
    this.prestige = const Value.absent(),
    this.title = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String email,
    required String password,
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.phone = const Value.absent(),
    this.country = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.xp = const Value.absent(),
    this.prestige = const Value.absent(),
    this.title = const Value.absent(),
  }) : username = Value(username),
       email = Value(email),
       password = Value(password);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? email,
    Expression<String>? password,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? phone,
    Expression<String>? country,
    Expression<DateTime>? birthDate,
    Expression<String>? avatarUrl,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<int>? xp,
    Expression<int>? prestige,
    Expression<String>? title,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (phone != null) 'phone': phone,
      if (country != null) 'country': country,
      if (birthDate != null) 'birth_date': birthDate,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (xp != null) 'xp': xp,
      if (prestige != null) 'prestige': prestige,
      if (title != null) 'title': title,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String>? username,
    Value<String>? email,
    Value<String>? password,
    Value<String?>? firstName,
    Value<String?>? lastName,
    Value<String?>? phone,
    Value<String?>? country,
    Value<DateTime?>? birthDate,
    Value<String?>? avatarUrl,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<int>? xp,
    Value<int>? prestige,
    Value<String?>? title,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      birthDate: birthDate ?? this.birthDate,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      xp: xp ?? this.xp,
      prestige: prestige ?? this.prestige,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (xp.present) {
      map['xp'] = Variable<int>(xp.value);
    }
    if (prestige.present) {
      map['prestige'] = Variable<int>(prestige.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('phone: $phone, ')
          ..write('country: $country, ')
          ..write('birthDate: $birthDate, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('xp: $xp, ')
          ..write('prestige: $prestige, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

class $GamesTable extends Games with TableInfo<$GamesTable, Game> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _bggIdMeta = const VerificationMeta('bggId');
  @override
  late final GeneratedColumn<int> bggId = GeneratedColumn<int>(
    'bgg_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minPlayersMeta = const VerificationMeta(
    'minPlayers',
  );
  @override
  late final GeneratedColumn<int> minPlayers = GeneratedColumn<int>(
    'min_players',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxPlayersMeta = const VerificationMeta(
    'maxPlayers',
  );
  @override
  late final GeneratedColumn<int> maxPlayers = GeneratedColumn<int>(
    'max_players',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearPublishedMeta = const VerificationMeta(
    'yearPublished',
  );
  @override
  late final GeneratedColumn<int> yearPublished = GeneratedColumn<int>(
    'year_published',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rankMeta = const VerificationMeta('rank');
  @override
  late final GeneratedColumn<int> rank = GeneratedColumn<int>(
    'rank',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
    'rating',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isEnrichedMeta = const VerificationMeta(
    'isEnriched',
  );
  @override
  late final GeneratedColumn<bool> isEnriched = GeneratedColumn<bool>(
    'is_enriched',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enriched" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _minPlaytimeMeta = const VerificationMeta(
    'minPlaytime',
  );
  @override
  late final GeneratedColumn<int> minPlaytime = GeneratedColumn<int>(
    'min_playtime',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxPlaytimeMeta = const VerificationMeta(
    'maxPlaytime',
  );
  @override
  late final GeneratedColumn<int> maxPlaytime = GeneratedColumn<int>(
    'max_playtime',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minAgeMeta = const VerificationMeta('minAge');
  @override
  late final GeneratedColumn<int> minAge = GeneratedColumn<int>(
    'min_age',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoriesMeta = const VerificationMeta(
    'categories',
  );
  @override
  late final GeneratedColumn<String> categories = GeneratedColumn<String>(
    'categories',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mechanicsMeta = const VerificationMeta(
    'mechanics',
  );
  @override
  late final GeneratedColumn<String> mechanics = GeneratedColumn<String>(
    'mechanics',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _familiesMeta = const VerificationMeta(
    'families',
  );
  @override
  late final GeneratedColumn<String> families = GeneratedColumn<String>(
    'families',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _integrationsMeta = const VerificationMeta(
    'integrations',
  );
  @override
  late final GeneratedColumn<String> integrations = GeneratedColumn<String>(
    'integrations',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reimplementationsMeta = const VerificationMeta(
    'reimplementations',
  );
  @override
  late final GeneratedColumn<String> reimplementations =
      GeneratedColumn<String>(
        'reimplementations',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bggId,
    name,
    description,
    imageUrl,
    minPlayers,
    maxPlayers,
    yearPublished,
    rank,
    rating,
    isEnriched,
    minPlaytime,
    maxPlaytime,
    minAge,
    categories,
    mechanics,
    type,
    families,
    integrations,
    reimplementations,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games';
  @override
  VerificationContext validateIntegrity(
    Insertable<Game> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bgg_id')) {
      context.handle(
        _bggIdMeta,
        bggId.isAcceptableOrUnknown(data['bgg_id']!, _bggIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('min_players')) {
      context.handle(
        _minPlayersMeta,
        minPlayers.isAcceptableOrUnknown(data['min_players']!, _minPlayersMeta),
      );
    }
    if (data.containsKey('max_players')) {
      context.handle(
        _maxPlayersMeta,
        maxPlayers.isAcceptableOrUnknown(data['max_players']!, _maxPlayersMeta),
      );
    }
    if (data.containsKey('year_published')) {
      context.handle(
        _yearPublishedMeta,
        yearPublished.isAcceptableOrUnknown(
          data['year_published']!,
          _yearPublishedMeta,
        ),
      );
    }
    if (data.containsKey('rank')) {
      context.handle(
        _rankMeta,
        rank.isAcceptableOrUnknown(data['rank']!, _rankMeta),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('is_enriched')) {
      context.handle(
        _isEnrichedMeta,
        isEnriched.isAcceptableOrUnknown(data['is_enriched']!, _isEnrichedMeta),
      );
    }
    if (data.containsKey('min_playtime')) {
      context.handle(
        _minPlaytimeMeta,
        minPlaytime.isAcceptableOrUnknown(
          data['min_playtime']!,
          _minPlaytimeMeta,
        ),
      );
    }
    if (data.containsKey('max_playtime')) {
      context.handle(
        _maxPlaytimeMeta,
        maxPlaytime.isAcceptableOrUnknown(
          data['max_playtime']!,
          _maxPlaytimeMeta,
        ),
      );
    }
    if (data.containsKey('min_age')) {
      context.handle(
        _minAgeMeta,
        minAge.isAcceptableOrUnknown(data['min_age']!, _minAgeMeta),
      );
    }
    if (data.containsKey('categories')) {
      context.handle(
        _categoriesMeta,
        categories.isAcceptableOrUnknown(data['categories']!, _categoriesMeta),
      );
    }
    if (data.containsKey('mechanics')) {
      context.handle(
        _mechanicsMeta,
        mechanics.isAcceptableOrUnknown(data['mechanics']!, _mechanicsMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('families')) {
      context.handle(
        _familiesMeta,
        families.isAcceptableOrUnknown(data['families']!, _familiesMeta),
      );
    }
    if (data.containsKey('integrations')) {
      context.handle(
        _integrationsMeta,
        integrations.isAcceptableOrUnknown(
          data['integrations']!,
          _integrationsMeta,
        ),
      );
    }
    if (data.containsKey('reimplementations')) {
      context.handle(
        _reimplementationsMeta,
        reimplementations.isAcceptableOrUnknown(
          data['reimplementations']!,
          _reimplementationsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Game map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Game(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      bggId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bgg_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      minPlayers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_players'],
      ),
      maxPlayers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_players'],
      ),
      yearPublished: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year_published'],
      ),
      rank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rank'],
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating'],
      ),
      isEnriched: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enriched'],
      )!,
      minPlaytime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_playtime'],
      ),
      maxPlaytime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_playtime'],
      ),
      minAge: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_age'],
      ),
      categories: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categories'],
      ),
      mechanics: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mechanics'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      ),
      families: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}families'],
      ),
      integrations: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}integrations'],
      ),
      reimplementations: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reimplementations'],
      ),
    );
  }

  @override
  $GamesTable createAlias(String alias) {
    return $GamesTable(attachedDatabase, alias);
  }
}

class Game extends DataClass implements Insertable<Game> {
  final int id;
  final int? bggId;
  final String name;
  final String? description;
  final String? imageUrl;
  final int? minPlayers;
  final int? maxPlayers;
  final int? yearPublished;
  final int? rank;
  final double? rating;
  final bool isEnriched;
  final int? minPlaytime;
  final int? maxPlaytime;
  final int? minAge;
  final String? categories;
  final String? mechanics;
  final String? type;
  final String? families;
  final String? integrations;
  final String? reimplementations;
  const Game({
    required this.id,
    this.bggId,
    required this.name,
    this.description,
    this.imageUrl,
    this.minPlayers,
    this.maxPlayers,
    this.yearPublished,
    this.rank,
    this.rating,
    required this.isEnriched,
    this.minPlaytime,
    this.maxPlaytime,
    this.minAge,
    this.categories,
    this.mechanics,
    this.type,
    this.families,
    this.integrations,
    this.reimplementations,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || bggId != null) {
      map['bgg_id'] = Variable<int>(bggId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || minPlayers != null) {
      map['min_players'] = Variable<int>(minPlayers);
    }
    if (!nullToAbsent || maxPlayers != null) {
      map['max_players'] = Variable<int>(maxPlayers);
    }
    if (!nullToAbsent || yearPublished != null) {
      map['year_published'] = Variable<int>(yearPublished);
    }
    if (!nullToAbsent || rank != null) {
      map['rank'] = Variable<int>(rank);
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<double>(rating);
    }
    map['is_enriched'] = Variable<bool>(isEnriched);
    if (!nullToAbsent || minPlaytime != null) {
      map['min_playtime'] = Variable<int>(minPlaytime);
    }
    if (!nullToAbsent || maxPlaytime != null) {
      map['max_playtime'] = Variable<int>(maxPlaytime);
    }
    if (!nullToAbsent || minAge != null) {
      map['min_age'] = Variable<int>(minAge);
    }
    if (!nullToAbsent || categories != null) {
      map['categories'] = Variable<String>(categories);
    }
    if (!nullToAbsent || mechanics != null) {
      map['mechanics'] = Variable<String>(mechanics);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || families != null) {
      map['families'] = Variable<String>(families);
    }
    if (!nullToAbsent || integrations != null) {
      map['integrations'] = Variable<String>(integrations);
    }
    if (!nullToAbsent || reimplementations != null) {
      map['reimplementations'] = Variable<String>(reimplementations);
    }
    return map;
  }

  GamesCompanion toCompanion(bool nullToAbsent) {
    return GamesCompanion(
      id: Value(id),
      bggId: bggId == null && nullToAbsent
          ? const Value.absent()
          : Value(bggId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      minPlayers: minPlayers == null && nullToAbsent
          ? const Value.absent()
          : Value(minPlayers),
      maxPlayers: maxPlayers == null && nullToAbsent
          ? const Value.absent()
          : Value(maxPlayers),
      yearPublished: yearPublished == null && nullToAbsent
          ? const Value.absent()
          : Value(yearPublished),
      rank: rank == null && nullToAbsent ? const Value.absent() : Value(rank),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      isEnriched: Value(isEnriched),
      minPlaytime: minPlaytime == null && nullToAbsent
          ? const Value.absent()
          : Value(minPlaytime),
      maxPlaytime: maxPlaytime == null && nullToAbsent
          ? const Value.absent()
          : Value(maxPlaytime),
      minAge: minAge == null && nullToAbsent
          ? const Value.absent()
          : Value(minAge),
      categories: categories == null && nullToAbsent
          ? const Value.absent()
          : Value(categories),
      mechanics: mechanics == null && nullToAbsent
          ? const Value.absent()
          : Value(mechanics),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      families: families == null && nullToAbsent
          ? const Value.absent()
          : Value(families),
      integrations: integrations == null && nullToAbsent
          ? const Value.absent()
          : Value(integrations),
      reimplementations: reimplementations == null && nullToAbsent
          ? const Value.absent()
          : Value(reimplementations),
    );
  }

  factory Game.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Game(
      id: serializer.fromJson<int>(json['id']),
      bggId: serializer.fromJson<int?>(json['bggId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      minPlayers: serializer.fromJson<int?>(json['minPlayers']),
      maxPlayers: serializer.fromJson<int?>(json['maxPlayers']),
      yearPublished: serializer.fromJson<int?>(json['yearPublished']),
      rank: serializer.fromJson<int?>(json['rank']),
      rating: serializer.fromJson<double?>(json['rating']),
      isEnriched: serializer.fromJson<bool>(json['isEnriched']),
      minPlaytime: serializer.fromJson<int?>(json['minPlaytime']),
      maxPlaytime: serializer.fromJson<int?>(json['maxPlaytime']),
      minAge: serializer.fromJson<int?>(json['minAge']),
      categories: serializer.fromJson<String?>(json['categories']),
      mechanics: serializer.fromJson<String?>(json['mechanics']),
      type: serializer.fromJson<String?>(json['type']),
      families: serializer.fromJson<String?>(json['families']),
      integrations: serializer.fromJson<String?>(json['integrations']),
      reimplementations: serializer.fromJson<String?>(
        json['reimplementations'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bggId': serializer.toJson<int?>(bggId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'minPlayers': serializer.toJson<int?>(minPlayers),
      'maxPlayers': serializer.toJson<int?>(maxPlayers),
      'yearPublished': serializer.toJson<int?>(yearPublished),
      'rank': serializer.toJson<int?>(rank),
      'rating': serializer.toJson<double?>(rating),
      'isEnriched': serializer.toJson<bool>(isEnriched),
      'minPlaytime': serializer.toJson<int?>(minPlaytime),
      'maxPlaytime': serializer.toJson<int?>(maxPlaytime),
      'minAge': serializer.toJson<int?>(minAge),
      'categories': serializer.toJson<String?>(categories),
      'mechanics': serializer.toJson<String?>(mechanics),
      'type': serializer.toJson<String?>(type),
      'families': serializer.toJson<String?>(families),
      'integrations': serializer.toJson<String?>(integrations),
      'reimplementations': serializer.toJson<String?>(reimplementations),
    };
  }

  Game copyWith({
    int? id,
    Value<int?> bggId = const Value.absent(),
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    Value<int?> minPlayers = const Value.absent(),
    Value<int?> maxPlayers = const Value.absent(),
    Value<int?> yearPublished = const Value.absent(),
    Value<int?> rank = const Value.absent(),
    Value<double?> rating = const Value.absent(),
    bool? isEnriched,
    Value<int?> minPlaytime = const Value.absent(),
    Value<int?> maxPlaytime = const Value.absent(),
    Value<int?> minAge = const Value.absent(),
    Value<String?> categories = const Value.absent(),
    Value<String?> mechanics = const Value.absent(),
    Value<String?> type = const Value.absent(),
    Value<String?> families = const Value.absent(),
    Value<String?> integrations = const Value.absent(),
    Value<String?> reimplementations = const Value.absent(),
  }) => Game(
    id: id ?? this.id,
    bggId: bggId.present ? bggId.value : this.bggId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    minPlayers: minPlayers.present ? minPlayers.value : this.minPlayers,
    maxPlayers: maxPlayers.present ? maxPlayers.value : this.maxPlayers,
    yearPublished: yearPublished.present
        ? yearPublished.value
        : this.yearPublished,
    rank: rank.present ? rank.value : this.rank,
    rating: rating.present ? rating.value : this.rating,
    isEnriched: isEnriched ?? this.isEnriched,
    minPlaytime: minPlaytime.present ? minPlaytime.value : this.minPlaytime,
    maxPlaytime: maxPlaytime.present ? maxPlaytime.value : this.maxPlaytime,
    minAge: minAge.present ? minAge.value : this.minAge,
    categories: categories.present ? categories.value : this.categories,
    mechanics: mechanics.present ? mechanics.value : this.mechanics,
    type: type.present ? type.value : this.type,
    families: families.present ? families.value : this.families,
    integrations: integrations.present ? integrations.value : this.integrations,
    reimplementations: reimplementations.present
        ? reimplementations.value
        : this.reimplementations,
  );
  Game copyWithCompanion(GamesCompanion data) {
    return Game(
      id: data.id.present ? data.id.value : this.id,
      bggId: data.bggId.present ? data.bggId.value : this.bggId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      minPlayers: data.minPlayers.present
          ? data.minPlayers.value
          : this.minPlayers,
      maxPlayers: data.maxPlayers.present
          ? data.maxPlayers.value
          : this.maxPlayers,
      yearPublished: data.yearPublished.present
          ? data.yearPublished.value
          : this.yearPublished,
      rank: data.rank.present ? data.rank.value : this.rank,
      rating: data.rating.present ? data.rating.value : this.rating,
      isEnriched: data.isEnriched.present
          ? data.isEnriched.value
          : this.isEnriched,
      minPlaytime: data.minPlaytime.present
          ? data.minPlaytime.value
          : this.minPlaytime,
      maxPlaytime: data.maxPlaytime.present
          ? data.maxPlaytime.value
          : this.maxPlaytime,
      minAge: data.minAge.present ? data.minAge.value : this.minAge,
      categories: data.categories.present
          ? data.categories.value
          : this.categories,
      mechanics: data.mechanics.present ? data.mechanics.value : this.mechanics,
      type: data.type.present ? data.type.value : this.type,
      families: data.families.present ? data.families.value : this.families,
      integrations: data.integrations.present
          ? data.integrations.value
          : this.integrations,
      reimplementations: data.reimplementations.present
          ? data.reimplementations.value
          : this.reimplementations,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Game(')
          ..write('id: $id, ')
          ..write('bggId: $bggId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('minPlayers: $minPlayers, ')
          ..write('maxPlayers: $maxPlayers, ')
          ..write('yearPublished: $yearPublished, ')
          ..write('rank: $rank, ')
          ..write('rating: $rating, ')
          ..write('isEnriched: $isEnriched, ')
          ..write('minPlaytime: $minPlaytime, ')
          ..write('maxPlaytime: $maxPlaytime, ')
          ..write('minAge: $minAge, ')
          ..write('categories: $categories, ')
          ..write('mechanics: $mechanics, ')
          ..write('type: $type, ')
          ..write('families: $families, ')
          ..write('integrations: $integrations, ')
          ..write('reimplementations: $reimplementations')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bggId,
    name,
    description,
    imageUrl,
    minPlayers,
    maxPlayers,
    yearPublished,
    rank,
    rating,
    isEnriched,
    minPlaytime,
    maxPlaytime,
    minAge,
    categories,
    mechanics,
    type,
    families,
    integrations,
    reimplementations,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Game &&
          other.id == this.id &&
          other.bggId == this.bggId &&
          other.name == this.name &&
          other.description == this.description &&
          other.imageUrl == this.imageUrl &&
          other.minPlayers == this.minPlayers &&
          other.maxPlayers == this.maxPlayers &&
          other.yearPublished == this.yearPublished &&
          other.rank == this.rank &&
          other.rating == this.rating &&
          other.isEnriched == this.isEnriched &&
          other.minPlaytime == this.minPlaytime &&
          other.maxPlaytime == this.maxPlaytime &&
          other.minAge == this.minAge &&
          other.categories == this.categories &&
          other.mechanics == this.mechanics &&
          other.type == this.type &&
          other.families == this.families &&
          other.integrations == this.integrations &&
          other.reimplementations == this.reimplementations);
}

class GamesCompanion extends UpdateCompanion<Game> {
  final Value<int> id;
  final Value<int?> bggId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> imageUrl;
  final Value<int?> minPlayers;
  final Value<int?> maxPlayers;
  final Value<int?> yearPublished;
  final Value<int?> rank;
  final Value<double?> rating;
  final Value<bool> isEnriched;
  final Value<int?> minPlaytime;
  final Value<int?> maxPlaytime;
  final Value<int?> minAge;
  final Value<String?> categories;
  final Value<String?> mechanics;
  final Value<String?> type;
  final Value<String?> families;
  final Value<String?> integrations;
  final Value<String?> reimplementations;
  const GamesCompanion({
    this.id = const Value.absent(),
    this.bggId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.minPlayers = const Value.absent(),
    this.maxPlayers = const Value.absent(),
    this.yearPublished = const Value.absent(),
    this.rank = const Value.absent(),
    this.rating = const Value.absent(),
    this.isEnriched = const Value.absent(),
    this.minPlaytime = const Value.absent(),
    this.maxPlaytime = const Value.absent(),
    this.minAge = const Value.absent(),
    this.categories = const Value.absent(),
    this.mechanics = const Value.absent(),
    this.type = const Value.absent(),
    this.families = const Value.absent(),
    this.integrations = const Value.absent(),
    this.reimplementations = const Value.absent(),
  });
  GamesCompanion.insert({
    this.id = const Value.absent(),
    this.bggId = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.minPlayers = const Value.absent(),
    this.maxPlayers = const Value.absent(),
    this.yearPublished = const Value.absent(),
    this.rank = const Value.absent(),
    this.rating = const Value.absent(),
    this.isEnriched = const Value.absent(),
    this.minPlaytime = const Value.absent(),
    this.maxPlaytime = const Value.absent(),
    this.minAge = const Value.absent(),
    this.categories = const Value.absent(),
    this.mechanics = const Value.absent(),
    this.type = const Value.absent(),
    this.families = const Value.absent(),
    this.integrations = const Value.absent(),
    this.reimplementations = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Game> custom({
    Expression<int>? id,
    Expression<int>? bggId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? imageUrl,
    Expression<int>? minPlayers,
    Expression<int>? maxPlayers,
    Expression<int>? yearPublished,
    Expression<int>? rank,
    Expression<double>? rating,
    Expression<bool>? isEnriched,
    Expression<int>? minPlaytime,
    Expression<int>? maxPlaytime,
    Expression<int>? minAge,
    Expression<String>? categories,
    Expression<String>? mechanics,
    Expression<String>? type,
    Expression<String>? families,
    Expression<String>? integrations,
    Expression<String>? reimplementations,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bggId != null) 'bgg_id': bggId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (imageUrl != null) 'image_url': imageUrl,
      if (minPlayers != null) 'min_players': minPlayers,
      if (maxPlayers != null) 'max_players': maxPlayers,
      if (yearPublished != null) 'year_published': yearPublished,
      if (rank != null) 'rank': rank,
      if (rating != null) 'rating': rating,
      if (isEnriched != null) 'is_enriched': isEnriched,
      if (minPlaytime != null) 'min_playtime': minPlaytime,
      if (maxPlaytime != null) 'max_playtime': maxPlaytime,
      if (minAge != null) 'min_age': minAge,
      if (categories != null) 'categories': categories,
      if (mechanics != null) 'mechanics': mechanics,
      if (type != null) 'type': type,
      if (families != null) 'families': families,
      if (integrations != null) 'integrations': integrations,
      if (reimplementations != null) 'reimplementations': reimplementations,
    });
  }

  GamesCompanion copyWith({
    Value<int>? id,
    Value<int?>? bggId,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? imageUrl,
    Value<int?>? minPlayers,
    Value<int?>? maxPlayers,
    Value<int?>? yearPublished,
    Value<int?>? rank,
    Value<double?>? rating,
    Value<bool>? isEnriched,
    Value<int?>? minPlaytime,
    Value<int?>? maxPlaytime,
    Value<int?>? minAge,
    Value<String?>? categories,
    Value<String?>? mechanics,
    Value<String?>? type,
    Value<String?>? families,
    Value<String?>? integrations,
    Value<String?>? reimplementations,
  }) {
    return GamesCompanion(
      id: id ?? this.id,
      bggId: bggId ?? this.bggId,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      minPlayers: minPlayers ?? this.minPlayers,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      yearPublished: yearPublished ?? this.yearPublished,
      rank: rank ?? this.rank,
      rating: rating ?? this.rating,
      isEnriched: isEnriched ?? this.isEnriched,
      minPlaytime: minPlaytime ?? this.minPlaytime,
      maxPlaytime: maxPlaytime ?? this.maxPlaytime,
      minAge: minAge ?? this.minAge,
      categories: categories ?? this.categories,
      mechanics: mechanics ?? this.mechanics,
      type: type ?? this.type,
      families: families ?? this.families,
      integrations: integrations ?? this.integrations,
      reimplementations: reimplementations ?? this.reimplementations,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bggId.present) {
      map['bgg_id'] = Variable<int>(bggId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (minPlayers.present) {
      map['min_players'] = Variable<int>(minPlayers.value);
    }
    if (maxPlayers.present) {
      map['max_players'] = Variable<int>(maxPlayers.value);
    }
    if (yearPublished.present) {
      map['year_published'] = Variable<int>(yearPublished.value);
    }
    if (rank.present) {
      map['rank'] = Variable<int>(rank.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (isEnriched.present) {
      map['is_enriched'] = Variable<bool>(isEnriched.value);
    }
    if (minPlaytime.present) {
      map['min_playtime'] = Variable<int>(minPlaytime.value);
    }
    if (maxPlaytime.present) {
      map['max_playtime'] = Variable<int>(maxPlaytime.value);
    }
    if (minAge.present) {
      map['min_age'] = Variable<int>(minAge.value);
    }
    if (categories.present) {
      map['categories'] = Variable<String>(categories.value);
    }
    if (mechanics.present) {
      map['mechanics'] = Variable<String>(mechanics.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (families.present) {
      map['families'] = Variable<String>(families.value);
    }
    if (integrations.present) {
      map['integrations'] = Variable<String>(integrations.value);
    }
    if (reimplementations.present) {
      map['reimplementations'] = Variable<String>(reimplementations.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesCompanion(')
          ..write('id: $id, ')
          ..write('bggId: $bggId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('minPlayers: $minPlayers, ')
          ..write('maxPlayers: $maxPlayers, ')
          ..write('yearPublished: $yearPublished, ')
          ..write('rank: $rank, ')
          ..write('rating: $rating, ')
          ..write('isEnriched: $isEnriched, ')
          ..write('minPlaytime: $minPlaytime, ')
          ..write('maxPlaytime: $maxPlaytime, ')
          ..write('minAge: $minAge, ')
          ..write('categories: $categories, ')
          ..write('mechanics: $mechanics, ')
          ..write('type: $type, ')
          ..write('families: $families, ')
          ..write('integrations: $integrations, ')
          ..write('reimplementations: $reimplementations')
          ..write(')'))
        .toString();
  }
}

class $MatchesTable extends Matches with TableInfo<$MatchesTable, MatchRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<int> gameId = GeneratedColumn<int>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scoringTypeMeta = const VerificationMeta(
    'scoringType',
  );
  @override
  late final GeneratedColumn<String> scoringType = GeneratedColumn<String>(
    'scoring_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('competitive'),
  );
  static const VerificationMeta _creatorIdMeta = const VerificationMeta(
    'creatorId',
  );
  @override
  late final GeneratedColumn<int> creatorId = GeneratedColumn<int>(
    'creator_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameId,
    date,
    location,
    scoringType,
    creatorId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'matches';
  @override
  VerificationContext validateIntegrity(
    Insertable<MatchRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('scoring_type')) {
      context.handle(
        _scoringTypeMeta,
        scoringType.isAcceptableOrUnknown(
          data['scoring_type']!,
          _scoringTypeMeta,
        ),
      );
    }
    if (data.containsKey('creator_id')) {
      context.handle(
        _creatorIdMeta,
        creatorId.isAcceptableOrUnknown(data['creator_id']!, _creatorIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MatchRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MatchRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      scoringType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scoring_type'],
      )!,
      creatorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}creator_id'],
      ),
    );
  }

  @override
  $MatchesTable createAlias(String alias) {
    return $MatchesTable(attachedDatabase, alias);
  }
}

class MatchRow extends DataClass implements Insertable<MatchRow> {
  final int id;
  final int gameId;
  final DateTime date;
  final String? location;
  final String scoringType;
  final int? creatorId;
  const MatchRow({
    required this.id,
    required this.gameId,
    required this.date,
    this.location,
    required this.scoringType,
    this.creatorId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['game_id'] = Variable<int>(gameId);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    map['scoring_type'] = Variable<String>(scoringType);
    if (!nullToAbsent || creatorId != null) {
      map['creator_id'] = Variable<int>(creatorId);
    }
    return map;
  }

  MatchesCompanion toCompanion(bool nullToAbsent) {
    return MatchesCompanion(
      id: Value(id),
      gameId: Value(gameId),
      date: Value(date),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      scoringType: Value(scoringType),
      creatorId: creatorId == null && nullToAbsent
          ? const Value.absent()
          : Value(creatorId),
    );
  }

  factory MatchRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MatchRow(
      id: serializer.fromJson<int>(json['id']),
      gameId: serializer.fromJson<int>(json['gameId']),
      date: serializer.fromJson<DateTime>(json['date']),
      location: serializer.fromJson<String?>(json['location']),
      scoringType: serializer.fromJson<String>(json['scoringType']),
      creatorId: serializer.fromJson<int?>(json['creatorId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gameId': serializer.toJson<int>(gameId),
      'date': serializer.toJson<DateTime>(date),
      'location': serializer.toJson<String?>(location),
      'scoringType': serializer.toJson<String>(scoringType),
      'creatorId': serializer.toJson<int?>(creatorId),
    };
  }

  MatchRow copyWith({
    int? id,
    int? gameId,
    DateTime? date,
    Value<String?> location = const Value.absent(),
    String? scoringType,
    Value<int?> creatorId = const Value.absent(),
  }) => MatchRow(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    date: date ?? this.date,
    location: location.present ? location.value : this.location,
    scoringType: scoringType ?? this.scoringType,
    creatorId: creatorId.present ? creatorId.value : this.creatorId,
  );
  MatchRow copyWithCompanion(MatchesCompanion data) {
    return MatchRow(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      date: data.date.present ? data.date.value : this.date,
      location: data.location.present ? data.location.value : this.location,
      scoringType: data.scoringType.present
          ? data.scoringType.value
          : this.scoringType,
      creatorId: data.creatorId.present ? data.creatorId.value : this.creatorId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MatchRow(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('date: $date, ')
          ..write('location: $location, ')
          ..write('scoringType: $scoringType, ')
          ..write('creatorId: $creatorId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, gameId, date, location, scoringType, creatorId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MatchRow &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.date == this.date &&
          other.location == this.location &&
          other.scoringType == this.scoringType &&
          other.creatorId == this.creatorId);
}

class MatchesCompanion extends UpdateCompanion<MatchRow> {
  final Value<int> id;
  final Value<int> gameId;
  final Value<DateTime> date;
  final Value<String?> location;
  final Value<String> scoringType;
  final Value<int?> creatorId;
  const MatchesCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.date = const Value.absent(),
    this.location = const Value.absent(),
    this.scoringType = const Value.absent(),
    this.creatorId = const Value.absent(),
  });
  MatchesCompanion.insert({
    this.id = const Value.absent(),
    required int gameId,
    required DateTime date,
    this.location = const Value.absent(),
    this.scoringType = const Value.absent(),
    this.creatorId = const Value.absent(),
  }) : gameId = Value(gameId),
       date = Value(date);
  static Insertable<MatchRow> custom({
    Expression<int>? id,
    Expression<int>? gameId,
    Expression<DateTime>? date,
    Expression<String>? location,
    Expression<String>? scoringType,
    Expression<int>? creatorId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (date != null) 'date': date,
      if (location != null) 'location': location,
      if (scoringType != null) 'scoring_type': scoringType,
      if (creatorId != null) 'creator_id': creatorId,
    });
  }

  MatchesCompanion copyWith({
    Value<int>? id,
    Value<int>? gameId,
    Value<DateTime>? date,
    Value<String?>? location,
    Value<String>? scoringType,
    Value<int?>? creatorId,
  }) {
    return MatchesCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      date: date ?? this.date,
      location: location ?? this.location,
      scoringType: scoringType ?? this.scoringType,
      creatorId: creatorId ?? this.creatorId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (scoringType.present) {
      map['scoring_type'] = Variable<String>(scoringType.value);
    }
    if (creatorId.present) {
      map['creator_id'] = Variable<int>(creatorId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MatchesCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('date: $date, ')
          ..write('location: $location, ')
          ..write('scoringType: $scoringType, ')
          ..write('creatorId: $creatorId')
          ..write(')'))
        .toString();
  }
}

class $PlayersTable extends Players with TableInfo<$PlayersTable, Player> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _matchIdMeta = const VerificationMeta(
    'matchId',
  );
  @override
  late final GeneratedColumn<int> matchId = GeneratedColumn<int>(
    'match_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES matches (id)',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rankMeta = const VerificationMeta('rank');
  @override
  late final GeneratedColumn<int> rank = GeneratedColumn<int>(
    'rank',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _matchRatingMeta = const VerificationMeta(
    'matchRating',
  );
  @override
  late final GeneratedColumn<double> matchRating = GeneratedColumn<double>(
    'match_rating',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isWinnerMeta = const VerificationMeta(
    'isWinner',
  );
  @override
  late final GeneratedColumn<bool> isWinner = GeneratedColumn<bool>(
    'is_winner',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_winner" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    matchId,
    userId,
    score,
    rank,
    matchRating,
    isWinner,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'players';
  @override
  VerificationContext validateIntegrity(
    Insertable<Player> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('match_id')) {
      context.handle(
        _matchIdMeta,
        matchId.isAcceptableOrUnknown(data['match_id']!, _matchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_matchIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('rank')) {
      context.handle(
        _rankMeta,
        rank.isAcceptableOrUnknown(data['rank']!, _rankMeta),
      );
    }
    if (data.containsKey('match_rating')) {
      context.handle(
        _matchRatingMeta,
        matchRating.isAcceptableOrUnknown(
          data['match_rating']!,
          _matchRatingMeta,
        ),
      );
    }
    if (data.containsKey('is_winner')) {
      context.handle(
        _isWinnerMeta,
        isWinner.isAcceptableOrUnknown(data['is_winner']!, _isWinnerMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Player map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Player(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      matchId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}match_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      ),
      rank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rank'],
      ),
      matchRating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}match_rating'],
      ),
      isWinner: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_winner'],
      )!,
    );
  }

  @override
  $PlayersTable createAlias(String alias) {
    return $PlayersTable(attachedDatabase, alias);
  }
}

class Player extends DataClass implements Insertable<Player> {
  final int id;
  final int matchId;
  final int userId;
  final int? score;
  final int? rank;
  final double? matchRating;
  final bool isWinner;
  const Player({
    required this.id,
    required this.matchId,
    required this.userId,
    this.score,
    this.rank,
    this.matchRating,
    required this.isWinner,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['match_id'] = Variable<int>(matchId);
    map['user_id'] = Variable<int>(userId);
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<int>(score);
    }
    if (!nullToAbsent || rank != null) {
      map['rank'] = Variable<int>(rank);
    }
    if (!nullToAbsent || matchRating != null) {
      map['match_rating'] = Variable<double>(matchRating);
    }
    map['is_winner'] = Variable<bool>(isWinner);
    return map;
  }

  PlayersCompanion toCompanion(bool nullToAbsent) {
    return PlayersCompanion(
      id: Value(id),
      matchId: Value(matchId),
      userId: Value(userId),
      score: score == null && nullToAbsent
          ? const Value.absent()
          : Value(score),
      rank: rank == null && nullToAbsent ? const Value.absent() : Value(rank),
      matchRating: matchRating == null && nullToAbsent
          ? const Value.absent()
          : Value(matchRating),
      isWinner: Value(isWinner),
    );
  }

  factory Player.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Player(
      id: serializer.fromJson<int>(json['id']),
      matchId: serializer.fromJson<int>(json['matchId']),
      userId: serializer.fromJson<int>(json['userId']),
      score: serializer.fromJson<int?>(json['score']),
      rank: serializer.fromJson<int?>(json['rank']),
      matchRating: serializer.fromJson<double?>(json['matchRating']),
      isWinner: serializer.fromJson<bool>(json['isWinner']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'matchId': serializer.toJson<int>(matchId),
      'userId': serializer.toJson<int>(userId),
      'score': serializer.toJson<int?>(score),
      'rank': serializer.toJson<int?>(rank),
      'matchRating': serializer.toJson<double?>(matchRating),
      'isWinner': serializer.toJson<bool>(isWinner),
    };
  }

  Player copyWith({
    int? id,
    int? matchId,
    int? userId,
    Value<int?> score = const Value.absent(),
    Value<int?> rank = const Value.absent(),
    Value<double?> matchRating = const Value.absent(),
    bool? isWinner,
  }) => Player(
    id: id ?? this.id,
    matchId: matchId ?? this.matchId,
    userId: userId ?? this.userId,
    score: score.present ? score.value : this.score,
    rank: rank.present ? rank.value : this.rank,
    matchRating: matchRating.present ? matchRating.value : this.matchRating,
    isWinner: isWinner ?? this.isWinner,
  );
  Player copyWithCompanion(PlayersCompanion data) {
    return Player(
      id: data.id.present ? data.id.value : this.id,
      matchId: data.matchId.present ? data.matchId.value : this.matchId,
      userId: data.userId.present ? data.userId.value : this.userId,
      score: data.score.present ? data.score.value : this.score,
      rank: data.rank.present ? data.rank.value : this.rank,
      matchRating: data.matchRating.present
          ? data.matchRating.value
          : this.matchRating,
      isWinner: data.isWinner.present ? data.isWinner.value : this.isWinner,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Player(')
          ..write('id: $id, ')
          ..write('matchId: $matchId, ')
          ..write('userId: $userId, ')
          ..write('score: $score, ')
          ..write('rank: $rank, ')
          ..write('matchRating: $matchRating, ')
          ..write('isWinner: $isWinner')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, matchId, userId, score, rank, matchRating, isWinner);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Player &&
          other.id == this.id &&
          other.matchId == this.matchId &&
          other.userId == this.userId &&
          other.score == this.score &&
          other.rank == this.rank &&
          other.matchRating == this.matchRating &&
          other.isWinner == this.isWinner);
}

class PlayersCompanion extends UpdateCompanion<Player> {
  final Value<int> id;
  final Value<int> matchId;
  final Value<int> userId;
  final Value<int?> score;
  final Value<int?> rank;
  final Value<double?> matchRating;
  final Value<bool> isWinner;
  const PlayersCompanion({
    this.id = const Value.absent(),
    this.matchId = const Value.absent(),
    this.userId = const Value.absent(),
    this.score = const Value.absent(),
    this.rank = const Value.absent(),
    this.matchRating = const Value.absent(),
    this.isWinner = const Value.absent(),
  });
  PlayersCompanion.insert({
    this.id = const Value.absent(),
    required int matchId,
    required int userId,
    this.score = const Value.absent(),
    this.rank = const Value.absent(),
    this.matchRating = const Value.absent(),
    this.isWinner = const Value.absent(),
  }) : matchId = Value(matchId),
       userId = Value(userId);
  static Insertable<Player> custom({
    Expression<int>? id,
    Expression<int>? matchId,
    Expression<int>? userId,
    Expression<int>? score,
    Expression<int>? rank,
    Expression<double>? matchRating,
    Expression<bool>? isWinner,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (matchId != null) 'match_id': matchId,
      if (userId != null) 'user_id': userId,
      if (score != null) 'score': score,
      if (rank != null) 'rank': rank,
      if (matchRating != null) 'match_rating': matchRating,
      if (isWinner != null) 'is_winner': isWinner,
    });
  }

  PlayersCompanion copyWith({
    Value<int>? id,
    Value<int>? matchId,
    Value<int>? userId,
    Value<int?>? score,
    Value<int?>? rank,
    Value<double?>? matchRating,
    Value<bool>? isWinner,
  }) {
    return PlayersCompanion(
      id: id ?? this.id,
      matchId: matchId ?? this.matchId,
      userId: userId ?? this.userId,
      score: score ?? this.score,
      rank: rank ?? this.rank,
      matchRating: matchRating ?? this.matchRating,
      isWinner: isWinner ?? this.isWinner,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (matchId.present) {
      map['match_id'] = Variable<int>(matchId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (rank.present) {
      map['rank'] = Variable<int>(rank.value);
    }
    if (matchRating.present) {
      map['match_rating'] = Variable<double>(matchRating.value);
    }
    if (isWinner.present) {
      map['is_winner'] = Variable<bool>(isWinner.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayersCompanion(')
          ..write('id: $id, ')
          ..write('matchId: $matchId, ')
          ..write('userId: $userId, ')
          ..write('score: $score, ')
          ..write('rank: $rank, ')
          ..write('matchRating: $matchRating, ')
          ..write('isWinner: $isWinner')
          ..write(')'))
        .toString();
  }
}

class $UserGameCollectionsTable extends UserGameCollections
    with TableInfo<$UserGameCollectionsTable, UserGameCollection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserGameCollectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<int> gameId = GeneratedColumn<int>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id)',
    ),
  );
  static const VerificationMeta _collectionTypeMeta = const VerificationMeta(
    'collectionType',
  );
  @override
  late final GeneratedColumn<String> collectionType = GeneratedColumn<String>(
    'collection_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    gameId,
    collectionType,
    addedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_game_collections';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserGameCollection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('collection_type')) {
      context.handle(
        _collectionTypeMeta,
        collectionType.isAcceptableOrUnknown(
          data['collection_type']!,
          _collectionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_collectionTypeMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {userId, gameId, collectionType},
  ];
  @override
  UserGameCollection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserGameCollection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
      collectionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}collection_type'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $UserGameCollectionsTable createAlias(String alias) {
    return $UserGameCollectionsTable(attachedDatabase, alias);
  }
}

class UserGameCollection extends DataClass
    implements Insertable<UserGameCollection> {
  final int id;
  final int userId;
  final int gameId;
  final String collectionType;
  final DateTime addedAt;
  const UserGameCollection({
    required this.id,
    required this.userId,
    required this.gameId,
    required this.collectionType,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['game_id'] = Variable<int>(gameId);
    map['collection_type'] = Variable<String>(collectionType);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  UserGameCollectionsCompanion toCompanion(bool nullToAbsent) {
    return UserGameCollectionsCompanion(
      id: Value(id),
      userId: Value(userId),
      gameId: Value(gameId),
      collectionType: Value(collectionType),
      addedAt: Value(addedAt),
    );
  }

  factory UserGameCollection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserGameCollection(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      gameId: serializer.fromJson<int>(json['gameId']),
      collectionType: serializer.fromJson<String>(json['collectionType']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'gameId': serializer.toJson<int>(gameId),
      'collectionType': serializer.toJson<String>(collectionType),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  UserGameCollection copyWith({
    int? id,
    int? userId,
    int? gameId,
    String? collectionType,
    DateTime? addedAt,
  }) => UserGameCollection(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    gameId: gameId ?? this.gameId,
    collectionType: collectionType ?? this.collectionType,
    addedAt: addedAt ?? this.addedAt,
  );
  UserGameCollection copyWithCompanion(UserGameCollectionsCompanion data) {
    return UserGameCollection(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      collectionType: data.collectionType.present
          ? data.collectionType.value
          : this.collectionType,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserGameCollection(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('gameId: $gameId, ')
          ..write('collectionType: $collectionType, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, gameId, collectionType, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserGameCollection &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.gameId == this.gameId &&
          other.collectionType == this.collectionType &&
          other.addedAt == this.addedAt);
}

class UserGameCollectionsCompanion extends UpdateCompanion<UserGameCollection> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> gameId;
  final Value<String> collectionType;
  final Value<DateTime> addedAt;
  const UserGameCollectionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.gameId = const Value.absent(),
    this.collectionType = const Value.absent(),
    this.addedAt = const Value.absent(),
  });
  UserGameCollectionsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int gameId,
    required String collectionType,
    required DateTime addedAt,
  }) : userId = Value(userId),
       gameId = Value(gameId),
       collectionType = Value(collectionType),
       addedAt = Value(addedAt);
  static Insertable<UserGameCollection> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? gameId,
    Expression<String>? collectionType,
    Expression<DateTime>? addedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (gameId != null) 'game_id': gameId,
      if (collectionType != null) 'collection_type': collectionType,
      if (addedAt != null) 'added_at': addedAt,
    });
  }

  UserGameCollectionsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<int>? gameId,
    Value<String>? collectionType,
    Value<DateTime>? addedAt,
  }) {
    return UserGameCollectionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      gameId: gameId ?? this.gameId,
      collectionType: collectionType ?? this.collectionType,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (collectionType.present) {
      map['collection_type'] = Variable<String>(collectionType.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserGameCollectionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('gameId: $gameId, ')
          ..write('collectionType: $collectionType, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }
}

class $FriendshipsTable extends Friendships
    with TableInfo<$FriendshipsTable, Friendship> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FriendshipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _friendIdMeta = const VerificationMeta(
    'friendId',
  );
  @override
  late final GeneratedColumn<int> friendId = GeneratedColumn<int>(
    'friend_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requestedAtMeta = const VerificationMeta(
    'requestedAt',
  );
  @override
  late final GeneratedColumn<DateTime> requestedAt = GeneratedColumn<DateTime>(
    'requested_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _respondedAtMeta = const VerificationMeta(
    'respondedAt',
  );
  @override
  late final GeneratedColumn<DateTime> respondedAt = GeneratedColumn<DateTime>(
    'responded_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    friendId,
    status,
    requestedAt,
    respondedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'friendships';
  @override
  VerificationContext validateIntegrity(
    Insertable<Friendship> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('friend_id')) {
      context.handle(
        _friendIdMeta,
        friendId.isAcceptableOrUnknown(data['friend_id']!, _friendIdMeta),
      );
    } else if (isInserting) {
      context.missing(_friendIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('requested_at')) {
      context.handle(
        _requestedAtMeta,
        requestedAt.isAcceptableOrUnknown(
          data['requested_at']!,
          _requestedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requestedAtMeta);
    }
    if (data.containsKey('responded_at')) {
      context.handle(
        _respondedAtMeta,
        respondedAt.isAcceptableOrUnknown(
          data['responded_at']!,
          _respondedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {userId, friendId},
  ];
  @override
  Friendship map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Friendship(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      friendId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}friend_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      requestedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}requested_at'],
      )!,
      respondedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}responded_at'],
      ),
    );
  }

  @override
  $FriendshipsTable createAlias(String alias) {
    return $FriendshipsTable(attachedDatabase, alias);
  }
}

class Friendship extends DataClass implements Insertable<Friendship> {
  final int id;
  final int userId;
  final int friendId;
  final String status;
  final DateTime requestedAt;
  final DateTime? respondedAt;
  const Friendship({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.status,
    required this.requestedAt,
    this.respondedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['friend_id'] = Variable<int>(friendId);
    map['status'] = Variable<String>(status);
    map['requested_at'] = Variable<DateTime>(requestedAt);
    if (!nullToAbsent || respondedAt != null) {
      map['responded_at'] = Variable<DateTime>(respondedAt);
    }
    return map;
  }

  FriendshipsCompanion toCompanion(bool nullToAbsent) {
    return FriendshipsCompanion(
      id: Value(id),
      userId: Value(userId),
      friendId: Value(friendId),
      status: Value(status),
      requestedAt: Value(requestedAt),
      respondedAt: respondedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(respondedAt),
    );
  }

  factory Friendship.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Friendship(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      friendId: serializer.fromJson<int>(json['friendId']),
      status: serializer.fromJson<String>(json['status']),
      requestedAt: serializer.fromJson<DateTime>(json['requestedAt']),
      respondedAt: serializer.fromJson<DateTime?>(json['respondedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'friendId': serializer.toJson<int>(friendId),
      'status': serializer.toJson<String>(status),
      'requestedAt': serializer.toJson<DateTime>(requestedAt),
      'respondedAt': serializer.toJson<DateTime?>(respondedAt),
    };
  }

  Friendship copyWith({
    int? id,
    int? userId,
    int? friendId,
    String? status,
    DateTime? requestedAt,
    Value<DateTime?> respondedAt = const Value.absent(),
  }) => Friendship(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    friendId: friendId ?? this.friendId,
    status: status ?? this.status,
    requestedAt: requestedAt ?? this.requestedAt,
    respondedAt: respondedAt.present ? respondedAt.value : this.respondedAt,
  );
  Friendship copyWithCompanion(FriendshipsCompanion data) {
    return Friendship(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      friendId: data.friendId.present ? data.friendId.value : this.friendId,
      status: data.status.present ? data.status.value : this.status,
      requestedAt: data.requestedAt.present
          ? data.requestedAt.value
          : this.requestedAt,
      respondedAt: data.respondedAt.present
          ? data.respondedAt.value
          : this.respondedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Friendship(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('friendId: $friendId, ')
          ..write('status: $status, ')
          ..write('requestedAt: $requestedAt, ')
          ..write('respondedAt: $respondedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, friendId, status, requestedAt, respondedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Friendship &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.friendId == this.friendId &&
          other.status == this.status &&
          other.requestedAt == this.requestedAt &&
          other.respondedAt == this.respondedAt);
}

class FriendshipsCompanion extends UpdateCompanion<Friendship> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> friendId;
  final Value<String> status;
  final Value<DateTime> requestedAt;
  final Value<DateTime?> respondedAt;
  const FriendshipsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.friendId = const Value.absent(),
    this.status = const Value.absent(),
    this.requestedAt = const Value.absent(),
    this.respondedAt = const Value.absent(),
  });
  FriendshipsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int friendId,
    required String status,
    required DateTime requestedAt,
    this.respondedAt = const Value.absent(),
  }) : userId = Value(userId),
       friendId = Value(friendId),
       status = Value(status),
       requestedAt = Value(requestedAt);
  static Insertable<Friendship> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? friendId,
    Expression<String>? status,
    Expression<DateTime>? requestedAt,
    Expression<DateTime>? respondedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (friendId != null) 'friend_id': friendId,
      if (status != null) 'status': status,
      if (requestedAt != null) 'requested_at': requestedAt,
      if (respondedAt != null) 'responded_at': respondedAt,
    });
  }

  FriendshipsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<int>? friendId,
    Value<String>? status,
    Value<DateTime>? requestedAt,
    Value<DateTime?>? respondedAt,
  }) {
    return FriendshipsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      friendId: friendId ?? this.friendId,
      status: status ?? this.status,
      requestedAt: requestedAt ?? this.requestedAt,
      respondedAt: respondedAt ?? this.respondedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (friendId.present) {
      map['friend_id'] = Variable<int>(friendId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (requestedAt.present) {
      map['requested_at'] = Variable<DateTime>(requestedAt.value);
    }
    if (respondedAt.present) {
      map['responded_at'] = Variable<DateTime>(respondedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FriendshipsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('friendId: $friendId, ')
          ..write('status: $status, ')
          ..write('requestedAt: $requestedAt, ')
          ..write('respondedAt: $respondedAt')
          ..write(')'))
        .toString();
  }
}

class $NotificationsTable extends Notifications
    with TableInfo<$NotificationsTable, Notification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relatedIdMeta = const VerificationMeta(
    'relatedId',
  );
  @override
  late final GeneratedColumn<int> relatedId = GeneratedColumn<int>(
    'related_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    type,
    title,
    message,
    relatedId,
    isRead,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<Notification> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('related_id')) {
      context.handle(
        _relatedIdMeta,
        relatedId.isAcceptableOrUnknown(data['related_id']!, _relatedIdMeta),
      );
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Notification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Notification(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      relatedId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}related_id'],
      ),
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_read'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $NotificationsTable createAlias(String alias) {
    return $NotificationsTable(attachedDatabase, alias);
  }
}

class Notification extends DataClass implements Insertable<Notification> {
  final int id;
  final int userId;
  final String type;
  final String title;
  final String message;
  final int? relatedId;
  final bool isRead;
  final DateTime createdAt;
  const Notification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.relatedId,
    required this.isRead,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    map['message'] = Variable<String>(message);
    if (!nullToAbsent || relatedId != null) {
      map['related_id'] = Variable<int>(relatedId);
    }
    map['is_read'] = Variable<bool>(isRead);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  NotificationsCompanion toCompanion(bool nullToAbsent) {
    return NotificationsCompanion(
      id: Value(id),
      userId: Value(userId),
      type: Value(type),
      title: Value(title),
      message: Value(message),
      relatedId: relatedId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedId),
      isRead: Value(isRead),
      createdAt: Value(createdAt),
    );
  }

  factory Notification.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Notification(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      message: serializer.fromJson<String>(json['message']),
      relatedId: serializer.fromJson<int?>(json['relatedId']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'message': serializer.toJson<String>(message),
      'relatedId': serializer.toJson<int?>(relatedId),
      'isRead': serializer.toJson<bool>(isRead),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Notification copyWith({
    int? id,
    int? userId,
    String? type,
    String? title,
    String? message,
    Value<int?> relatedId = const Value.absent(),
    bool? isRead,
    DateTime? createdAt,
  }) => Notification(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    type: type ?? this.type,
    title: title ?? this.title,
    message: message ?? this.message,
    relatedId: relatedId.present ? relatedId.value : this.relatedId,
    isRead: isRead ?? this.isRead,
    createdAt: createdAt ?? this.createdAt,
  );
  Notification copyWithCompanion(NotificationsCompanion data) {
    return Notification(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      message: data.message.present ? data.message.value : this.message,
      relatedId: data.relatedId.present ? data.relatedId.value : this.relatedId,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Notification(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('message: $message, ')
          ..write('relatedId: $relatedId, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    type,
    title,
    message,
    relatedId,
    isRead,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Notification &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.type == this.type &&
          other.title == this.title &&
          other.message == this.message &&
          other.relatedId == this.relatedId &&
          other.isRead == this.isRead &&
          other.createdAt == this.createdAt);
}

class NotificationsCompanion extends UpdateCompanion<Notification> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> type;
  final Value<String> title;
  final Value<String> message;
  final Value<int?> relatedId;
  final Value<bool> isRead;
  final Value<DateTime> createdAt;
  const NotificationsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.message = const Value.absent(),
    this.relatedId = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  NotificationsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String type,
    required String title,
    required String message,
    this.relatedId = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : userId = Value(userId),
       type = Value(type),
       title = Value(title),
       message = Value(message);
  static Insertable<Notification> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? message,
    Expression<int>? relatedId,
    Expression<bool>? isRead,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (message != null) 'message': message,
      if (relatedId != null) 'related_id': relatedId,
      if (isRead != null) 'is_read': isRead,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  NotificationsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? type,
    Value<String>? title,
    Value<String>? message,
    Value<int?>? relatedId,
    Value<bool>? isRead,
    Value<DateTime>? createdAt,
  }) {
    return NotificationsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      relatedId: relatedId ?? this.relatedId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (relatedId.present) {
      map['related_id'] = Variable<int>(relatedId.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('message: $message, ')
          ..write('relatedId: $relatedId, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ReviewsTable extends Reviews with TableInfo<$ReviewsTable, Review> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<int> gameId = GeneratedColumn<int>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id)',
    ),
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
    'rating',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    gameId,
    rating,
    comment,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reviews';
  @override
  VerificationContext validateIntegrity(
    Insertable<Review> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {userId, gameId},
  ];
  @override
  Review map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Review(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating'],
      )!,
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ReviewsTable createAlias(String alias) {
    return $ReviewsTable(attachedDatabase, alias);
  }
}

class Review extends DataClass implements Insertable<Review> {
  final int id;
  final int userId;
  final int gameId;
  final double rating;
  final String? comment;
  final DateTime createdAt;
  const Review({
    required this.id,
    required this.userId,
    required this.gameId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['game_id'] = Variable<int>(gameId);
    map['rating'] = Variable<double>(rating);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReviewsCompanion toCompanion(bool nullToAbsent) {
    return ReviewsCompanion(
      id: Value(id),
      userId: Value(userId),
      gameId: Value(gameId),
      rating: Value(rating),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      createdAt: Value(createdAt),
    );
  }

  factory Review.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Review(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      gameId: serializer.fromJson<int>(json['gameId']),
      rating: serializer.fromJson<double>(json['rating']),
      comment: serializer.fromJson<String?>(json['comment']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'gameId': serializer.toJson<int>(gameId),
      'rating': serializer.toJson<double>(rating),
      'comment': serializer.toJson<String?>(comment),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Review copyWith({
    int? id,
    int? userId,
    int? gameId,
    double? rating,
    Value<String?> comment = const Value.absent(),
    DateTime? createdAt,
  }) => Review(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    gameId: gameId ?? this.gameId,
    rating: rating ?? this.rating,
    comment: comment.present ? comment.value : this.comment,
    createdAt: createdAt ?? this.createdAt,
  );
  Review copyWithCompanion(ReviewsCompanion data) {
    return Review(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      rating: data.rating.present ? data.rating.value : this.rating,
      comment: data.comment.present ? data.comment.value : this.comment,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Review(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('gameId: $gameId, ')
          ..write('rating: $rating, ')
          ..write('comment: $comment, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, gameId, rating, comment, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Review &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.gameId == this.gameId &&
          other.rating == this.rating &&
          other.comment == this.comment &&
          other.createdAt == this.createdAt);
}

class ReviewsCompanion extends UpdateCompanion<Review> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> gameId;
  final Value<double> rating;
  final Value<String?> comment;
  final Value<DateTime> createdAt;
  const ReviewsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.gameId = const Value.absent(),
    this.rating = const Value.absent(),
    this.comment = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ReviewsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int gameId,
    required double rating,
    this.comment = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : userId = Value(userId),
       gameId = Value(gameId),
       rating = Value(rating);
  static Insertable<Review> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? gameId,
    Expression<double>? rating,
    Expression<String>? comment,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (gameId != null) 'game_id': gameId,
      if (rating != null) 'rating': rating,
      if (comment != null) 'comment': comment,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ReviewsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<int>? gameId,
    Value<double>? rating,
    Value<String?>? comment,
    Value<DateTime>? createdAt,
  }) {
    return ReviewsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      gameId: gameId ?? this.gameId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('gameId: $gameId, ')
          ..write('rating: $rating, ')
          ..write('comment: $comment, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UserAchievementsTable extends UserAchievements
    with TableInfo<$UserAchievementsTable, UserAchievement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserAchievementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _achievementIdMeta = const VerificationMeta(
    'achievementId',
  );
  @override
  late final GeneratedColumn<String> achievementId = GeneratedColumn<String>(
    'achievement_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unlockedAtMeta = const VerificationMeta(
    'unlockedAt',
  );
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
    'unlocked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, userId, achievementId, unlockedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_achievements';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserAchievement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('achievement_id')) {
      context.handle(
        _achievementIdMeta,
        achievementId.isAcceptableOrUnknown(
          data['achievement_id']!,
          _achievementIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_achievementIdMeta);
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
        _unlockedAtMeta,
        unlockedAt.isAcceptableOrUnknown(data['unlocked_at']!, _unlockedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {userId, achievementId},
  ];
  @override
  UserAchievement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserAchievement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      achievementId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}achievement_id'],
      )!,
      unlockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}unlocked_at'],
      )!,
    );
  }

  @override
  $UserAchievementsTable createAlias(String alias) {
    return $UserAchievementsTable(attachedDatabase, alias);
  }
}

class UserAchievement extends DataClass implements Insertable<UserAchievement> {
  final int id;
  final int userId;
  final String achievementId;
  final DateTime unlockedAt;
  const UserAchievement({
    required this.id,
    required this.userId,
    required this.achievementId,
    required this.unlockedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['achievement_id'] = Variable<String>(achievementId);
    map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    return map;
  }

  UserAchievementsCompanion toCompanion(bool nullToAbsent) {
    return UserAchievementsCompanion(
      id: Value(id),
      userId: Value(userId),
      achievementId: Value(achievementId),
      unlockedAt: Value(unlockedAt),
    );
  }

  factory UserAchievement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserAchievement(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      achievementId: serializer.fromJson<String>(json['achievementId']),
      unlockedAt: serializer.fromJson<DateTime>(json['unlockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'achievementId': serializer.toJson<String>(achievementId),
      'unlockedAt': serializer.toJson<DateTime>(unlockedAt),
    };
  }

  UserAchievement copyWith({
    int? id,
    int? userId,
    String? achievementId,
    DateTime? unlockedAt,
  }) => UserAchievement(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    achievementId: achievementId ?? this.achievementId,
    unlockedAt: unlockedAt ?? this.unlockedAt,
  );
  UserAchievement copyWithCompanion(UserAchievementsCompanion data) {
    return UserAchievement(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      achievementId: data.achievementId.present
          ? data.achievementId.value
          : this.achievementId,
      unlockedAt: data.unlockedAt.present
          ? data.unlockedAt.value
          : this.unlockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserAchievement(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('achievementId: $achievementId, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, achievementId, unlockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserAchievement &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.achievementId == this.achievementId &&
          other.unlockedAt == this.unlockedAt);
}

class UserAchievementsCompanion extends UpdateCompanion<UserAchievement> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> achievementId;
  final Value<DateTime> unlockedAt;
  const UserAchievementsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.achievementId = const Value.absent(),
    this.unlockedAt = const Value.absent(),
  });
  UserAchievementsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String achievementId,
    this.unlockedAt = const Value.absent(),
  }) : userId = Value(userId),
       achievementId = Value(achievementId);
  static Insertable<UserAchievement> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? achievementId,
    Expression<DateTime>? unlockedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (achievementId != null) 'achievement_id': achievementId,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
    });
  }

  UserAchievementsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? achievementId,
    Value<DateTime>? unlockedAt,
  }) {
    return UserAchievementsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      achievementId: achievementId ?? this.achievementId,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (achievementId.present) {
      map['achievement_id'] = Variable<String>(achievementId.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserAchievementsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('achievementId: $achievementId, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $GamesTable games = $GamesTable(this);
  late final $MatchesTable matches = $MatchesTable(this);
  late final $PlayersTable players = $PlayersTable(this);
  late final $UserGameCollectionsTable userGameCollections =
      $UserGameCollectionsTable(this);
  late final $FriendshipsTable friendships = $FriendshipsTable(this);
  late final $NotificationsTable notifications = $NotificationsTable(this);
  late final $ReviewsTable reviews = $ReviewsTable(this);
  late final $UserAchievementsTable userAchievements = $UserAchievementsTable(
    this,
  );
  late final UsersDao usersDao = UsersDao(this as AppDatabase);
  late final GamesDao gamesDao = GamesDao(this as AppDatabase);
  late final MatchesDao matchesDao = MatchesDao(this as AppDatabase);
  late final UserGameCollectionsDao userGameCollectionsDao =
      UserGameCollectionsDao(this as AppDatabase);
  late final FriendshipsDao friendshipsDao = FriendshipsDao(
    this as AppDatabase,
  );
  late final NotificationsDao notificationsDao = NotificationsDao(
    this as AppDatabase,
  );
  late final ReviewsDao reviewsDao = ReviewsDao(this as AppDatabase);
  late final UserAchievementsDao userAchievementsDao = UserAchievementsDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    games,
    matches,
    players,
    userGameCollections,
    friendships,
    notifications,
    reviews,
    userAchievements,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      required String username,
      required String email,
      required String password,
      Value<String?> firstName,
      Value<String?> lastName,
      Value<String?> phone,
      Value<String?> country,
      Value<DateTime?> birthDate,
      Value<String?> avatarUrl,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<int> xp,
      Value<int> prestige,
      Value<String?> title,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String> username,
      Value<String> email,
      Value<String> password,
      Value<String?> firstName,
      Value<String?> lastName,
      Value<String?> phone,
      Value<String?> country,
      Value<DateTime?> birthDate,
      Value<String?> avatarUrl,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<int> xp,
      Value<int> prestige,
      Value<String?> title,
    });

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MatchesTable, List<MatchRow>>
  _createdMatchesTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.matches,
    aliasName: $_aliasNameGenerator(db.users.id, db.matches.creatorId),
  );

  $$MatchesTableProcessedTableManager get createdMatches {
    final manager = $$MatchesTableTableManager(
      $_db,
      $_db.matches,
    ).filter((f) => f.creatorId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_createdMatchesTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlayersTable, List<Player>> _playersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.players,
    aliasName: $_aliasNameGenerator(db.users.id, db.players.userId),
  );

  $$PlayersTableProcessedTableManager get playersRefs {
    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_playersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $UserGameCollectionsTable,
    List<UserGameCollection>
  >
  _userGameCollectionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.userGameCollections,
        aliasName: $_aliasNameGenerator(
          db.users.id,
          db.userGameCollections.userId,
        ),
      );

  $$UserGameCollectionsTableProcessedTableManager get userGameCollectionsRefs {
    final manager = $$UserGameCollectionsTableTableManager(
      $_db,
      $_db.userGameCollections,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _userGameCollectionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FriendshipsTable, List<Friendship>>
  _sentFriendshipsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.friendships,
    aliasName: $_aliasNameGenerator(db.users.id, db.friendships.userId),
  );

  $$FriendshipsTableProcessedTableManager get sentFriendships {
    final manager = $$FriendshipsTableTableManager(
      $_db,
      $_db.friendships,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sentFriendshipsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FriendshipsTable, List<Friendship>>
  _receivedFriendshipsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.friendships,
    aliasName: $_aliasNameGenerator(db.users.id, db.friendships.friendId),
  );

  $$FriendshipsTableProcessedTableManager get receivedFriendships {
    final manager = $$FriendshipsTableTableManager(
      $_db,
      $_db.friendships,
    ).filter((f) => f.friendId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _receivedFriendshipsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$NotificationsTable, List<Notification>>
  _notificationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.notifications,
    aliasName: $_aliasNameGenerator(db.users.id, db.notifications.userId),
  );

  $$NotificationsTableProcessedTableManager get notificationsRefs {
    final manager = $$NotificationsTableTableManager(
      $_db,
      $_db.notifications,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_notificationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReviewsTable, List<Review>> _reviewsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.reviews,
    aliasName: $_aliasNameGenerator(db.users.id, db.reviews.userId),
  );

  $$ReviewsTableProcessedTableManager get reviewsRefs {
    final manager = $$ReviewsTableTableManager(
      $_db,
      $_db.reviews,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_reviewsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$UserAchievementsTable, List<UserAchievement>>
  _userAchievementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userAchievements,
    aliasName: $_aliasNameGenerator(db.users.id, db.userAchievements.userId),
  );

  $$UserAchievementsTableProcessedTableManager get userAchievementsRefs {
    final manager = $$UserAchievementsTableTableManager(
      $_db,
      $_db.userAchievements,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _userAchievementsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get prestige => $composableBuilder(
    column: $table.prestige,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> createdMatches(
    Expression<bool> Function($$MatchesTableFilterComposer f) f,
  ) {
    final $$MatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matches,
      getReferencedColumn: (t) => t.creatorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchesTableFilterComposer(
            $db: $db,
            $table: $db.matches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> playersRefs(
    Expression<bool> Function($$PlayersTableFilterComposer f) f,
  ) {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> userGameCollectionsRefs(
    Expression<bool> Function($$UserGameCollectionsTableFilterComposer f) f,
  ) {
    final $$UserGameCollectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userGameCollections,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserGameCollectionsTableFilterComposer(
            $db: $db,
            $table: $db.userGameCollections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sentFriendships(
    Expression<bool> Function($$FriendshipsTableFilterComposer f) f,
  ) {
    final $$FriendshipsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.friendships,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FriendshipsTableFilterComposer(
            $db: $db,
            $table: $db.friendships,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> receivedFriendships(
    Expression<bool> Function($$FriendshipsTableFilterComposer f) f,
  ) {
    final $$FriendshipsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.friendships,
      getReferencedColumn: (t) => t.friendId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FriendshipsTableFilterComposer(
            $db: $db,
            $table: $db.friendships,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> notificationsRefs(
    Expression<bool> Function($$NotificationsTableFilterComposer f) f,
  ) {
    final $$NotificationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notifications,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotificationsTableFilterComposer(
            $db: $db,
            $table: $db.notifications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reviewsRefs(
    Expression<bool> Function($$ReviewsTableFilterComposer f) f,
  ) {
    final $$ReviewsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviews,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewsTableFilterComposer(
            $db: $db,
            $table: $db.reviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> userAchievementsRefs(
    Expression<bool> Function($$UserAchievementsTableFilterComposer f) f,
  ) {
    final $$UserAchievementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userAchievements,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserAchievementsTableFilterComposer(
            $db: $db,
            $table: $db.userAchievements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prestige => $composableBuilder(
    column: $table.prestige,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<int> get xp =>
      $composableBuilder(column: $table.xp, builder: (column) => column);

  GeneratedColumn<int> get prestige =>
      $composableBuilder(column: $table.prestige, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  Expression<T> createdMatches<T extends Object>(
    Expression<T> Function($$MatchesTableAnnotationComposer a) f,
  ) {
    final $$MatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matches,
      getReferencedColumn: (t) => t.creatorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.matches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> playersRefs<T extends Object>(
    Expression<T> Function($$PlayersTableAnnotationComposer a) f,
  ) {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> userGameCollectionsRefs<T extends Object>(
    Expression<T> Function($$UserGameCollectionsTableAnnotationComposer a) f,
  ) {
    final $$UserGameCollectionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.userGameCollections,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserGameCollectionsTableAnnotationComposer(
                $db: $db,
                $table: $db.userGameCollections,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> sentFriendships<T extends Object>(
    Expression<T> Function($$FriendshipsTableAnnotationComposer a) f,
  ) {
    final $$FriendshipsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.friendships,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FriendshipsTableAnnotationComposer(
            $db: $db,
            $table: $db.friendships,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> receivedFriendships<T extends Object>(
    Expression<T> Function($$FriendshipsTableAnnotationComposer a) f,
  ) {
    final $$FriendshipsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.friendships,
      getReferencedColumn: (t) => t.friendId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FriendshipsTableAnnotationComposer(
            $db: $db,
            $table: $db.friendships,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> notificationsRefs<T extends Object>(
    Expression<T> Function($$NotificationsTableAnnotationComposer a) f,
  ) {
    final $$NotificationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notifications,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotificationsTableAnnotationComposer(
            $db: $db,
            $table: $db.notifications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> reviewsRefs<T extends Object>(
    Expression<T> Function($$ReviewsTableAnnotationComposer a) f,
  ) {
    final $$ReviewsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviews,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewsTableAnnotationComposer(
            $db: $db,
            $table: $db.reviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> userAchievementsRefs<T extends Object>(
    Expression<T> Function($$UserAchievementsTableAnnotationComposer a) f,
  ) {
    final $$UserAchievementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userAchievements,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserAchievementsTableAnnotationComposer(
            $db: $db,
            $table: $db.userAchievements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, $$UsersTableReferences),
          User,
          PrefetchHooks Function({
            bool createdMatches,
            bool playersRefs,
            bool userGameCollectionsRefs,
            bool sentFriendships,
            bool receivedFriendships,
            bool notificationsRefs,
            bool reviewsRefs,
            bool userAchievementsRefs,
          })
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> password = const Value.absent(),
                Value<String?> firstName = const Value.absent(),
                Value<String?> lastName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<int> prestige = const Value.absent(),
                Value<String?> title = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                username: username,
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName,
                phone: phone,
                country: country,
                birthDate: birthDate,
                avatarUrl: avatarUrl,
                latitude: latitude,
                longitude: longitude,
                xp: xp,
                prestige: prestige,
                title: title,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String username,
                required String email,
                required String password,
                Value<String?> firstName = const Value.absent(),
                Value<String?> lastName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<int> prestige = const Value.absent(),
                Value<String?> title = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                username: username,
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName,
                phone: phone,
                country: country,
                birthDate: birthDate,
                avatarUrl: avatarUrl,
                latitude: latitude,
                longitude: longitude,
                xp: xp,
                prestige: prestige,
                title: title,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UsersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                createdMatches = false,
                playersRefs = false,
                userGameCollectionsRefs = false,
                sentFriendships = false,
                receivedFriendships = false,
                notificationsRefs = false,
                reviewsRefs = false,
                userAchievementsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (createdMatches) db.matches,
                    if (playersRefs) db.players,
                    if (userGameCollectionsRefs) db.userGameCollections,
                    if (sentFriendships) db.friendships,
                    if (receivedFriendships) db.friendships,
                    if (notificationsRefs) db.notifications,
                    if (reviewsRefs) db.reviews,
                    if (userAchievementsRefs) db.userAchievements,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (createdMatches)
                        await $_getPrefetchedData<User, $UsersTable, MatchRow>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._createdMatchesTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).createdMatches,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.creatorId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (playersRefs)
                        await $_getPrefetchedData<User, $UsersTable, Player>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._playersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(db, table, p0).playersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (userGameCollectionsRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          UserGameCollection
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._userGameCollectionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).userGameCollectionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sentFriendships)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          Friendship
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._sentFriendshipsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).sentFriendships,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (receivedFriendships)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          Friendship
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._receivedFriendshipsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).receivedFriendships,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.friendId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (notificationsRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          Notification
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._notificationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).notificationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (reviewsRefs)
                        await $_getPrefetchedData<User, $UsersTable, Review>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._reviewsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(db, table, p0).reviewsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (userAchievementsRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          UserAchievement
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._userAchievementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).userAchievementsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, $$UsersTableReferences),
      User,
      PrefetchHooks Function({
        bool createdMatches,
        bool playersRefs,
        bool userGameCollectionsRefs,
        bool sentFriendships,
        bool receivedFriendships,
        bool notificationsRefs,
        bool reviewsRefs,
        bool userAchievementsRefs,
      })
    >;
typedef $$GamesTableCreateCompanionBuilder =
    GamesCompanion Function({
      Value<int> id,
      Value<int?> bggId,
      required String name,
      Value<String?> description,
      Value<String?> imageUrl,
      Value<int?> minPlayers,
      Value<int?> maxPlayers,
      Value<int?> yearPublished,
      Value<int?> rank,
      Value<double?> rating,
      Value<bool> isEnriched,
      Value<int?> minPlaytime,
      Value<int?> maxPlaytime,
      Value<int?> minAge,
      Value<String?> categories,
      Value<String?> mechanics,
      Value<String?> type,
      Value<String?> families,
      Value<String?> integrations,
      Value<String?> reimplementations,
    });
typedef $$GamesTableUpdateCompanionBuilder =
    GamesCompanion Function({
      Value<int> id,
      Value<int?> bggId,
      Value<String> name,
      Value<String?> description,
      Value<String?> imageUrl,
      Value<int?> minPlayers,
      Value<int?> maxPlayers,
      Value<int?> yearPublished,
      Value<int?> rank,
      Value<double?> rating,
      Value<bool> isEnriched,
      Value<int?> minPlaytime,
      Value<int?> maxPlaytime,
      Value<int?> minAge,
      Value<String?> categories,
      Value<String?> mechanics,
      Value<String?> type,
      Value<String?> families,
      Value<String?> integrations,
      Value<String?> reimplementations,
    });

final class $$GamesTableReferences
    extends BaseReferences<_$AppDatabase, $GamesTable, Game> {
  $$GamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MatchesTable, List<MatchRow>> _matchesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.matches,
    aliasName: $_aliasNameGenerator(db.games.id, db.matches.gameId),
  );

  $$MatchesTableProcessedTableManager get matchesRefs {
    final manager = $$MatchesTableTableManager(
      $_db,
      $_db.matches,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_matchesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $UserGameCollectionsTable,
    List<UserGameCollection>
  >
  _userGameCollectionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.userGameCollections,
        aliasName: $_aliasNameGenerator(
          db.games.id,
          db.userGameCollections.gameId,
        ),
      );

  $$UserGameCollectionsTableProcessedTableManager get userGameCollectionsRefs {
    final manager = $$UserGameCollectionsTableTableManager(
      $_db,
      $_db.userGameCollections,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _userGameCollectionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReviewsTable, List<Review>> _reviewsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.reviews,
    aliasName: $_aliasNameGenerator(db.games.id, db.reviews.gameId),
  );

  $$ReviewsTableProcessedTableManager get reviewsRefs {
    final manager = $$ReviewsTableTableManager(
      $_db,
      $_db.reviews,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_reviewsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GamesTableFilterComposer extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bggId => $composableBuilder(
    column: $table.bggId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minPlayers => $composableBuilder(
    column: $table.minPlayers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxPlayers => $composableBuilder(
    column: $table.maxPlayers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get yearPublished => $composableBuilder(
    column: $table.yearPublished,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnriched => $composableBuilder(
    column: $table.isEnriched,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minPlaytime => $composableBuilder(
    column: $table.minPlaytime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxPlaytime => $composableBuilder(
    column: $table.maxPlaytime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minAge => $composableBuilder(
    column: $table.minAge,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categories => $composableBuilder(
    column: $table.categories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mechanics => $composableBuilder(
    column: $table.mechanics,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get families => $composableBuilder(
    column: $table.families,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get integrations => $composableBuilder(
    column: $table.integrations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reimplementations => $composableBuilder(
    column: $table.reimplementations,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> matchesRefs(
    Expression<bool> Function($$MatchesTableFilterComposer f) f,
  ) {
    final $$MatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matches,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchesTableFilterComposer(
            $db: $db,
            $table: $db.matches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> userGameCollectionsRefs(
    Expression<bool> Function($$UserGameCollectionsTableFilterComposer f) f,
  ) {
    final $$UserGameCollectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userGameCollections,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserGameCollectionsTableFilterComposer(
            $db: $db,
            $table: $db.userGameCollections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reviewsRefs(
    Expression<bool> Function($$ReviewsTableFilterComposer f) f,
  ) {
    final $$ReviewsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviews,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewsTableFilterComposer(
            $db: $db,
            $table: $db.reviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GamesTableOrderingComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bggId => $composableBuilder(
    column: $table.bggId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minPlayers => $composableBuilder(
    column: $table.minPlayers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxPlayers => $composableBuilder(
    column: $table.maxPlayers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get yearPublished => $composableBuilder(
    column: $table.yearPublished,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnriched => $composableBuilder(
    column: $table.isEnriched,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minPlaytime => $composableBuilder(
    column: $table.minPlaytime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxPlaytime => $composableBuilder(
    column: $table.maxPlaytime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minAge => $composableBuilder(
    column: $table.minAge,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categories => $composableBuilder(
    column: $table.categories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mechanics => $composableBuilder(
    column: $table.mechanics,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get families => $composableBuilder(
    column: $table.families,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get integrations => $composableBuilder(
    column: $table.integrations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reimplementations => $composableBuilder(
    column: $table.reimplementations,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get bggId =>
      $composableBuilder(column: $table.bggId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<int> get minPlayers => $composableBuilder(
    column: $table.minPlayers,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxPlayers => $composableBuilder(
    column: $table.maxPlayers,
    builder: (column) => column,
  );

  GeneratedColumn<int> get yearPublished => $composableBuilder(
    column: $table.yearPublished,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rank =>
      $composableBuilder(column: $table.rank, builder: (column) => column);

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<bool> get isEnriched => $composableBuilder(
    column: $table.isEnriched,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minPlaytime => $composableBuilder(
    column: $table.minPlaytime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxPlaytime => $composableBuilder(
    column: $table.maxPlaytime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minAge =>
      $composableBuilder(column: $table.minAge, builder: (column) => column);

  GeneratedColumn<String> get categories => $composableBuilder(
    column: $table.categories,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mechanics =>
      $composableBuilder(column: $table.mechanics, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get families =>
      $composableBuilder(column: $table.families, builder: (column) => column);

  GeneratedColumn<String> get integrations => $composableBuilder(
    column: $table.integrations,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reimplementations => $composableBuilder(
    column: $table.reimplementations,
    builder: (column) => column,
  );

  Expression<T> matchesRefs<T extends Object>(
    Expression<T> Function($$MatchesTableAnnotationComposer a) f,
  ) {
    final $$MatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matches,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.matches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> userGameCollectionsRefs<T extends Object>(
    Expression<T> Function($$UserGameCollectionsTableAnnotationComposer a) f,
  ) {
    final $$UserGameCollectionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.userGameCollections,
          getReferencedColumn: (t) => t.gameId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserGameCollectionsTableAnnotationComposer(
                $db: $db,
                $table: $db.userGameCollections,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> reviewsRefs<T extends Object>(
    Expression<T> Function($$ReviewsTableAnnotationComposer a) f,
  ) {
    final $$ReviewsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviews,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewsTableAnnotationComposer(
            $db: $db,
            $table: $db.reviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamesTable,
          Game,
          $$GamesTableFilterComposer,
          $$GamesTableOrderingComposer,
          $$GamesTableAnnotationComposer,
          $$GamesTableCreateCompanionBuilder,
          $$GamesTableUpdateCompanionBuilder,
          (Game, $$GamesTableReferences),
          Game,
          PrefetchHooks Function({
            bool matchesRefs,
            bool userGameCollectionsRefs,
            bool reviewsRefs,
          })
        > {
  $$GamesTableTableManager(_$AppDatabase db, $GamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> bggId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int?> minPlayers = const Value.absent(),
                Value<int?> maxPlayers = const Value.absent(),
                Value<int?> yearPublished = const Value.absent(),
                Value<int?> rank = const Value.absent(),
                Value<double?> rating = const Value.absent(),
                Value<bool> isEnriched = const Value.absent(),
                Value<int?> minPlaytime = const Value.absent(),
                Value<int?> maxPlaytime = const Value.absent(),
                Value<int?> minAge = const Value.absent(),
                Value<String?> categories = const Value.absent(),
                Value<String?> mechanics = const Value.absent(),
                Value<String?> type = const Value.absent(),
                Value<String?> families = const Value.absent(),
                Value<String?> integrations = const Value.absent(),
                Value<String?> reimplementations = const Value.absent(),
              }) => GamesCompanion(
                id: id,
                bggId: bggId,
                name: name,
                description: description,
                imageUrl: imageUrl,
                minPlayers: minPlayers,
                maxPlayers: maxPlayers,
                yearPublished: yearPublished,
                rank: rank,
                rating: rating,
                isEnriched: isEnriched,
                minPlaytime: minPlaytime,
                maxPlaytime: maxPlaytime,
                minAge: minAge,
                categories: categories,
                mechanics: mechanics,
                type: type,
                families: families,
                integrations: integrations,
                reimplementations: reimplementations,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> bggId = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int?> minPlayers = const Value.absent(),
                Value<int?> maxPlayers = const Value.absent(),
                Value<int?> yearPublished = const Value.absent(),
                Value<int?> rank = const Value.absent(),
                Value<double?> rating = const Value.absent(),
                Value<bool> isEnriched = const Value.absent(),
                Value<int?> minPlaytime = const Value.absent(),
                Value<int?> maxPlaytime = const Value.absent(),
                Value<int?> minAge = const Value.absent(),
                Value<String?> categories = const Value.absent(),
                Value<String?> mechanics = const Value.absent(),
                Value<String?> type = const Value.absent(),
                Value<String?> families = const Value.absent(),
                Value<String?> integrations = const Value.absent(),
                Value<String?> reimplementations = const Value.absent(),
              }) => GamesCompanion.insert(
                id: id,
                bggId: bggId,
                name: name,
                description: description,
                imageUrl: imageUrl,
                minPlayers: minPlayers,
                maxPlayers: maxPlayers,
                yearPublished: yearPublished,
                rank: rank,
                rating: rating,
                isEnriched: isEnriched,
                minPlaytime: minPlaytime,
                maxPlaytime: maxPlaytime,
                minAge: minAge,
                categories: categories,
                mechanics: mechanics,
                type: type,
                families: families,
                integrations: integrations,
                reimplementations: reimplementations,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GamesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                matchesRefs = false,
                userGameCollectionsRefs = false,
                reviewsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (matchesRefs) db.matches,
                    if (userGameCollectionsRefs) db.userGameCollections,
                    if (reviewsRefs) db.reviews,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (matchesRefs)
                        await $_getPrefetchedData<Game, $GamesTable, MatchRow>(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._matchesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(db, table, p0).matchesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (userGameCollectionsRefs)
                        await $_getPrefetchedData<
                          Game,
                          $GamesTable,
                          UserGameCollection
                        >(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._userGameCollectionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(
                                db,
                                table,
                                p0,
                              ).userGameCollectionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (reviewsRefs)
                        await $_getPrefetchedData<Game, $GamesTable, Review>(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._reviewsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(db, table, p0).reviewsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamesTable,
      Game,
      $$GamesTableFilterComposer,
      $$GamesTableOrderingComposer,
      $$GamesTableAnnotationComposer,
      $$GamesTableCreateCompanionBuilder,
      $$GamesTableUpdateCompanionBuilder,
      (Game, $$GamesTableReferences),
      Game,
      PrefetchHooks Function({
        bool matchesRefs,
        bool userGameCollectionsRefs,
        bool reviewsRefs,
      })
    >;
typedef $$MatchesTableCreateCompanionBuilder =
    MatchesCompanion Function({
      Value<int> id,
      required int gameId,
      required DateTime date,
      Value<String?> location,
      Value<String> scoringType,
      Value<int?> creatorId,
    });
typedef $$MatchesTableUpdateCompanionBuilder =
    MatchesCompanion Function({
      Value<int> id,
      Value<int> gameId,
      Value<DateTime> date,
      Value<String?> location,
      Value<String> scoringType,
      Value<int?> creatorId,
    });

final class $$MatchesTableReferences
    extends BaseReferences<_$AppDatabase, $MatchesTable, MatchRow> {
  $$MatchesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GamesTable _gameIdTable(_$AppDatabase db) => db.games.createAlias(
    $_aliasNameGenerator(db.matches.gameId, db.games.id),
  );

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<int>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTable _creatorIdTable(_$AppDatabase db) => db.users.createAlias(
    $_aliasNameGenerator(db.matches.creatorId, db.users.id),
  );

  $$UsersTableProcessedTableManager? get creatorId {
    final $_column = $_itemColumn<int>('creator_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_creatorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PlayersTable, List<Player>> _playersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.players,
    aliasName: $_aliasNameGenerator(db.matches.id, db.players.matchId),
  );

  $$PlayersTableProcessedTableManager get playersRefs {
    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.matchId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_playersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MatchesTableFilterComposer
    extends Composer<_$AppDatabase, $MatchesTable> {
  $$MatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scoringType => $composableBuilder(
    column: $table.scoringType,
    builder: (column) => ColumnFilters(column),
  );

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableFilterComposer get creatorId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatorId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> playersRefs(
    Expression<bool> Function($$PlayersTableFilterComposer f) f,
  ) {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.matchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $MatchesTable> {
  $$MatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scoringType => $composableBuilder(
    column: $table.scoringType,
    builder: (column) => ColumnOrderings(column),
  );

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableOrderingComposer get creatorId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatorId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MatchesTable> {
  $$MatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get scoringType => $composableBuilder(
    column: $table.scoringType,
    builder: (column) => column,
  );

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableAnnotationComposer get creatorId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatorId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> playersRefs<T extends Object>(
    Expression<T> Function($$PlayersTableAnnotationComposer a) f,
  ) {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.matchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MatchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MatchesTable,
          MatchRow,
          $$MatchesTableFilterComposer,
          $$MatchesTableOrderingComposer,
          $$MatchesTableAnnotationComposer,
          $$MatchesTableCreateCompanionBuilder,
          $$MatchesTableUpdateCompanionBuilder,
          (MatchRow, $$MatchesTableReferences),
          MatchRow,
          PrefetchHooks Function({
            bool gameId,
            bool creatorId,
            bool playersRefs,
          })
        > {
  $$MatchesTableTableManager(_$AppDatabase db, $MatchesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> gameId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String> scoringType = const Value.absent(),
                Value<int?> creatorId = const Value.absent(),
              }) => MatchesCompanion(
                id: id,
                gameId: gameId,
                date: date,
                location: location,
                scoringType: scoringType,
                creatorId: creatorId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int gameId,
                required DateTime date,
                Value<String?> location = const Value.absent(),
                Value<String> scoringType = const Value.absent(),
                Value<int?> creatorId = const Value.absent(),
              }) => MatchesCompanion.insert(
                id: id,
                gameId: gameId,
                date: date,
                location: location,
                scoringType: scoringType,
                creatorId: creatorId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MatchesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({gameId = false, creatorId = false, playersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (playersRefs) db.players],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (gameId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.gameId,
                                    referencedTable: $$MatchesTableReferences
                                        ._gameIdTable(db),
                                    referencedColumn: $$MatchesTableReferences
                                        ._gameIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (creatorId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.creatorId,
                                    referencedTable: $$MatchesTableReferences
                                        ._creatorIdTable(db),
                                    referencedColumn: $$MatchesTableReferences
                                        ._creatorIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (playersRefs)
                        await $_getPrefetchedData<
                          MatchRow,
                          $MatchesTable,
                          Player
                        >(
                          currentTable: table,
                          referencedTable: $$MatchesTableReferences
                              ._playersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MatchesTableReferences(
                                db,
                                table,
                                p0,
                              ).playersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.matchId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MatchesTable,
      MatchRow,
      $$MatchesTableFilterComposer,
      $$MatchesTableOrderingComposer,
      $$MatchesTableAnnotationComposer,
      $$MatchesTableCreateCompanionBuilder,
      $$MatchesTableUpdateCompanionBuilder,
      (MatchRow, $$MatchesTableReferences),
      MatchRow,
      PrefetchHooks Function({bool gameId, bool creatorId, bool playersRefs})
    >;
typedef $$PlayersTableCreateCompanionBuilder =
    PlayersCompanion Function({
      Value<int> id,
      required int matchId,
      required int userId,
      Value<int?> score,
      Value<int?> rank,
      Value<double?> matchRating,
      Value<bool> isWinner,
    });
typedef $$PlayersTableUpdateCompanionBuilder =
    PlayersCompanion Function({
      Value<int> id,
      Value<int> matchId,
      Value<int> userId,
      Value<int?> score,
      Value<int?> rank,
      Value<double?> matchRating,
      Value<bool> isWinner,
    });

final class $$PlayersTableReferences
    extends BaseReferences<_$AppDatabase, $PlayersTable, Player> {
  $$PlayersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MatchesTable _matchIdTable(_$AppDatabase db) => db.matches
      .createAlias($_aliasNameGenerator(db.players.matchId, db.matches.id));

  $$MatchesTableProcessedTableManager get matchId {
    final $_column = $_itemColumn<int>('match_id')!;

    final manager = $$MatchesTableTableManager(
      $_db,
      $_db.matches,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_matchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
    $_aliasNameGenerator(db.players.userId, db.users.id),
  );

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlayersTableFilterComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get matchRating => $composableBuilder(
    column: $table.matchRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isWinner => $composableBuilder(
    column: $table.isWinner,
    builder: (column) => ColumnFilters(column),
  );

  $$MatchesTableFilterComposer get matchId {
    final $$MatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.matchId,
      referencedTable: $db.matches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchesTableFilterComposer(
            $db: $db,
            $table: $db.matches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayersTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get matchRating => $composableBuilder(
    column: $table.matchRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isWinner => $composableBuilder(
    column: $table.isWinner,
    builder: (column) => ColumnOrderings(column),
  );

  $$MatchesTableOrderingComposer get matchId {
    final $$MatchesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.matchId,
      referencedTable: $db.matches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchesTableOrderingComposer(
            $db: $db,
            $table: $db.matches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get rank =>
      $composableBuilder(column: $table.rank, builder: (column) => column);

  GeneratedColumn<double> get matchRating => $composableBuilder(
    column: $table.matchRating,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isWinner =>
      $composableBuilder(column: $table.isWinner, builder: (column) => column);

  $$MatchesTableAnnotationComposer get matchId {
    final $$MatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.matchId,
      referencedTable: $db.matches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.matches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayersTable,
          Player,
          $$PlayersTableFilterComposer,
          $$PlayersTableOrderingComposer,
          $$PlayersTableAnnotationComposer,
          $$PlayersTableCreateCompanionBuilder,
          $$PlayersTableUpdateCompanionBuilder,
          (Player, $$PlayersTableReferences),
          Player,
          PrefetchHooks Function({bool matchId, bool userId})
        > {
  $$PlayersTableTableManager(_$AppDatabase db, $PlayersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> matchId = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<int?> score = const Value.absent(),
                Value<int?> rank = const Value.absent(),
                Value<double?> matchRating = const Value.absent(),
                Value<bool> isWinner = const Value.absent(),
              }) => PlayersCompanion(
                id: id,
                matchId: matchId,
                userId: userId,
                score: score,
                rank: rank,
                matchRating: matchRating,
                isWinner: isWinner,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int matchId,
                required int userId,
                Value<int?> score = const Value.absent(),
                Value<int?> rank = const Value.absent(),
                Value<double?> matchRating = const Value.absent(),
                Value<bool> isWinner = const Value.absent(),
              }) => PlayersCompanion.insert(
                id: id,
                matchId: matchId,
                userId: userId,
                score: score,
                rank: rank,
                matchRating: matchRating,
                isWinner: isWinner,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlayersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({matchId = false, userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (matchId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.matchId,
                                referencedTable: $$PlayersTableReferences
                                    ._matchIdTable(db),
                                referencedColumn: $$PlayersTableReferences
                                    ._matchIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$PlayersTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$PlayersTableReferences
                                    ._userIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayersTable,
      Player,
      $$PlayersTableFilterComposer,
      $$PlayersTableOrderingComposer,
      $$PlayersTableAnnotationComposer,
      $$PlayersTableCreateCompanionBuilder,
      $$PlayersTableUpdateCompanionBuilder,
      (Player, $$PlayersTableReferences),
      Player,
      PrefetchHooks Function({bool matchId, bool userId})
    >;
typedef $$UserGameCollectionsTableCreateCompanionBuilder =
    UserGameCollectionsCompanion Function({
      Value<int> id,
      required int userId,
      required int gameId,
      required String collectionType,
      required DateTime addedAt,
    });
typedef $$UserGameCollectionsTableUpdateCompanionBuilder =
    UserGameCollectionsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<int> gameId,
      Value<String> collectionType,
      Value<DateTime> addedAt,
    });

final class $$UserGameCollectionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $UserGameCollectionsTable,
          UserGameCollection
        > {
  $$UserGameCollectionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
    $_aliasNameGenerator(db.userGameCollections.userId, db.users.id),
  );

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GamesTable _gameIdTable(_$AppDatabase db) => db.games.createAlias(
    $_aliasNameGenerator(db.userGameCollections.gameId, db.games.id),
  );

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<int>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UserGameCollectionsTableFilterComposer
    extends Composer<_$AppDatabase, $UserGameCollectionsTable> {
  $$UserGameCollectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get collectionType => $composableBuilder(
    column: $table.collectionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserGameCollectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserGameCollectionsTable> {
  $$UserGameCollectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get collectionType => $composableBuilder(
    column: $table.collectionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserGameCollectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserGameCollectionsTable> {
  $$UserGameCollectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get collectionType => $composableBuilder(
    column: $table.collectionType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserGameCollectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserGameCollectionsTable,
          UserGameCollection,
          $$UserGameCollectionsTableFilterComposer,
          $$UserGameCollectionsTableOrderingComposer,
          $$UserGameCollectionsTableAnnotationComposer,
          $$UserGameCollectionsTableCreateCompanionBuilder,
          $$UserGameCollectionsTableUpdateCompanionBuilder,
          (UserGameCollection, $$UserGameCollectionsTableReferences),
          UserGameCollection,
          PrefetchHooks Function({bool userId, bool gameId})
        > {
  $$UserGameCollectionsTableTableManager(
    _$AppDatabase db,
    $UserGameCollectionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserGameCollectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserGameCollectionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$UserGameCollectionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<int> gameId = const Value.absent(),
                Value<String> collectionType = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
              }) => UserGameCollectionsCompanion(
                id: id,
                userId: userId,
                gameId: gameId,
                collectionType: collectionType,
                addedAt: addedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required int gameId,
                required String collectionType,
                required DateTime addedAt,
              }) => UserGameCollectionsCompanion.insert(
                id: id,
                userId: userId,
                gameId: gameId,
                collectionType: collectionType,
                addedAt: addedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserGameCollectionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, gameId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable:
                                    $$UserGameCollectionsTableReferences
                                        ._userIdTable(db),
                                referencedColumn:
                                    $$UserGameCollectionsTableReferences
                                        ._userIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (gameId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gameId,
                                referencedTable:
                                    $$UserGameCollectionsTableReferences
                                        ._gameIdTable(db),
                                referencedColumn:
                                    $$UserGameCollectionsTableReferences
                                        ._gameIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UserGameCollectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserGameCollectionsTable,
      UserGameCollection,
      $$UserGameCollectionsTableFilterComposer,
      $$UserGameCollectionsTableOrderingComposer,
      $$UserGameCollectionsTableAnnotationComposer,
      $$UserGameCollectionsTableCreateCompanionBuilder,
      $$UserGameCollectionsTableUpdateCompanionBuilder,
      (UserGameCollection, $$UserGameCollectionsTableReferences),
      UserGameCollection,
      PrefetchHooks Function({bool userId, bool gameId})
    >;
typedef $$FriendshipsTableCreateCompanionBuilder =
    FriendshipsCompanion Function({
      Value<int> id,
      required int userId,
      required int friendId,
      required String status,
      required DateTime requestedAt,
      Value<DateTime?> respondedAt,
    });
typedef $$FriendshipsTableUpdateCompanionBuilder =
    FriendshipsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<int> friendId,
      Value<String> status,
      Value<DateTime> requestedAt,
      Value<DateTime?> respondedAt,
    });

final class $$FriendshipsTableReferences
    extends BaseReferences<_$AppDatabase, $FriendshipsTable, Friendship> {
  $$FriendshipsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
    $_aliasNameGenerator(db.friendships.userId, db.users.id),
  );

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTable _friendIdTable(_$AppDatabase db) => db.users.createAlias(
    $_aliasNameGenerator(db.friendships.friendId, db.users.id),
  );

  $$UsersTableProcessedTableManager get friendId {
    final $_column = $_itemColumn<int>('friend_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_friendIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FriendshipsTableFilterComposer
    extends Composer<_$AppDatabase, $FriendshipsTable> {
  $$FriendshipsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get requestedAt => $composableBuilder(
    column: $table.requestedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get respondedAt => $composableBuilder(
    column: $table.respondedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableFilterComposer get friendId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.friendId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FriendshipsTableOrderingComposer
    extends Composer<_$AppDatabase, $FriendshipsTable> {
  $$FriendshipsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get requestedAt => $composableBuilder(
    column: $table.requestedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get respondedAt => $composableBuilder(
    column: $table.respondedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableOrderingComposer get friendId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.friendId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FriendshipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FriendshipsTable> {
  $$FriendshipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get requestedAt => $composableBuilder(
    column: $table.requestedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get respondedAt => $composableBuilder(
    column: $table.respondedAt,
    builder: (column) => column,
  );

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableAnnotationComposer get friendId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.friendId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FriendshipsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FriendshipsTable,
          Friendship,
          $$FriendshipsTableFilterComposer,
          $$FriendshipsTableOrderingComposer,
          $$FriendshipsTableAnnotationComposer,
          $$FriendshipsTableCreateCompanionBuilder,
          $$FriendshipsTableUpdateCompanionBuilder,
          (Friendship, $$FriendshipsTableReferences),
          Friendship,
          PrefetchHooks Function({bool userId, bool friendId})
        > {
  $$FriendshipsTableTableManager(_$AppDatabase db, $FriendshipsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FriendshipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FriendshipsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FriendshipsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<int> friendId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> requestedAt = const Value.absent(),
                Value<DateTime?> respondedAt = const Value.absent(),
              }) => FriendshipsCompanion(
                id: id,
                userId: userId,
                friendId: friendId,
                status: status,
                requestedAt: requestedAt,
                respondedAt: respondedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required int friendId,
                required String status,
                required DateTime requestedAt,
                Value<DateTime?> respondedAt = const Value.absent(),
              }) => FriendshipsCompanion.insert(
                id: id,
                userId: userId,
                friendId: friendId,
                status: status,
                requestedAt: requestedAt,
                respondedAt: respondedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FriendshipsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, friendId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$FriendshipsTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$FriendshipsTableReferences
                                    ._userIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (friendId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.friendId,
                                referencedTable: $$FriendshipsTableReferences
                                    ._friendIdTable(db),
                                referencedColumn: $$FriendshipsTableReferences
                                    ._friendIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FriendshipsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FriendshipsTable,
      Friendship,
      $$FriendshipsTableFilterComposer,
      $$FriendshipsTableOrderingComposer,
      $$FriendshipsTableAnnotationComposer,
      $$FriendshipsTableCreateCompanionBuilder,
      $$FriendshipsTableUpdateCompanionBuilder,
      (Friendship, $$FriendshipsTableReferences),
      Friendship,
      PrefetchHooks Function({bool userId, bool friendId})
    >;
typedef $$NotificationsTableCreateCompanionBuilder =
    NotificationsCompanion Function({
      Value<int> id,
      required int userId,
      required String type,
      required String title,
      required String message,
      Value<int?> relatedId,
      Value<bool> isRead,
      Value<DateTime> createdAt,
    });
typedef $$NotificationsTableUpdateCompanionBuilder =
    NotificationsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> type,
      Value<String> title,
      Value<String> message,
      Value<int?> relatedId,
      Value<bool> isRead,
      Value<DateTime> createdAt,
    });

final class $$NotificationsTableReferences
    extends BaseReferences<_$AppDatabase, $NotificationsTable, Notification> {
  $$NotificationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
    $_aliasNameGenerator(db.notifications.userId, db.users.id),
  );

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$NotificationsTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get relatedId => $composableBuilder(
    column: $table.relatedId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get relatedId => $composableBuilder(
    column: $table.relatedId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<int> get relatedId =>
      $composableBuilder(column: $table.relatedId, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotificationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationsTable,
          Notification,
          $$NotificationsTableFilterComposer,
          $$NotificationsTableOrderingComposer,
          $$NotificationsTableAnnotationComposer,
          $$NotificationsTableCreateCompanionBuilder,
          $$NotificationsTableUpdateCompanionBuilder,
          (Notification, $$NotificationsTableReferences),
          Notification,
          PrefetchHooks Function({bool userId})
        > {
  $$NotificationsTableTableManager(_$AppDatabase db, $NotificationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<int?> relatedId = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => NotificationsCompanion(
                id: id,
                userId: userId,
                type: type,
                title: title,
                message: message,
                relatedId: relatedId,
                isRead: isRead,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required String type,
                required String title,
                required String message,
                Value<int?> relatedId = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => NotificationsCompanion.insert(
                id: id,
                userId: userId,
                type: type,
                title: title,
                message: message,
                relatedId: relatedId,
                isRead: isRead,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$NotificationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$NotificationsTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$NotificationsTableReferences
                                    ._userIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$NotificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationsTable,
      Notification,
      $$NotificationsTableFilterComposer,
      $$NotificationsTableOrderingComposer,
      $$NotificationsTableAnnotationComposer,
      $$NotificationsTableCreateCompanionBuilder,
      $$NotificationsTableUpdateCompanionBuilder,
      (Notification, $$NotificationsTableReferences),
      Notification,
      PrefetchHooks Function({bool userId})
    >;
typedef $$ReviewsTableCreateCompanionBuilder =
    ReviewsCompanion Function({
      Value<int> id,
      required int userId,
      required int gameId,
      required double rating,
      Value<String?> comment,
      Value<DateTime> createdAt,
    });
typedef $$ReviewsTableUpdateCompanionBuilder =
    ReviewsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<int> gameId,
      Value<double> rating,
      Value<String?> comment,
      Value<DateTime> createdAt,
    });

final class $$ReviewsTableReferences
    extends BaseReferences<_$AppDatabase, $ReviewsTable, Review> {
  $$ReviewsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
    $_aliasNameGenerator(db.reviews.userId, db.users.id),
  );

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GamesTable _gameIdTable(_$AppDatabase db) => db.games.createAlias(
    $_aliasNameGenerator(db.reviews.gameId, db.games.id),
  );

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<int>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReviewsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewsTable> {
  $$ReviewsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewsTable> {
  $$ReviewsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewsTable> {
  $$ReviewsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewsTable,
          Review,
          $$ReviewsTableFilterComposer,
          $$ReviewsTableOrderingComposer,
          $$ReviewsTableAnnotationComposer,
          $$ReviewsTableCreateCompanionBuilder,
          $$ReviewsTableUpdateCompanionBuilder,
          (Review, $$ReviewsTableReferences),
          Review,
          PrefetchHooks Function({bool userId, bool gameId})
        > {
  $$ReviewsTableTableManager(_$AppDatabase db, $ReviewsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<int> gameId = const Value.absent(),
                Value<double> rating = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ReviewsCompanion(
                id: id,
                userId: userId,
                gameId: gameId,
                rating: rating,
                comment: comment,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required int gameId,
                required double rating,
                Value<String?> comment = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ReviewsCompanion.insert(
                id: id,
                userId: userId,
                gameId: gameId,
                rating: rating,
                comment: comment,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReviewsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, gameId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$ReviewsTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$ReviewsTableReferences
                                    ._userIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (gameId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gameId,
                                referencedTable: $$ReviewsTableReferences
                                    ._gameIdTable(db),
                                referencedColumn: $$ReviewsTableReferences
                                    ._gameIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReviewsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewsTable,
      Review,
      $$ReviewsTableFilterComposer,
      $$ReviewsTableOrderingComposer,
      $$ReviewsTableAnnotationComposer,
      $$ReviewsTableCreateCompanionBuilder,
      $$ReviewsTableUpdateCompanionBuilder,
      (Review, $$ReviewsTableReferences),
      Review,
      PrefetchHooks Function({bool userId, bool gameId})
    >;
typedef $$UserAchievementsTableCreateCompanionBuilder =
    UserAchievementsCompanion Function({
      Value<int> id,
      required int userId,
      required String achievementId,
      Value<DateTime> unlockedAt,
    });
typedef $$UserAchievementsTableUpdateCompanionBuilder =
    UserAchievementsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> achievementId,
      Value<DateTime> unlockedAt,
    });

final class $$UserAchievementsTableReferences
    extends
        BaseReferences<_$AppDatabase, $UserAchievementsTable, UserAchievement> {
  $$UserAchievementsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
    $_aliasNameGenerator(db.userAchievements.userId, db.users.id),
  );

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UserAchievementsTableFilterComposer
    extends Composer<_$AppDatabase, $UserAchievementsTable> {
  $$UserAchievementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get achievementId => $composableBuilder(
    column: $table.achievementId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserAchievementsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserAchievementsTable> {
  $$UserAchievementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get achievementId => $composableBuilder(
    column: $table.achievementId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserAchievementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserAchievementsTable> {
  $$UserAchievementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get achievementId => $composableBuilder(
    column: $table.achievementId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => column,
  );

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserAchievementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserAchievementsTable,
          UserAchievement,
          $$UserAchievementsTableFilterComposer,
          $$UserAchievementsTableOrderingComposer,
          $$UserAchievementsTableAnnotationComposer,
          $$UserAchievementsTableCreateCompanionBuilder,
          $$UserAchievementsTableUpdateCompanionBuilder,
          (UserAchievement, $$UserAchievementsTableReferences),
          UserAchievement,
          PrefetchHooks Function({bool userId})
        > {
  $$UserAchievementsTableTableManager(
    _$AppDatabase db,
    $UserAchievementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserAchievementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserAchievementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserAchievementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> achievementId = const Value.absent(),
                Value<DateTime> unlockedAt = const Value.absent(),
              }) => UserAchievementsCompanion(
                id: id,
                userId: userId,
                achievementId: achievementId,
                unlockedAt: unlockedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required String achievementId,
                Value<DateTime> unlockedAt = const Value.absent(),
              }) => UserAchievementsCompanion.insert(
                id: id,
                userId: userId,
                achievementId: achievementId,
                unlockedAt: unlockedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserAchievementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable:
                                    $$UserAchievementsTableReferences
                                        ._userIdTable(db),
                                referencedColumn:
                                    $$UserAchievementsTableReferences
                                        ._userIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UserAchievementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserAchievementsTable,
      UserAchievement,
      $$UserAchievementsTableFilterComposer,
      $$UserAchievementsTableOrderingComposer,
      $$UserAchievementsTableAnnotationComposer,
      $$UserAchievementsTableCreateCompanionBuilder,
      $$UserAchievementsTableUpdateCompanionBuilder,
      (UserAchievement, $$UserAchievementsTableReferences),
      UserAchievement,
      PrefetchHooks Function({bool userId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db, _db.games);
  $$MatchesTableTableManager get matches =>
      $$MatchesTableTableManager(_db, _db.matches);
  $$PlayersTableTableManager get players =>
      $$PlayersTableTableManager(_db, _db.players);
  $$UserGameCollectionsTableTableManager get userGameCollections =>
      $$UserGameCollectionsTableTableManager(_db, _db.userGameCollections);
  $$FriendshipsTableTableManager get friendships =>
      $$FriendshipsTableTableManager(_db, _db.friendships);
  $$NotificationsTableTableManager get notifications =>
      $$NotificationsTableTableManager(_db, _db.notifications);
  $$ReviewsTableTableManager get reviews =>
      $$ReviewsTableTableManager(_db, _db.reviews);
  $$UserAchievementsTableTableManager get userAchievements =>
      $$UserAchievementsTableTableManager(_db, _db.userAchievements);
}

mixin _$UsersDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  UsersDaoManager get managers => UsersDaoManager(this);
}

class UsersDaoManager {
  final _$UsersDaoMixin _db;
  UsersDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
}

mixin _$GamesDaoMixin on DatabaseAccessor<AppDatabase> {
  $GamesTable get games => attachedDatabase.games;
  GamesDaoManager get managers => GamesDaoManager(this);
}

class GamesDaoManager {
  final _$GamesDaoMixin _db;
  GamesDaoManager(this._db);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db.attachedDatabase, _db.games);
}

mixin _$MatchesDaoMixin on DatabaseAccessor<AppDatabase> {
  $GamesTable get games => attachedDatabase.games;
  $UsersTable get users => attachedDatabase.users;
  $MatchesTable get matches => attachedDatabase.matches;
  $PlayersTable get players => attachedDatabase.players;
  MatchesDaoManager get managers => MatchesDaoManager(this);
}

class MatchesDaoManager {
  final _$MatchesDaoMixin _db;
  MatchesDaoManager(this._db);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db.attachedDatabase, _db.games);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$MatchesTableTableManager get matches =>
      $$MatchesTableTableManager(_db.attachedDatabase, _db.matches);
  $$PlayersTableTableManager get players =>
      $$PlayersTableTableManager(_db.attachedDatabase, _db.players);
}

mixin _$UserGameCollectionsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $GamesTable get games => attachedDatabase.games;
  $UserGameCollectionsTable get userGameCollections =>
      attachedDatabase.userGameCollections;
  UserGameCollectionsDaoManager get managers =>
      UserGameCollectionsDaoManager(this);
}

class UserGameCollectionsDaoManager {
  final _$UserGameCollectionsDaoMixin _db;
  UserGameCollectionsDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db.attachedDatabase, _db.games);
  $$UserGameCollectionsTableTableManager get userGameCollections =>
      $$UserGameCollectionsTableTableManager(
        _db.attachedDatabase,
        _db.userGameCollections,
      );
}

mixin _$FriendshipsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $FriendshipsTable get friendships => attachedDatabase.friendships;
  FriendshipsDaoManager get managers => FriendshipsDaoManager(this);
}

class FriendshipsDaoManager {
  final _$FriendshipsDaoMixin _db;
  FriendshipsDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$FriendshipsTableTableManager get friendships =>
      $$FriendshipsTableTableManager(_db.attachedDatabase, _db.friendships);
}

mixin _$NotificationsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $NotificationsTable get notifications => attachedDatabase.notifications;
  NotificationsDaoManager get managers => NotificationsDaoManager(this);
}

class NotificationsDaoManager {
  final _$NotificationsDaoMixin _db;
  NotificationsDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$NotificationsTableTableManager get notifications =>
      $$NotificationsTableTableManager(_db.attachedDatabase, _db.notifications);
}

mixin _$ReviewsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $GamesTable get games => attachedDatabase.games;
  $ReviewsTable get reviews => attachedDatabase.reviews;
  ReviewsDaoManager get managers => ReviewsDaoManager(this);
}

class ReviewsDaoManager {
  final _$ReviewsDaoMixin _db;
  ReviewsDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db.attachedDatabase, _db.games);
  $$ReviewsTableTableManager get reviews =>
      $$ReviewsTableTableManager(_db.attachedDatabase, _db.reviews);
}

mixin _$UserAchievementsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $UserAchievementsTable get userAchievements =>
      attachedDatabase.userAchievements;
  UserAchievementsDaoManager get managers => UserAchievementsDaoManager(this);
}

class UserAchievementsDaoManager {
  final _$UserAchievementsDaoMixin _db;
  UserAchievementsDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$UserAchievementsTableTableManager get userAchievements =>
      $$UserAchievementsTableTableManager(
        _db.attachedDatabase,
        _db.userAchievements,
      );
}
