String intToHex(int dec) => dec.toRadixString(16).padLeft(2, '0').toUpperCase();

String intListToHexString(List<int> dec) => dec.map(intToHex).join(' ');

int hexToInt(String hex) => int.parse(hex, radix: 16);

List<int> hexStringToIntList(String s) => s.split(' ').map(hexToInt).toList();
