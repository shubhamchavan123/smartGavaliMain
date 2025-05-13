import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_gawali/features/category/presentation/screen/calcium_mineral_mixture_product_list_model.dart';
import 'package:smart_gawali/features/category/presentation/screen/calcium_mineral_mixture_product_list_screen.dart';
import 'package:smart_gawali/features/login/presentation/screen/MyCartScreen.dart';
import 'package:smart_gawali/provider/calcium_mineral_product_provider.dart';

class AddToCart extends StatefulWidget {
  final String subCatId;
  const AddToCart({super.key, required this.subCatId});

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<CalciumMineralProductProvider>(context, listen: false)
  //         .fetchProducts(widget.subCatId);
  //   });
  // }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CalciumMineralProductProvider>(context, listen: false);
      provider.loadCartFromPreferences(); // Load cart data
      provider.fetchProducts(widget.subCatId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'उत्पादने',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        leading: Container(
          margin: const EdgeInsets.all(8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        // actions: [
        //   Container(
        //     margin: EdgeInsets.all(7),
        //     decoration: BoxDecoration(
        //       color: Colors.brown,
        //       shape: BoxShape.circle,
        //     ),
        //     child: IconButton(
        //       icon: Icon(Icons.shopping_cart, color: Colors.white),
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(builder: (context) => MyCartScreen()),
        //         );
        //       },
        //     ),
        //   )
        // ],
        actions: [
          Container(
            margin: const EdgeInsets.all(7),
            decoration: const BoxDecoration(
              color: Colors.brown,
              shape: BoxShape.circle,
            ),
            child: Consumer<CalciumMineralProductProvider>(
              builder: (context, provider, _) {
                final cartCount = provider.selectedProducts.fold<int>(
                  0,
                      (sum, product) => sum + provider.getQuantity(product),
                );

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyCartScreen()),
                        );
                      },
                    ),
                    if (cartCount > 0)
                      Positioned(
                        top: -5,
                        right: -5,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Text(
                            cartCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          )
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFFFFFFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Consumer<CalciumMineralProductProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = provider.products;

          if (products.isEmpty) {
            return const Center(child: Text("उत्पादने उपलब्ध नाहीत."));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
              itemBuilder: (context, index) {
                final product = products[index];
                final quantity = provider.getQuantity(product);

                return Card(
                  color: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailsScreen(productId: product.id),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product.image,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  'assets/images/placeholder.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailsScreen(productId: product.id),
                              ),
                            );
                          },
                          child: Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "किंमत: ${product.price}",
                          style: const TextStyle(fontSize: 13),
                        ),
                        Text(
                          "प्रमाण: ${product.quantity}",
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        quantity == 0
                            ? Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                child: const Text(
                                  "ADD",
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onPressed: () => provider.increment(product),
                              ),
                            ],
                          ),
                        )
                            : Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                color: Colors.blue,
                                onPressed: quantity > 0
                                    ? () => provider.decrement(product)
                                    : null,
                              ),
                              Text(quantity.toString()),
                              IconButton(
                                icon: const Icon(Icons.add),
                                color: Colors.blue,
                                onPressed: () => provider.increment(product),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

            // itemBuilder: (context, index) {
            //   final product = products[index];
            //   final quantity = provider.getQuantity(product);
            //
            //   return GestureDetector(
            //     onTap: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) =>
            //               ProductDetailsScreen(productId: product.id),
            //         ),
            //       );
            //     },
            //     child: Card(
            //       color: Colors.white,
            //       elevation: 3,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10)),
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Column(
            //           children: [
            //             Expanded(
            //               child: ClipRRect(
            //                 borderRadius: BorderRadius.circular(8),
            //                 child: Image.network(
            //                   product.image,
            //                   fit: BoxFit.cover,
            //                   width: double.infinity,
            //                   errorBuilder: (_, __, ___) => Image.asset(
            //                     'assets/images/placeholder.png',
            //                     fit: BoxFit.cover,
            //                     width: double.infinity,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //             const SizedBox(height: 8),
            //             Text(
            //               product.name,
            //               style: const TextStyle(fontWeight: FontWeight.bold),
            //               textAlign: TextAlign.center,
            //               maxLines: 2,
            //               overflow: TextOverflow.ellipsis,
            //             ),
            //             const SizedBox(height: 4),
            //             Text(
            //               "किंमत: ${product.price}",
            //               style: const TextStyle(fontSize: 13),
            //             ),
            //             Text(
            //               "प्रमाण: ${product.quantity}",
            //               style: const TextStyle(fontSize: 13),
            //             ),
            //             const SizedBox(height: 4),
            //             quantity == 0
            //                 ? Container(
            //                     // padding: EdgeInsets.all(0),
            //                     decoration: BoxDecoration(
            //                         color: Colors.white,
            //                         borderRadius: BorderRadius.circular(12),
            //                         border: Border.all(color: Colors.blue)),
            //                     child: Row(
            //                       mainAxisAlignment: MainAxisAlignment.center,
            //                       children: [
            //                         TextButton(
            //                           child: const Text(
            //                             "ADD",
            //                             style: TextStyle(color: Colors.blue),
            //                           ),
            //                           onPressed: () =>
            //                               provider.increment(product),
            //                         ),
            //                       ],
            //                     ),
            //                   )
            //                 : Container(
            //                     decoration: BoxDecoration(
            //                       color: Colors.white,
            //                       borderRadius: BorderRadius.circular(12),
            //                       border: Border.all(color: Colors.blue),
            //                     ),
            //                     child: Row(
            //                       mainAxisAlignment: MainAxisAlignment.center,
            //                       children: [
            //                         IconButton(
            //                           icon: const Icon(Icons.remove),
            //                           color: Colors.blue,
            //                           onPressed: quantity > 0
            //                               ? () => provider.decrement(product)
            //                               : null,
            //                         ),
            //                         Text(quantity.toString()),
            //                         IconButton(
            //                           icon: const Icon(Icons.add),
            //                           color: Colors.blue,
            //                           onPressed: () =>
            //                               provider.increment(product),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   );
            // },
          );
        },
      ),
    );
  }
}
