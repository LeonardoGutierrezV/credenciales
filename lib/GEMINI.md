# GEMINI.md

## Proyecto: Credenciales PVC Pro (Desktop)

Aplicación de escritorio para Windows diseñada para la personalización, generación de códigos y emisión masiva de credenciales de PVC. El sistema debe garantizar precisión milimétrica para la impresión térmica.

### Requerimientos Funcionales
- **Carga de Multimedia:** Importación de fotografía del usuario y logotipos institucionales (Soporte para transparencia).
- **Editor de Contenido:**
    - Input de Nombre completo y campos dinámicos (Textos Complementarios).
    - Generación dinámica de Códigos de Barras (128, EAN) y Códigos QR.
- **Personalización Visual:** Cambio de color de fondo (Hex/RGB) y posicionamiento de elementos.
- **Salida de Datos:**
    - **Exportación:** Generación de PDF en tamaño estándar CR-80 (85.6mm x 53.98mm).
    - **Impresión:** Envío directo al spooler de Windows con compatibilidad específica para Zebra ZXP Series 7.

## ROL
**Senior Flutter Developer & Hardware Integration Specialist**
- **Dart/Flutter:** Experto en arquitectura de escritorio y manejo de `CustomPainter` para renderizado de alta precisión.
- **Hardware:** Conocimiento avanzado en comunicación con periféricos de impresión y lenguaje **ZPL (Zebra Programming Language)** para optimizar la calidad de impresión térmica y el uso de cintas (ribbons).

## Contexto y Stack Tecnológico
- **Framework:** Flutter Desktop (Windows).
- **Estado:** Manejo de estado sólido (Provider, Riverpod o Bloc).
- **Renderizado:** Canvas API para la previsualización en tiempo real.

## Estándares de Desarrollo
- **Arquitectura:** Clean Architecture (Separación de capas: UI, Domain, Data).
- **Modularidad:** Un archivo `.dart` por clase. Cumplimiento estricto de principios SOLID.
- **Precisión:** Conversión exacta de Pixeles a Milímetros (DPI scaling) para evitar impresiones borrosas o desalineadas.
- **Robustez:** Implementación de bloques `try-catch` específicos para la comunicación con drivers de impresión.
- **ZPL:** Capacidad de generar scripts ZPL para bypass de driver si se requiere mayor velocidad o control de capas de protección (Overlay).

## Compatibilidad y Restricciones
- **SO:** Únicamente Windows 10/11.
- **Layout:** Ventana redimensionable con área de trabajo (Canvas) con relación de aspecto fija (CR-80).
- **Hardware:** Optimización para Zebra ZXP Series 7.

## Protocolo de Respuesta
1. **Analizar:** Explicación técnica de la lógica, el flujo de datos y los widgets a utilizar.
2. **Dependencias:** Listado de paquetes necesarios (ej: `pdf`, `printing`, `barcode_widget`, `image_picker`).
3. **Código:** Proporcionar el código completo, modularizado y con comentarios técnicos.
4. **Comandos:** Instrucciones de terminal para agregar dependencias y compilar.

---
*Nota: Siempre que se genere código de impresión, asegurar que el tamaño del papel esté preconfigurado para evitar el desperdicio de tarjetas de PVC.*