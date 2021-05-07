import 'package:flutter/material.dart';
import 'package:inventario/models/history.dart';

class ItemHistory extends StatelessWidget {
  final History history;
  final bool isMoney;
  final bool isHoy;

  const ItemHistory(
      {Key key,
      @required this.history,
      @required this.isMoney,
      @required this.isHoy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                isMoney
                    ? history.valor == 0
                        ? 'No hay ingresos'
                        : '\$${history.valor}'
                    : history.valor == 0
                        ? 'No hay ventas'
                        : 'Ventas: ${history.valor.toInt()}',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
              ),
              Spacer(),
              Text(
                isHoy
                    ? history.valor == 0
                        ? ''
                        : '${history.date.hour} hrs.'
                    : '${history.date.day} ${_mes(history.date.month)} ${history.date.year}',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 23),
              ),
            ],
          ),
          Divider()
        ],
      ),
    );
  }

  String _mes(int mes) {
    switch (mes) {
      case 1:
        return 'Ene';
        break;
      case 2:
        return 'Feb';
        break;
      case 3:
        return 'Mar';
        break;
      case 4:
        return 'Abr';
        break;
      case 5:
        return 'May';
        break;
      case 6:
        return 'Jun';
        break;
      case 7:
        return 'Jul';
        break;
      case 8:
        return 'Ago';
        break;
      case 9:
        return 'Sep';
        break;
      case 10:
        return 'Oct';
        break;
      case 11:
        return 'Nov';
        break;
      case 12:
        return 'Dic';
        break;
      default:
        return '$mes';
        break;
    }
  }
}
