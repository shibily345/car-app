import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_app_beta/core/resources/data_state.dart';
import '../../business/entities/sale_entity.dart';
import '../providers/sale_provider.dart';

class SaleListPage extends StatefulWidget {
  const SaleListPage({super.key});

  @override
  State<SaleListPage> createState() => _SaleListPageState();
}

class _SaleListPageState extends State<SaleListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SaleProvider>(context, listen: false).getAllSales();
    });
  }

  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context);
    final salesState = saleProvider.allSalesState;
    final isLoading = saleProvider.isLoading;
    final error = saleProvider.errorMessage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Sales'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => saleProvider.getAllSales(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "addSaleListFAB",
        onPressed: () => Navigator.pushNamed(context, '/addSale'),
        icon: const Icon(Icons.add),
        label: const Text('Add Sale'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text('Error: $error'))
              : (salesState?.data?.isEmpty ?? true)
                  ? const Center(child: Text('No sales found.'))
                  : ListView.builder(
                      itemCount: salesState!.data!.length,
                      itemBuilder: (context, index) {
                        final sale = salesState.data![index];
                        return ListTile(
                          title: Text('Car: ${sale.carId}'),
                          subtitle: Text(
                              'Price: ${sale.price}\nStatus: ${sale.status}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => Navigator.pushNamed(
                              context,
                              '/editSale',
                              arguments: sale,
                            ),
                          ),
                          onLongPress: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Sale'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Are you sure you want to delete this sale?',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Car: ${sale.carId}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Price: \$${sale.price}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'This action cannot be undone.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              try {
                                await saleProvider.deleteSale(sale.id!);

                                if (saleProvider.deleteSaleState
                                    is DataSuccess) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Sale deleted successfully!'),
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  saleProvider.getAllSales();
                                } else if (saleProvider.errorMessage != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Failed to delete sale: ${saleProvider.errorMessage}'),
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 3),
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error deleting sale: $e'),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                            }
                          },
                        );
                      },
                    ),
    );
  }
}
