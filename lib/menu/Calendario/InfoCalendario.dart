class InfoCalendario {
  // Método estático para obtener un mapa de los días del calendario junto con su descripción
  static Map<DateTime, String> getDias() {
    return {
      DateTime(2023, 1, 1): "Año Nuevo",
      DateTime(2023, 1, 6): "Epifanía del Señor",
      DateTime(2023, 4, 14): "Viernes Santo",
      DateTime(2023, 4, 17): "Lunes de Pascua",
      DateTime(2023, 5, 1): "Día del Trabajo",
      DateTime(2023, 5, 2): "Día de la Comunidad de Madrid",
      DateTime(2023, 8, 15): "Asunción de la Virgen",
      DateTime(2023, 10, 9): "Día de la Comunitat Valenciana",
      DateTime(2023, 10, 12): "Fiesta Nacional de España",
      DateTime(2023, 11, 1): "Día de Todos los Santos",
      DateTime(2023, 12, 6): "Día de la Constitución Española",
      DateTime(2023, 12, 8): "Inmaculada Concepción",
      DateTime(2023, 12, 24): "Nochebuena",
      DateTime(2023, 12, 25): "Navidad",
      DateTime(2023, 12, 31): "Nochevieja",
    };
  }

  // Método estático para obtener un mapa de los días festivos del calendario junto con su descripción
  static Map<DateTime, String> getDiasFestivos() {
    // Agregar más días festivos si es necesario
    return {
      DateTime(2023, 1, 1): "Año Nuevo",
      DateTime(2023, 1, 6): "Epifanía del Señor",
      DateTime(2023, 4, 14): "Viernes Santo",
      DateTime(2023, 4, 17): "Lunes de Pascua",
      DateTime(2023, 5, 1): "Día del Trabajo",
      DateTime(2023, 5, 2): "Día de la Comunidad de Madrid",
      DateTime(2023, 8, 15): "Asunción de la Virgen",
      DateTime(2023, 10, 9): "Día de la Comunitat Valenciana",
      DateTime(2023, 10, 12): "Fiesta Nacional de España",
      DateTime(2023, 11, 1): "Día de Todos los Santos",
      DateTime(2023, 12, 6): "Día de la Constitución Española",
      DateTime(2023, 12, 8): "Inmaculada Concepción",
      DateTime(2023, 12, 24): "Nochebuena",
      DateTime(2023, 12, 25): "Navidad",
      DateTime(2023, 12, 31): "Nochevieja",
      // Dejar vacío por ahora
    };
  }
}
