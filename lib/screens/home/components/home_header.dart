import 'package:Wishy/models/Tag.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class HomeHeader extends StatefulWidget {
  final double? height;
  final ValueChanged<Tag?> onTagSelected;

  const HomeHeader({
    Key? key,
    this.height,
    required this.onTagSelected,
  }) : super(key: key);

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  GraphQLPaginationService _paginationServices = new GraphQLPaginationService(
    queryName: "getAllTags",
    variables: {"limit": 20},
  );
  List<Tag> _tags = [];

  Future<void> fetchData() async {
    final result = await _paginationServices.run();

    if (mounted && result["data"] != null) {
      print(_tags.length);
      setState(() {
        _tags = (result["data"] as List<dynamic>)
            .map((item) => Tag.fromJson(item))
            .toList();
      });
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterDialog(
          tags: _tags,
          onTagSelected: (selectedTag) {
            widget.onTagSelected(selectedTag);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Wishy",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: getProportionateScreenWidth(16),
              ),
            ),
            IconButton(
              icon: Icon(Icons.filter_list), // Filter icon
              onPressed: _showFilterDialog,
            ),
          ],
        ),
      ),
    );
  }
}

class FilterDialog extends StatelessWidget {
  final List<Tag> tags;
  final ValueChanged<Tag?> onTagSelected;

  FilterDialog({
    required this.tags,
    required this.onTagSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
                ListTile(
                  title: Text('All Products'),
                  onTap: () => onTagSelected(null),
                ),
                Divider(),
              ] +
              tags.map((Tag tag) {
                return ListTile(
                  title: Text(tag.value),
                  onTap: () => onTagSelected(tag),
                );
              }).toList(),
        ),
      ),
    );
  }
}
