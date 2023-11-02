import 'package:flutter/material.dart';

import '../../config/constants.dart';

class CustomDataTable extends StatefulWidget {
  CustomDataTable({Key? key, required this.columns, required this.rows, required this.onRowTap, this.widthList = const <double>[]}) : super(key: key);

  final List<String> columns;
  final List<List<String>> rows;
  final Function(int index) onRowTap;
  List<double> widthList;

  @override
  State<CustomDataTable> createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  late double w; //열의 너비
  late double extendWidth; // 추가 너비 계산
  int hoverIndex = nullInt;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      w = (constraints.maxWidth - 48 - 2) / widget.columns.length; // (maxWidth - tablePadding - borderWidth) / columns.length;
      double tmpSum = 1;
      for(double element in widget.widthList){
        tmpSum += element;
      }
      extendWidth = constraints.maxWidth - 48 - 2 - tmpSum;

      return Column(
        children: [
          header(),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: widget.rows.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return dataRow(
                  dataRow: widget.rows[index],
                  index: index,
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget dataRow({required List<String> dataRow, required int index}) {
    return InkWell(
      onTap: () => widget.onRowTap(index),
      onHover: (value) => setState(() {
        if(value) {
          hoverIndex = index;
        } else {
          hoverIndex = nullInt;
        }
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: hoverIndex == index ? $style.colors.primary : $style.colors.grey),
        ),
        child: Row(
          children: List.generate(
              dataRow.length,
                  (i) => Container(
                alignment: Alignment.centerLeft,
                width: widget.widthList.isEmpty ? w : widget.widthList[i] < 0 ? extendWidth : widget.widthList[i],
                height: 56,
                child: Text(
                  dataRow[i],
                  style: $style.text.body16,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
        ),
      ),
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: List.generate(
            widget.columns.length,
                (index) => Container(
              width: widget.widthList.isEmpty ? w : widget.widthList[index] < 0 ? extendWidth : widget.widthList[index],
              height: 56,
              alignment: Alignment.centerLeft,
              child: Text(
                widget.columns[index],
                style: $style.text.headline20,
                overflow: TextOverflow.ellipsis,
              ),
            )),
      ),
    );
  }
}