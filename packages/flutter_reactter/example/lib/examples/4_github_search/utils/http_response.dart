import 'package:http/http.dart';

typedef NotFoundException = Exception;

Future<T> getResponse<T>({
  required Future<Response> request,
  required T Function(Response) onSuccess,
}) {
  return request.then((response) {
    if (response.statusCode == 200) {
      return onSuccess(response);
    }

    if (response.statusCode == 404) {
      throw NotFoundException('Not found');
    }

    throw Exception('Failed to load data');
  });
}
