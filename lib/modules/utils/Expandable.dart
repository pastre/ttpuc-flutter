
import 'package:flutter/material.dart';

class ListItem {
  final WidgetBuilder bodyBuilder;
  final Text title;
  final RichText notas;
  final RichText faltas;
  bool isExpandedInitially;

  ListItem({
    @required this.bodyBuilder,
    this.title = null,
    this.notas = null,
    this.faltas = null,
    this.isExpandedInitially = false,
  })  : assert(title != null),
        assert(bodyBuilder != null);

  ExpansionPanelHeaderBuilder get headerBuilder =>
          (context, isExpanded) => new Column(children: [
            (title),
//            (notas),
            (faltas),
      ], crossAxisAlignment: CrossAxisAlignment.stretch, );
}

class ExpansionList extends StatefulWidget {
  /// The items that the expansion list should display; this can change
  /// over the course of the object but probably shouldn't as it won't
  /// transition nicely or anything like that.
  final List<ListItem> items;

  ExpansionList(this.items) {
    assert(new Set.from(items.map((li) => li.title)).length == items.length);
  }

  @override
  State<StatefulWidget> createState() => new ExpansionListState();
}

class ExpansionListState extends State<ExpansionList> {
  Map<String, bool> expandedByTitle = new Map();

  @override
  Widget build(BuildContext context) {
    return new ExpansionPanelList(
      children: widget.items
          .map(
            (item) => new ExpansionPanel(
            headerBuilder: item.headerBuilder,
            body: new Builder(builder: item.bodyBuilder),
            isExpanded:
            expandedByTitle[item.title] ?? item.isExpandedInitially),
      )
          .toList(growable: false, ),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          expandedByTitle[widget.items[index].title.data] = !isExpanded;
        });
      },
    );
  }
}
