String intToHex(int dec) {
  return dec.toRadixString(16).padLeft(2, '0').toUpperCase();
}

String intListToHexString(List<int> dec) {
  return dec.map(intToHex).join(' ');
}

int hexToInt(String hex) {
  return int.parse(hex, radix: 16);
}

List<int> hexStringToIntList(String hex) {
  return hex.split(' ').map(hexToInt).toList();
}
