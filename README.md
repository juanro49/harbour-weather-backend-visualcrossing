# Visual Crossing Weather Backend for Sailfish OS

Este es un plugin externo para la aplicación nativa **Sailfish Weather** que permite utilizar los servicios meteorológicos de **Visual Crossing**.

## ✨ Características

- **Acceso Gratuito e Inmediato:** Registro **sin tarjeta de crédito**, con **1.000 créditos diarios** gratuitos (un pronóstico completo de 15 días consume solo 1 crédito).
- **Tecnología Timeline API:** Implementación optimizada para la arquitectura de baja latencia de Visual Crossing.
- **Eficiencia de Datos:** Uso selectivo de campos (`elements`) para minimizar el consumo de datos y acelerar la carga.
- **Alta Precisión:** Datos basados en modelos híbridos globales (Ensemble forecasting, ERA5 y estaciones locales).
- **Pronóstico Detallado:** Basado en la [API Timeline](https://www.visualcrossing.com/weather-api) de Visual Crossing.
- **Pronóstico Horario:** Datos precisos hora por hora para las próximas 48 horas.
- **Pronóstico Diario:** Hasta 15 días de previsión meteorológica.
- **Ligero:** Integración nativa sin necesidad de aplicaciones adicionales.
- **Privacidad Técnica:** Las peticiones se realizan directamente desde tu dispositivo al proveedor.

## 🚀 Instalación

### Vía OpenRepos
1. Busca **Visual Crossing Weather Backend** en Storeman o instálalo directamente desde la web de [OpenRepos](https://openrepos.net/content/juanro49/visual-crossing-weather-backend).
2. Si te has descargado el rpm, instálalo usando la terminal:
   ```bash
   devel-su pkcon install-local harbour-weather-backend-visualcrossing-*.rpm
   ```
3. Reinicia la aplicación **Clima**.

## 🔑 Configuración

Para utilizar este backend, necesitas una API Key gratuita de Visual Crossing:

1. Regístrate en [Visual Crossing Weather API](https://www.visualcrossing.com/weather-api).
2. Copia tu clave desde el panel de control.
3. En tu dispositivo Sailfish OS, ve a **Configuración > Aplicaciones > Clima**.
4. Selecciona **Visual Crossing** como proveedor.
5. Pega tu API Key en el campo correspondiente.

## 🛠 Requisitos

- Sailfish OS con la aplicación nativa de Clima instalada.
- `sailfish-components-weather-qt5` versión 1.3.2 o superior.

## 🛠 Desarrollo y Compilación

Si deseas compilar el paquete por tu cuenta o contribuir al desarrollo, necesitas el [Sailfish SDK](https://docs.sailfishos.org/Tools/Sailfish_SDK/).

1. Clona el repositorio:
   ```bash
   git clone https://github.com/juanro49/harbour-weather-backend-visualcrossing.git
   cd harbour-weather-backend-visualcrossing
   ```
2. Configura el objetivo de compilación (la versión exacta dependerá de tus targets instalados, puedes verlos con `sfdk tools list`):
   ```bash
   # Ejemplo para arquitectura de 64 bits (aarch64)
   sfdk config target=SailfishOS-5.0.0.62-aarch64
   ```
3. Genera el paquete RPM:
   ```bash
   sfdk build
   ```
   *Nota: El proceso de construcción generará automáticamente el diccionario de traducciones `backends/VisualCrossingTranslations.js` a partir de los archivos `.ts`.*

4. (Opcional) Firmar el paquete manualmente:
   ```bash
   rpmsign --addsign --define "_gpg_name <TU_ID_DE_CLAVE>" RPMS/*.rpm
   ```

## 🌍 Traducciones

Puedes ayudar a traducir este proyecto usando [Weblate](https://hosted.weblate.org/projects/harbour-weather-backend-visualcrossing)

[![Estado de la traducción](https://hosted.weblate.org/widget/harbour-weather-backend-visualcrossing/harbour-weather-backend-visualcrossing/multi-auto.svg)](https://hosted.weblate.org/engage/harbour-weather-backend-visualcrossing/?utm_source=widget)

## 🙏 Créditos y Atribuciones

- Datos meteorológicos proporcionados por [Visual Crossing](https://www.visualcrossing.com/).
- Repositorios oficiales y recursos técnicos en [GitHub (visualcrossing)](https://github.com/visualcrossing).
- Basado en la estructura de backends de la aplicación [Sailfish Weather](https://github.com/sailfishos/sailfish-weather).

## 📄 Licencia

Este proyecto está bajo la licencia **BSD 3-Clause**. Consulta el archivo `LICENSE` para más detalles.
