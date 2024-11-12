class Persona {
  var property recursos = 20
  var edad

  method esDestacado() = edad.between(18, 65) || recursos > 30
  method ganarMonedas(cantidad) {
    recursos += cantidad
  }
  method gastarMonedas(cantidad) {
    recursos -= cantidad
  }
  method cumplirAnios() {
    edad += 1
  }
  method trabajarEnPlaneta(planeta, tiempo)
}
class Productor inherits Persona {
  const viveEn
  const tecnicas = ["cultivo"]

  override method recursos() = super() * self.cantTecnicas()
  method cantTecnicas() = tecnicas.size()
  override method esDestacado() = super() || self.cantTecnicas() > 5
  method realizarTecnicaPor(tecnica, tiempo) {
    if (self.conoce(tecnica)) {
      self.ganarMonedas(3 * tiempo)
    }
    else {
      self.gastarMonedas(1)
    }
  }
  method conoce(tecnica) = tecnicas.contains(tecnica)
  method aprenderTecnica(tecnica) {
    tecnicas.add(tecnica)
  }
  override method trabajarEnPlaneta(planeta, tiempo) {
    if (planeta == viveEn) {
      self.realizarTecnicaPor(tecnicas.last(), tiempo)
    }
  }
}
class Constructor inherits Persona {
  var construccionesRealizadas
  const region
  var property inteligencia

  override method recursos() = super() + (10 * construccionesRealizadas.size())
  override method trabajarEnPlaneta(planeta, tiempo) {
    planeta.construir(region.construccion(self, tiempo))
    construccionesRealizadas += 1
    self.gastarMonedas(5)
  }
}
object montania {
  method construccion(unConstructor, tiempo) {
    return new Muralla(longitud=tiempo/2)
  }
}
object costa {
  method construccion(unConstructor, tiempo) {
    return new Museo(superficie=tiempo, importancia=1)
  }
}
object llanura {
  method construccion(unConstructor, tiempo) {
    if (!unConstructor.esDestacado()) {
      return new Muralla(longitud=tiempo/2)
    }
    else {
      return new Museo(superficie=tiempo, importancia=unConstructor.recursos())
    }
  }
}
object selva { //nueva region
  method construccion(unConstructor, tiempo) {
      if (unConstructor.inteligencia() >= 50) {
        return new Museo(superficie=tiempo, importancia=2)
      }
      else {
        return new Muralla(longitud=tiempo/2)
      }
    }
}

class Construccion {

  method valor()
}
class Muralla inherits Construccion {
  const longitud

  override method valor() = longitud * 10 //duda
}
class Museo inherits Construccion {
  const superficie
  const importancia //de 1 a 5

  override method valor() = superficie * importancia
}

class Planeta {
  const personas
  const property construcciones
  const delegacion

  method delegacion() =
    delegacion.add(self.habitantesDestacados()) +
    delegacion.add(self.habitanteMasRecursos())
  method habitantesDestacados() = personas.filter({p => p.esDestacado()})
  method habitanteMasRecursos() = personas.max({p => p.recursos()})
  method esValioso() = self.valorTotalConstrucciones() > 100
  method valorTotalConstrucciones() = construcciones.sum({c => c.valor()})
  method construir(constr)
}