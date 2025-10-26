import 'dart:io';

import 'package:dio/dio.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/interceptor/client_settings.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/utils/convert_media_type.dart';

class FileService {
  static ClientSettings client = ClientSettings();
  static String url = "file/";

  static Future<String> uploadImage(String directory, File image) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        image.path,
        contentType: convertPathToMediaType(image.path),
      ),
      'directory': directory,
    });

    final response = await client.dio.post(
      '${url}upload-image',
      data: formData,
    );

    var result = BaseResponse<String>.fromJson(response.data);

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result.data!;
  }
}
