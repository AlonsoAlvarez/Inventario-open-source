class Fecha {
  Fecha._();
  static String fecha(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  static String hora(DateTime dateTime) {
    return " ${dateTime.hour}:" + agregarCero(dateTime.minute);
  }

  static String fechaHoraFiles(DateTime dateTime) {
    return '${dateTime.day}_${mes(dateTime.month)}_${dateTime.year}_${dateTime.hour}-${agregarCero(dateTime.minute)}';
  }

  static String fechaFiles(DateTime dateTime) {
    return '${dateTime.day}_${mes(dateTime.month)}_${dateTime.year}';
  }

  static String fechaTiempoSinComparar(DateTime tiempo) {
    return "${tiempo.day} " +
        mes(tiempo.month) +
        " ${tiempo.hour}:" +
        agregarCero(tiempo.minute);
  }

  static String fechaTiempo(DateTime tiempo) {
    DateTime hoy = DateTime.now();
    if (hoy.day == tiempo.day &&
        hoy.month == tiempo.month &&
        hoy.year == tiempo.year) {
      return "Hoy ${tiempo.hour}:" + agregarCero(tiempo.minute);
    } else {
      if ((hoy.day - 1) == tiempo.day &&
          hoy.month == tiempo.month &&
          hoy.year == tiempo.year) {
        return "Ayer" + " ${tiempo.hour}:" + agregarCero(tiempo.minute);
      } else {
        return "${tiempo.day} " +
            mes(tiempo.month) +
            " ${tiempo.hour}:" +
            agregarCero(tiempo.minute);
      }
    }
  }

// ignore: missing_return
  static String mes(int n) {
    if (n == 1) return "ene";
    if (n == 2) return "feb";
    if (n == 3) return "mar";
    if (n == 4) return "abr";
    if (n == 5) return "may";
    if (n == 6) return "jun";
    if (n == 7) return "jul";
    if (n == 8) return "ago";
    if (n == 9) return "sep";
    if (n == 10) return "oct";
    if (n == 11) return "nov";
    if (n == 12) return "dic";
  }

  static String agregarCero(int n) {
    if (n < 10) {
      return "0$n";
    } else {
      return "$n";
    }
  }
}
