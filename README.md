# 🦸‍♂️ Superhero Searcher

Una aplicación desarrollada en **SwiftUI** que permite buscar y explorar superhéroes con un diseño moderno, visualización de estadísticas, y una integración elegante con una API externa. Cada héroe tiene su propia vista detallada con foto, alias y atributos de poder.

---

## 🚀 Características

- 🔍 Búsqueda de superhéroes por ID (integración con API externa)
- 🖼️ Carga de imágenes de héroes desde internet con `SDWebImageSwiftUI`
- 📊 Visualización de estadísticas con `Charts` usando un gráfico circular (pie chart)
- 📱 Interfaz responsiva y moderna con SwiftUI
- 🌑 Soporte para modo oscuro y fondo personalizado

---

## 🛠️ Tecnologías y Frameworks

- **SwiftUI** – UI declarativa nativa de iOS
- **SDWebImageSwiftUI** – Carga eficiente de imágenes desde URLs
- **Charts** – Gráficos nativos de Apple (introducido en iOS 16+)
- **Async/Await** – Llamadas asincrónicas limpias con Swift Concurrency
- **MVVM simplificado** – Separación de lógica de red y vistas

---

## 📂 Estructura del Proyecto

```bash
Superhero/
├── ApiNetwork.swift        # Lógica de red (getHeroById)
├── SuperheroDetail.swift   # Vista de detalle del superhéroe
├── SuperheroStats.swift    # Vista con gráfico de estadísticas
├── Assets.xcassets         # Colores y recursos visuales
└── SuperheroApp.swift      # Punto de entrada de la app
📦 Requisitos

Xcode 15 o superior
iOS 16+
Swift 5.9+
Conexión a internet (la app usa una API externa)
📲 Instalación y ejecución

Clona el repositorio:
git clone https://github.com/tu-usuario/superhero-searcher.git
cd superhero-searcher
Abre el proyecto en Xcode:
open Superhero.xcodeproj
Instala las dependencias con Swift Package Manager:
Ve a File > Add Packages
Agrega:
https://github.com/SDWebImage/SDWebImageSwiftUI
https://github.com/danielgindi/Charts (o usa Charts de Apple si es iOS 16+)
Corre el proyecto en un simulador o dispositivo real.


📌 Notas

Si los valores de estadísticas vienen como "null" en la API, se muestran como 0.
La API debe tener un endpoint como /hero/:id que devuelva datos con este formato:
{
  "name": "Batman",
  "image": { "url": "https://..." },
  "biography": { "aliases": ["The Dark Knight", "Bruce Wayne"] },
  "powerstats": {
    "combat": "90",
    "durability": "50",
    "intelligence": "100",
    ...
  }
}
✨ Autor

Desarrollado por Hyliard (Luis Gerardo)
📧 Contacto: luisgerardomartinezh@gmail.com
📱 Instagram @hyliarrd / GitHub: @hyliard

📄 Licencia

Este proyecto está bajo la Licencia MIT. Puedes usarlo, modificarlo y distribuirlo con libertad.


---
