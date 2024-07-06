import 'package:flutter/material.dart';
import '../provider/product.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';
import '../widget/app_drawer.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-Screen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  Product _editProduct = Product();
  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_UpdateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        _editProduct = Provider.of<Products>(context, listen: false)
            .findById(productId.toString());
        _initValues = {
          'title': _editProduct.title.toString(),
          'description': _editProduct.description.toString(),
          'price': _editProduct.price.toString(),
          // 'imageUrl': _editProduct.imageUrl.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editProduct.imageUrl.toString();
      }
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_UpdateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _UpdateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      isLoading = true;
    });

    if (_editProduct.id != null) {
      try {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editProduct.id.toString(), _editProduct);
      } catch (error) {
        return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              'An error occured!',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Okay',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
            content: const Text('Something went wrong'),
          ),
        );
      }
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editProduct);
      } catch (error) {
        return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              'An error occured!',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Okay',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
            content: const Text('Something went wrong'),
          ),
        );
      }
      // finally {
      //   setState(() {
      //     isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }

    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onSaved: (value) {
                        _editProduct.title = value;
                        _editProduct.id;
                        _editProduct.isFavourite;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Provide a Title';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: const InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onSaved: (value) {
                        _editProduct.price = double.tryParse(value.toString());
                        _editProduct.id;
                        _editProduct.isFavourite;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a Price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greter than zero';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _editProduct.description = value;
                        _editProduct.id;
                        _editProduct.isFavourite;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ' Please provide little description';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 character long.';
                        }
                        return null;
                      },
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                      // },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.blueGrey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            // initialValue: _initValues['imageUrl'],
                            decoration:
                                const InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onSaved: (value) {
                              _editProduct.imageUrl = value;
                              _editProduct.id;
                              _editProduct.isFavourite;
                              // _editProduct = Product(
                              // id: '',
                              // title: _editProduct.title,
                              // description: _editProduct.description,
                              // price: _editProduct.price,
                              // imageUrl: value.toString(),
                              // );
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a imageUrl';
                              }
                              if (!_imageUrlController.text
                                      .startsWith('http') &&
                                  !_imageUrlController.text
                                      .startsWith('https')) {
                                return 'Please enter a valid imageUrl';
                              }
                              if (!_imageUrlController.text.endsWith('.png') &&
                                  !_imageUrlController.text.endsWith('.jpg') &&
                                  !_imageUrlController.text.endsWith('.jpeg')) {
                                return 'Please enter a valid imageUrl';
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
