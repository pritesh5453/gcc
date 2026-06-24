import 'package:flutter/material.dart';
import 'package:gcc/prefs/PreferencesKey.dart';
import 'package:gcc/prefs/app_preference.dart';
import 'package:gcc/Models_nServices/transaction/transaction_model.dart';
import 'package:gcc/Models_nServices/transaction/transaction_svc.dart';
import 'package:gcc/Screens/comman_appbar/comman_appbar.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final TransactionService _service = TransactionService();
  final AppPreference _appPref = AppPreference();

  List<TransactionItemModel> allTransactions = [];
  List<TransactionItemModel> filteredTransactions = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  String? errorMessage;
  String selectedFilter = 'All';

  // Wallet balances
  int totalAmountHeld = 0;
  int utilizedBalance = 0;
  int unutilizedBalance = 0;

  // Pagination
  int currentPage = 1;
  int lastPage = 1;
  bool hasMorePages = true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadFirstPage();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!isLoadingMore && hasMorePages && !isLoading) {
        _loadMore();
      }
    }
  }

  Future<void> _loadFirstPage() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      currentPage = 1;
      allTransactions = [];
      hasMorePages = true;
    });
    await _fetchTransactions(reset: true);
  }

  Future<void> _loadMore() async {
    if (!hasMorePages || isLoadingMore) return;
    setState(() {
      isLoadingMore = true;
      currentPage++;
    });
    await _fetchTransactions(reset: false);
  }

  Future<void> _fetchTransactions({required bool reset}) async {
    try {
      final token = _appPref.getString(PreferencesKey.authToken);

      print("===== AUTH TOKEN =====");
      print(token);
      if (token.isEmpty) {
        throw Exception('Authentication token missing');
      }

      final response = await _service.getTransactions(
        token: token,
        page: currentPage,
        perPage: 10,
      );

      if (response != null && response.success) {
        setState(() {
          if (reset) {
            allTransactions = response.data.transactions;
            // Update wallet balances only on first page
            totalAmountHeld =
                response.data.wallet.walletBalance.totalAmountHeld;
            utilizedBalance =
                response.data.wallet.walletBalance.utilizedBalance;
            unutilizedBalance =
                response.data.wallet.walletBalance.unutilizedBalance;
          } else {
            allTransactions.addAll(response.data.transactions);
          }
          lastPage = response.data.pagination.lastPage;
          hasMorePages = currentPage < lastPage;
          _applyFilter();
        });
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        if (reset) allTransactions = [];
      });
    } finally {
      setState(() {
        isLoading = false;
        isLoadingMore = false;
      });
    }
  }

  void _applyFilter() {
    if (selectedFilter == 'All') {
      filteredTransactions = List.from(allTransactions);
    } else {
      filteredTransactions =
          allTransactions
              .where(
                (tx) => tx.type.toLowerCase() == selectedFilter.toLowerCase(),
              )
              .toList();
    }
    setState(() {});
  }

  void _onFilterSelected(String filter) {
    selectedFilter = filter;
    _applyFilter();
  }

  String _getDisplayStatus(TransactionItemModel tx) {
    if (tx.type.toLowerCase() == 'deposit') {
      if (tx.status.toLowerCase() == 'pending') return 'Pending';
      if (tx.status.toLowerCase() == 'completed') return 'Approved';
    }
    return tx.status;
  }

  (Color color, IconData icon) _getTypeStyle(String type) {
    switch (type.toLowerCase()) {
      case 'buy':
        return (Colors.green, Icons.arrow_downward);
      case 'sell':
        return (Colors.red, Icons.arrow_upward);
      default:
        return (Colors.grey, Icons.remove);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF8),
      body: SafeArea(
        child: Column(
          children: [
            const CommonAppBar(title: 'Transaction History', showHelp: false),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildFilterChips(),
                    const SizedBox(height: 16),
                    Expanded(child: _buildTransactionList()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── FILTER CHIPS – CENTERED ──────────────────────────────────────────────
  Widget _buildFilterChips() {
    final filters = ['All', 'buy', 'sell'];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: filters.map((label) {
            final isSelected = selectedFilter == label;
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: FilterChip(
                label: Text(label[0].toUpperCase() + label.substring(1)),
                selected: isSelected,
                onSelected: (_) => _onFilterSelected(label),
                backgroundColor: Colors.white,
                selectedColor: Colors.green[800],
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? Colors.green[800]! : Colors.grey.shade300,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ─── TRANSACTION LIST – WITH ARROW INDICATOR ─────────────────────────────
  Widget _buildTransactionList() {
    if (isLoading && allTransactions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null && allTransactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadFirstPage,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (filteredTransactions.isEmpty && !isLoading) {
      return const Center(child: Text('No transactions found'));
    }

    return ListView.separated(
      controller: _scrollController,
      itemCount: filteredTransactions.length + (isLoadingMore ? 1 : 0),
      separatorBuilder:
          (_, __) =>
              Divider(height: 1, indent: 70, color: Colors.grey.shade100),
      itemBuilder: (context, index) {
        if (index == filteredTransactions.length && isLoadingMore) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final tx = filteredTransactions[index];
        final (color, icon) = _getTypeStyle(tx.type);
        final displayStatus = _getDisplayStatus(tx);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            title: Text(
              tx.type[0].toUpperCase() + tx.type.substring(1),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: Text(
              tx.createdAt,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            // ─── TRAILING NOW INCLUDES A CHEVRON ARROW ─────────────────────
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "₹${tx.amountInr.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: color,
                      ),
                    ),
                    if (tx.type.toLowerCase() == 'deposit')
                      Text(
                        displayStatus,
                        style: TextStyle(
                          fontSize: 10,
                          color:
                              displayStatus == 'Approved'
                                  ? Colors.green
                                  : Colors.orange,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
              ],
            ),
            onTap: () => _showTransactionDetails(context, tx),
          ),
        );
      },
    );
  }

  // ─── DETAILS BOTTOM SHEET ─────────────────────────────────────────────────
  void _showTransactionDetails(BuildContext context, TransactionItemModel tx) {
    final (color, icon) = _getTypeStyle(tx.type);
    final displayStatus = _getDisplayStatus(tx);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (ctx) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: color.withOpacity(0.1),
                      child: Icon(icon, color: color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tx.type[0].toUpperCase() + tx.type.substring(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            displayStatus,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "₹${tx.amountInr.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 12),
                _detailRow('Transaction ID', tx.id.toString()),
                _detailRow('Date & Time', tx.createdAt),
                _detailRow('Status', displayStatus),
                if (tx.type == 'deposit' && tx.utrNumber != null)
                  _detailRow('UTR Number', tx.utrNumber!),
                if (tx.type != 'deposit' && tx.coin != null) ...[
                  _detailRow('Coin', '${tx.coin!.name} (${tx.coin!.symbol})'),
                  _detailRow('Coin Qty', tx.amountCoin.toStringAsFixed(4)),
                  _detailRow(
                    'Price per unit',
                    '₹${tx.priceAtTransaction.toStringAsFixed(2)}',
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Close',
                    style : TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}