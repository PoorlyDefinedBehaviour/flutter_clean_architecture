import 'package:clean_architecture_app/core/network/network_info.dart';
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:data_connection_checker/data_connection_checker.dart";

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  final mockDataConnectionChecker = MockDataConnectionChecker();
  final networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);

  group("isConnected", () {
    test("should forward the call to DataConnectionChecker.hasConnection",
        () async {
      final hasConnectionFuture = Future.value(true);

      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) => hasConnectionFuture);

      final result = networkInfoImpl.isConnected();

      verify(mockDataConnectionChecker.hasConnection);

      expect(result, equals(hasConnectionFuture));
    });
  });
}
