class Especificacion {
  Especificacion._();

  static List<String> opciones(String categoria, String esp) {
    switch (categoria) {
      case 'Piso':
        return opcionesPiso(esp);
      case 'Muro':
        return opcionesMuro(esp);
      case 'Cenefas':
        return opcionesCenefa(esp);
      case 'Malla decorativa':
        return opcionesMallaDecorativa(esp);
      case 'Terminado decorativo':
        return opcionesTerminadoDecorativo(esp);
      default:
        return [];
    }
  }

  static List<String> opcionesPiso(String especificacion) {
    switch (especificacion) {
      case "Tipo de material":
        return [
          'Cerámico',
          'Porcelánico',
          'Porcelánico coloreado',
          'Super Gres'
        ];
      case "Comercial/Residencial":
        return ['Comercial y Residencial', 'Comercial', 'Residencial'];
      case "Uso":
        return ['Interior y Exterior', 'Interior', 'Exterior'];
      case "Acabado":
        return ['Mate', 'Satinado', 'Brillante'];
      case "Apariencia":
        return ['Piedra', 'Marmol', 'Madera'];
      case "Color":
        return [
          'Blanco',
          'Negro',
          'Gris',
          'Verde',
          'Rojo',
          'Teja',
          'Azul',
          'Ocre',
          'Rosa',
          'Violeta',
          'Cafe'
        ];
      case "PEI":
        return [
          'PEI II Uso residencial, trafico moderado',
          'PEI III Uso comercial trafico ligero',
          'PEI IV Uso comercial trafico moderado',
          'PEI V Uso comercial trafico pesado'
        ];
      default:
        return [];
    }
  }

  static List<String> opcionesMuro(String especificacion) {
    switch (especificacion) {
      case "Tipo de material":
        return ['Cuerpo Blanco', 'Cerámico', 'Porcelánico', 'Super Gres'];
      case "Comercial/Residencial":
        return ['Comercial y Residencial', 'Comercial', 'Residencial'];
      case "Uso":
        return ['Interior y Exterior', 'Interior', 'Exterior'];
      case "Acabado":
        return ['Mate', 'Satinado', 'Brillante'];
      case "Apariencia":
        return [
          'Piedra',
          'Marmoleado',
          'Madera',
          'Color Solido',
          'Diseño Decorativo'
        ];
      case "Color":
        return [
          'Blanco',
          'Negro',
          'Gris',
          'Verde',
          'Rojo',
          'Teja',
          'Azul',
          'Ocre',
          'Rosa',
          'Violeta',
          'Cafe'
        ];
      case "PEI":
        return [
          'PEI II Uso residencial, trafico moderado',
          'PEI III Uso comercial trafico ligero',
          'PEI IV Uso comercial trafico moderado',
          'PEI V Uso comercial trafico pesado'
        ];
      default:
        return [];
    }
  }

  static List<String> opcionesCenefa(String especificacion) {
    switch (especificacion) {
      case "Tipo de material":
        return ['Cerámico'];
      case "Comercial/Residencial":
        return ['Comercial y Residencial'];
      case "Uso":
        return ['Interior'];
      case "Acabado":
        return ['Mate', 'Satinado', 'Brillante'];
      case "Apariencia":
        return [
          'Piedra',
          'Marmoleado',
          'Madera',
          'Color Solido',
          'Diseño Decorativo'
        ];
      case "Color":
        return [
          'Blanco',
          'Negro',
          'Gris',
          'Verde',
          'Rojo',
          'Teja',
          'Azul',
          'Ocre',
          'Rosa',
          'Violeta',
          'Cafe'
        ];
      default:
        return [];
    }
  }

  static List<String> opcionesMallaDecorativa(String especificacion) {
    switch (especificacion) {
      case "Tipo de material":
        return [
          'Metálico/Cristal',
          'Piedra/Cristal',
          'Cerámica/Cristal',
          'Carámica/Cristal',
          'Metálico',
          'Cristal',
          'Piedra'
        ];
      case "Comercial/Residencial":
        return ['Comercial y Residencial'];
      case "Uso":
        return ['Interior y Exterior', 'Interior', 'Exterior'];
      case "Acabado":
        return ['Mate', 'Satinado', 'Brillante'];
      case "Apariencia":
        return [
          'Piedra',
          'Marmoleado',
          'Madera',
          'Color Solido',
          'Diseño Decorativo'
        ];
      case "Color":
        return [
          'Blanco',
          'Negro',
          'Gris',
          'Verde',
          'Rojo',
          'Teja',
          'Azul',
          'Ocre',
          'Rosa',
          'Violeta',
          'Cafe'
        ];
      default:
        return [];
    }
  }

  static List<String> opcionesTerminadoDecorativo(String especificacion) {
    switch (especificacion) {
      case "Tipo de material":
        return [
          'Plástico',
          'Aluminio',
        ];
      case "Comercial/Residencial":
        return ['Comercial y Residencial'];
      case "Piso o Muro":
        return ['Piso', 'Muro'];
      case "Acabado":
        return ['Mate', 'Satinado', 'Brillante'];
      case "Apariencia":
        return [
          'Piedra',
          'Marmoleado',
          'Madera',
          'Color Solido',
          'Diseño Decorativo'
        ];
      case "Color":
        return [
          'Blanco',
          'Negro',
          'Gris',
          'Verde',
          'Rojo',
          'Teja',
          'Azul',
          'Ocre',
          'Rosa',
          'Violeta',
          'Cafe'
        ];
      default:
        return [];
    }
  }
}
