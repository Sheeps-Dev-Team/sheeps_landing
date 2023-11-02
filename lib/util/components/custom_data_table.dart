import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
          SizedBox(height: 16 * sizeUnit),
          Expanded(
            child: ListView.separated(
              itemCount: widget.rows.length,
              separatorBuilder: (context, index) => SizedBox(height: 12 * sizeUnit),
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
        padding: EdgeInsets.symmetric(horizontal: 18 * sizeUnit),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular($style.corners.$4),
          border: Border.all(color: hoverIndex == index ? $style.colors.primary : $style.colors.grey),
        ),
        child: Row(
          children: List.generate(
              dataRow.length,
                  (i) => Container(
                alignment: Alignment.centerLeft,
                width: widget.widthList.isEmpty ? w : widget.widthList[i] < 0 ? extendWidth : widget.widthList[i],
                height: 56 * sizeUnit,
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
      padding: EdgeInsets.symmetric(horizontal: $style.insets.$24),
      child: Row(
        children: List.generate(
            widget.columns.length,
                (index) => Container(
              width: widget.widthList.isEmpty ? w : widget.widthList[index] < 0 ? extendWidth : widget.widthList[index],
              height: 56 * sizeUnit,
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Text(
                    widget.columns[index],
                    style: $style.text.headline20,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gap($style.insets.$16),
                  Divider(
                    height: 1 * sizeUnit,
                    thickness: 2 * sizeUnit,
                    color: $style.colors.lightGrey,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}