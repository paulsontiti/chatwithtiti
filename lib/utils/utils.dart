import 'package:chat_app/utils/snackbar.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source, dynamic context) async {
  final ImagePicker imagePicker = ImagePicker();
  final XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  }
  showSnackbar('No Image selected', context);
}
