class UserModel {
  String? uid;
  String? email;
  String? anrede;
  String? geburtstag;
  String? name;
  String? lastname;
  String? laufbahn;
  String? passwort;

  // additional
  String? anschrift;
  String? hausnummer;
  String? plz;
  String? ort;

  String? telefon;
  String? dienstgrad;
  String? dienstantritt;
  String? dienstverhaeltnis;
  String? standort;
  String? verwendung;
  String? stufeneinstieg;
  String? familienstand;
  String? kinder;
  String? trennungsgeld;
  String? schlafort;
  String? steuer;
  String? steuerWert;
  String? vwl;
  String? vwlWert;

  UserModel({
    this.uid,
    this.email,
    this.name,
    this.lastname,
    this.laufbahn,
    this.passwort,
    this.anrede,
    this.geburtstag,

    // additional
    this.anschrift,
    this.hausnummer,
    this.plz,
    this.ort,

    this.telefon,
    this.dienstgrad,
    this.dienstantritt,
    this.dienstverhaeltnis,
    this.standort,
    this.verwendung,
    this.stufeneinstieg,
    this.familienstand,
    this.kinder,
    this.trennungsgeld,
    this.schlafort,
    this.steuer,
    this.steuerWert,
    this.vwl,
    this.vwlWert,
  });

  // receive data from server
  factory UserModel.fromMap(map) {
    return UserModel(
        // registration required
        uid: map["uid"],
        anrede: map["anrede"],
        email: map["email"],
        name: map["name"],
        lastname: map["lastname"],
        laufbahn: map["laufbahn"],
        passwort: map["passwort"],
        geburtstag: map["geburtstag"],

        // additional
        anschrift: map["anschrift"],
        hausnummer: map["hausnummer"],
        plz: map["plz"],
        ort: map["ort"],

        telefon: map["telefon"],
        dienstgrad: map["dienstgrad"],
        dienstantritt: map["dienstantritt"],
        dienstverhaeltnis: map["dienstverhaeltnis"],
        standort: map["standort"],
        verwendung: map["verwendung"],
        stufeneinstieg: map["stufeneinstieg"],
        familienstand: map["familienstand"],
        kinder: map["kinder"],
        trennungsgeld: map["trennungsgeld"],
        schlafort: map["schlafort"],
        steuer: map["steuer"],
        steuerWert: map["steuerWert"],
        vwl: map["vwl"],
        vwlWert: map["vwlWert"]);
  }

  // send data to server
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "anrede": anrede,
      "email": email,
      "name": name,
      "lastname": lastname,
      "password": passwort,
      "laufbahn": laufbahn
    };
  }

  Map<String, dynamic> refreshProfile() {
    return {
      "uid": uid,
      "anrede": anrede,
      "email": email,
      "name": name,
      "lastname": lastname,
      "laufbahn": laufbahn,
      "geburtstag": geburtstag,
      "password": passwort,

      "anschrift": anschrift,
      "hausnummer": hausnummer,
      "plz": plz,
      "ort": ort,

      "telefon": telefon,
      "dienstgrad": dienstgrad,
      "dienstantritt": dienstantritt,
      "dienstverhaeltnis": dienstverhaeltnis,
      "standort": standort,
      "verwendung": verwendung,
      "stufeneinstieg": stufeneinstieg,
      "familienstand": familienstand,
      "kinder": kinder,
      "trennungsgeld": trennungsgeld,
      "schlafort": schlafort,
      "steuer": steuer,
      "steuerWert": steuerWert,
      "vwl": vwl,
      "vwlWert": vwlWert,
    };
  }
}
