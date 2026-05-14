

class AddressSave {
  final String? addresstype;
  final String? firstname;
  final String? lastName;
  final String? email;
  final String? city;
  final String? area;
  final String? address;
  final String? streetAddress;
  final String? houseNo;
  final String? countryCode;
  final String? carrierCode;
  final String? number;
  final String? addressId;
  final String? savedefault;
  final String? customAddressId;
  final String? countryId;
  final String? carrier;

  AddressSave(
      this.addresstype,
      this.firstname,
      this.lastName,
      this.email,
      this.city,
      this.area,
      this.address,
      this.streetAddress,
      this.houseNo,
      this.countryCode,
      this.carrierCode,
      this.number,
      this.addressId,
      this.savedefault,
      this.customAddressId,
      this.countryId,
      this.carrier);

  AddressSave copyWith({
    String? addresstype,
    String? firstname,
    String? lastName,
    String? email,
    String? city,
    String? area,
    String? address,
    String? streetAddress,
    String? houseNo,
    String? countryCode,
    String? carrierCode,
    String? number,
    String? addressId,
    String? savedefault,
    String? customAddressId,
    String? countryId,
    String? carrier,
  }) {
    return AddressSave(
      addresstype ?? this.addresstype,
      firstname ?? this.firstname,
      lastName ?? this.lastName,
      email ?? this.email,
      city ?? this.city,
      area ?? this.area,
      address ?? this.address,
      streetAddress ?? this.streetAddress,
      houseNo ?? this.houseNo,
      countryCode ?? this.countryCode,
      carrierCode ?? this.carrierCode,
      number ?? this.number,
      addressId ?? this.addressId,
      savedefault ?? this.savedefault,
      customAddressId ?? this.customAddressId,
      countryId ?? this.countryId,
      carrier ?? this.carrier,
    );
  }
}
