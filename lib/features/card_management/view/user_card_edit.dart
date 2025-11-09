import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/utils/image_util.dart';
import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:aut_toolkit/core/widgets/square_image_filled_width.dart';
import 'package:aut_toolkit/features/card_management/domain/model/user_card.dart';
import 'package:aut_toolkit/features/card_management/provider/card_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/divider/sized_box_divider.dart';
import '../../../i18n/strings.g.dart';

class UserCardEdit extends ConsumerStatefulWidget {
  const UserCardEdit({super.key, required this.isNew, required this.card});

  final bool isNew;
  final UserCard card;

  @override
  ConsumerState<UserCardEdit> createState() => _UserCardCreateState();
}

class _UserCardCreateState extends ConsumerState<UserCardEdit> {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  String? _imagePath;
  String? _arasaacId;
  bool _isLoadingImage = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.card.names[LocaleSettings.currentLocale.languageCode] ?? '',
    );
    _imagePath = widget.card.localImgPath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          widget.isNew
              ? t.create
              : '${t.edit} ${widget.card.names[LocaleSettings.currentLocale.languageCode]}',
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: _saveUserCard,
            icon: const Icon(Icons.check),
            label: Text(t.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: AppConstants.BASE_APP_UI_PADDING,
            right: AppConstants.BASE_APP_UI_PADDING,
            bottom: AppConstants.BASE_APP_UI_PADDING,
          ),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _nameField(),
                    const SizedBoxDivider(),
                    _addImageButton(),
                    _buildImageArea(),
                    ..._deleteImageButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _nameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: t.name,
        border: const OutlineInputBorder(),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? t.please_enter_name : null,
    );
  }

  Widget _addImageButton() {
    return Padding(
      padding: EdgeInsets.only(bottom: _imagePath != null ? 12.0 : 0, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: _isLoadingImage ? null : _pickImage,
            icon: const Icon(Icons.add_a_photo),
            label: Text(_imagePath == null ? t.load_image : t.change_image),
          ),
        ],
      ),
    );
  }

  Widget _buildImageArea() {
    if (_isLoadingImage) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_imagePath != null && _imagePath!.isNotEmpty) {
      return SquareImageFilledWidth(imageFilePath: _imagePath!);
    }
    return Container();
  }

  List<Widget> _deleteImageButton() {
    if (_imagePath != null && _imagePath!.isNotEmpty) {
      return [
        const SizedBoxDivider(),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _deleteImage,
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                label: Text(
                  t.delete_image,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
        ),
      ];
    }
    return [Container()];
  }

  Future<void> _pickImage() async {
    final choice = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.create_card_decision),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context, 'gallery'),
            child: Text(t.from_gallery),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, 'arasaac'),
            child: Text(t.arasaac_icons),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text(t.cancel),
          ),
        ],
      ),
    );

    if (choice == null) return;

    setState(() => _isLoadingImage = true);
    String? imgPath;

    try {
      if (choice == 'gallery') {
        imgPath = await ImageUtil.pickAndStoreImage(
          Theme.of(context).colorScheme.surface,
          Theme.of(context).textTheme.headlineLarge!.color!,
        );
      } else if (choice == 'arasaac') {
        await router.push(RouterUtils.getCardsARASAACPath());
        String? path = await asyncPrefs.getString('imgPath');
        if (path!.isNotEmpty) {
          imgPath = await ImageUtil.saveImageFromUrl(path);
          _arasaacId = imgPath?.split("/").last.split("_").first;
          asyncPrefs.setString('imgPath', "");
        }
      }

      if (imgPath != null) {
        if (_imagePath != null) {
          ImageUtil.deleteImage(_imagePath!);
        }
        setState(() {
          _imagePath = imgPath;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.error_occured)));
    } finally {
      setState(() => _isLoadingImage = false);
    }
  }

  void _deleteImage() {
    if (_imagePath != null) {
      ImageUtil.deleteImage(_imagePath!);
      setState(() {
        _imagePath = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.image_deleted)));
    }
  }

  void _saveUserCard() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_imagePath != null && _imagePath!.isNotEmpty) {
        final updatedCard = UserCard(
          id: widget.card.id,
          arasaacId: _arasaacId != null ? int.parse(_arasaacId!) : null,
          userId: widget.card.userId,
          names: {
            LocaleSettings.currentLocale.languageCode: _nameController.text,
          },
          localImgPath: _imagePath ?? '',
        );

        ref.read(cardsProvider.notifier).addCard(updatedCard);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.change_saved)));
        router.pop();
        if (!widget.isNew) router.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.no_image_set)));
      }
    }
  }
}
