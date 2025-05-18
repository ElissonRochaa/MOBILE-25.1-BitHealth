import 'package:flutter/material.dart';

typedef OnSearchChanged = void Function(String);
typedef OnOptionSelected = void Function(String);

class SearchFilterWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final String searchHint;
  final List<String> options;
  final String selectedOption;
  final TextEditingController searchController;
  final OnSearchChanged onSearchChanged;
  final OnOptionSelected onOptionSelected;

  const SearchFilterWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.searchHint,
    required this.options,
    required this.selectedOption,
    required this.searchController,
    required this.onSearchChanged,
    required this.onOptionSelected,
  });

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  bool _isDropdownOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, spreadRadius: 1, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and subtitle
          Row(
            children: [
              const Icon(Icons.search, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Search input
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: widget.searchController,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: widget.searchHint,
                hintStyle: const TextStyle(fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                prefixIconConstraints: const BoxConstraints(minWidth: 30, maxWidth: 30),
                prefixIcon: const Icon(Icons.search, color: Colors.blue, size: 20),
                suffixIcon: widget.searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                        onPressed: () {
                          widget.searchController.clear();
                          widget.onSearchChanged('');
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: widget.onSearchChanged,
            ),
          ),

          const SizedBox(height: 8),

          // Dropdown selector
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isDropdownOpen = !_isDropdownOpen;
                  });
                },
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.selectedOption.isEmpty ? 'Selecione uma opção' : widget.selectedOption,
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.selectedOption.isEmpty ? Colors.grey : Colors.black,
                        ),
                      ),
                      Icon(
                        _isDropdownOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              if (_isDropdownOpen)
                Container(
                  constraints: const BoxConstraints(maxHeight: 150),
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.grey.shade300, spreadRadius: 1, blurRadius: 5)],
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: widget.options.map((option) {
                      return InkWell(
                        onTap: () {
                          widget.onOptionSelected(option);
                          setState(() {
                            _isDropdownOpen = false;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: widget.selectedOption == option ? Colors.blue.shade50 : Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(option, style: const TextStyle(fontSize: 14)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
