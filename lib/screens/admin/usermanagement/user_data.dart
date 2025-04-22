import 'package:faker/faker.dart';

List<Map<String, String>> generateUserList(int count) {
  final faker = Faker();
  List<Map<String, String>> userList = [];

  for (int i = 0; i < count; i++) {
    userList.add({
      'userId': 'U${(i + 1).toString().padLeft(3, '0')}',
      'name': faker.person.name(),
      'email': faker.internet.email(),
      'course': faker.randomGenerator.element([
        'Computer Science',
        'Information Technology',
        'Information Systems'
      ]),
      'yearLevel': faker.randomGenerator.element(['1', '2', '3', '4']),
      'phoneNumber': faker.phoneNumber.us(),
      'status': faker.randomGenerator.element(['Active', 'Blocked']),
    });
  }

  return userList;
}

void main() {
  // Generate a list of 50 users
  List<Map<String, String>> generatedUserList = generateUserList(50);

  // Print the first 5 users to verify
  for (int i = 0; i < 5; i++) {
    print(generatedUserList[i]);
  }
}
