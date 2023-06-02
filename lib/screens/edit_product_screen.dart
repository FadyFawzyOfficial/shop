import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'editProduct';

  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  //! For the Image Preview I want to get access the url text of TextFormField
  //! and it's FocusNode to update the Image Preview with that ImageURL text and
  //! while the ImageUrl Input Field loosing the FocusNode.
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Title'),
              textInputAction: TextInputAction.next,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Price'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              // textInputAction: TextInputAction.next,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsetsDirectional.only(top: 16, end: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _imageUrlController.text.isEmpty
                      ? const Text('Enter a URL')
                      : Image.network(
                          _imageUrlController.text,
                          fit: BoxFit.cover,
                        ),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Image URL'),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.url,
                    controller: _imageUrlController,
                    //* Review "Image Input & Image Preview.mp4" video if you
                    //* get Stacked
                    //! With this _imageUrlFocusNode and its added Listener,
                    //! we get the preview when we lose focus
                    focusNode: _imageUrlFocusNode,
                    //! onFieldSubmitted Dismisses the SoftKeyboard when done
                    //! onEditingComplete doesn't
                    onFieldSubmitted: (_) => setState(() {}),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  //! Don't forget to dispose the Controllers & Listeners.
  @override
  void dispose() {
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }
}
