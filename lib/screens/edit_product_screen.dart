import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

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
  late final _passedProduct =
      ModalRoute.of(context)?.settings.arguments as Product?;
  late final _isUpdating = _passedProduct == null ? false : true;
  late var _product = _passedProduct ?? Product.initial();
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImagePreview);
  }

  @override
  Widget build(BuildContext context) {
    if (_product.imageUrl != '') {
      _imageUrlController.text = _product.imageUrl;
    }
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    initialValue: _product.title,
                    decoration: const InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                    validator: (title) {
                      if (title == null || title.isEmpty) {
                        return 'Please, provide the product title.';
                      }
                      return null;
                    },
                    onSaved: (title) =>
                        _product = _product.copyWith(title: title),
                  ),
                  TextFormField(
                    initialValue:
                        '${_product.price != 0 ? _product.price : ''}',
                    decoration: const InputDecoration(labelText: 'Price'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    validator: (price) {
                      if (price == null || price.isEmpty) {
                        return 'Please, provide the product price.';
                      }
                      if (double.tryParse(price) == null) {
                        return 'Please, enter a valid price.';
                      }
                      if (double.parse(price) <= 0) {
                        return 'Please, enter a number greater than zero.';
                      }
                      return null;
                    },
                    onSaved: (price) => _product = _product.copyWith(
                      price: double.tryParse(price ?? '0'),
                    ),
                  ),
                  TextFormField(
                    initialValue: _product.description,
                    decoration: const InputDecoration(labelText: 'Description'),
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    validator: (description) {
                      if (description == null || description.isEmpty) {
                        return 'Please, enter a product description.';
                      }
                      if (description.length < 10) {
                        return 'Product description should be at least 10 characters.';
                      }
                      return null;
                    },
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
                        margin:
                            const EdgeInsetsDirectional.only(top: 16, end: 16),
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
                          decoration:
                              const InputDecoration(labelText: 'Image URL'),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.url,
                          controller: _imageUrlController,
                          validator: (url) {
                            if (url == null || url.isEmpty) {
                              return 'Please, enter an image URL.';
                            }
                            if (!url.startsWith('http')) {
                              return 'Please, enter a valid URL.';
                            }
                            if (!url.endsWith('png') &&
                                !url.endsWith('jpg') &&
                                !url.endsWith('jpeg')) {
                              return 'Please, enter a valid image URL.';
                            }
                            return null;
                          },
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
    _imageUrlFocusNode.removeListener(_updateImagePreview);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  //* Don't show a preview if we have an incorrect URL.
  void _updateImagePreview() {
    if (!_imageUrlFocusNode.hasFocus) {
      final url = _imageUrlController.text;
      if (!url.startsWith('http') ||
          (!url.endsWith('png') &&
              !url.endsWith('jpg') &&
              !url.endsWith('jpeg'))) return;
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final formCurrentState = _formKey.currentState;
    final productsProvider = Provider.of<Products>(context, listen: false);
    if (formCurrentState == null || !formCurrentState.validate()) return;
    formCurrentState.save();
    debugPrint('$_product');
    setState(() => _isLoading = true);
    if (_isUpdating) {
      productsProvider.updateProduct(_product);
      setState(() => _isLoading = false);
      Navigator.pop(context);
    } else {
      try {
        await productsProvider.addProduct(_product);
      } catch (e) {
        // Handle the thrown error and Show dialog that shows error message
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('An error occurred!'),
            content: const Text('Something went wrong!'),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      } finally {
        // The following will execute after dialog closed by user.
        setState(() => _isLoading = false);
        Navigator.pop(context);
      }
    }
  }
}
