import '../main.dart';
import 'style.dart';

AppStyle get $style => MyApp.style;

double sizeUnit = 1;

const int nullInt = -100;
const double nullDouble = -100;

final DateTime nullDateTime = DateTime(1000, 1, 1, 9);

const int genderMale = 0; // 남
const int genderFemale = 1; // 여

const String division = '|'; // 문자열 구분자
const String formDivision = '__'; // 폼 문자열 구분자

enum LoginType{google, kakao, apple, none} // 로그인 타입 (구글, 카카오, 애플, 비로그인)

const int standardWidth = 1920; // 표준 width

// 현재 화면 크기에 따라 사이즈 비율 계산
double calSizeUnit(double currentWidth, double value) => currentWidth * (value / standardWidth);

const int descriptionMaxCount = 3; // description 최대 개수

const String likedIdListKey = 'likedIdList';
const String defaultImgUrl = 'https://firebasestorage.googleapis.com/v0/b/sheeps-landing.appspot.com/o/project'; // 기본 이미지 url
final Uri siteUri = Uri.parse('https://sheeps.co.kr'); // 사이트 url