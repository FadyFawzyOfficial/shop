import 'package:flutter/material.dart';

import '../providers/product.dart';

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
  final _formKey = GlobalKey<FormState>();
  var _product = Product.initial();

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
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save_rounded),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Title'),
              textInputAction: TextInputAction.next,
              onSaved: (title) => _product = _product.copyWith(title: title),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Price'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              onSaved: (price) => _product = _product.copyWith(
                price: double.tryParse(price ?? '0'),
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              onSaved: (description) => _product = _product.copyWith(
                description: description,
              ),
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
                    onSaved: (imageUrl) => _product = _product.copyWith(
                      imageUrl: imageUrl,
                    ),
                    // Maybe form.currentState.save effect == setState effect
                    onFieldSubmitted: (_) => _saveForm(),
                  ),
                ),
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

  void _saveForm() {
    _formKey.currentState!.save();
    print(_product);
  }
}
