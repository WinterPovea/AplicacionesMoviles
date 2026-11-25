# taskflow

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

## Alcance de TaskFlow

Problema: necesito organizar actividades académicas y saber cuáles faltan.
Usuario objetivo: estudiante universitario que planifica entregas semanales de desarrollo móvil.

### Historias de usuario y criterios de aceptación
1. Como estudiante, quiero listar mis tareas para ver qué debo hacer.
   Criterio: la lista muestra título, prioridad y estado de cada tarea.
2. Como estudiante, quiero abrir una tarea para leer su descripción.
   Criterio: al tocar una tarjeta aparece el detalle de la tarea elegida.
3. Como estudiante, quiero crear una tarea para registrar un pendiente.
   Criterio: el formulario guarda una tarea válida y la lista la muestra.
4. Como estudiante, quiero editar una tarea para corregir sus datos.
   Criterio: los cambios guardados aparecen en lista y detalle.
5. Como estudiante, quiero eliminar una tarea terminada para limpiar la lista.
   Criterio: después de confirmar, la tarea desaparece de la lista.

### Modelo de datos
Task: id (entero único: 101–105), title (texto), description (texto),
priority (Alta, Media o Baja), isCompleted (verdadero/falso),
userId (entero que identifica al usuario de prueba).

### Pantallas previstas
Lista: tarjetas de tareas (configuración de repositorio, modelo JSON, GoRouter, README y formulario) y futura acción para crear.
Detalle: información completa, banner contextual de estado y futuras acciones de editar o eliminar.
Formulario: campos de título, descripción y prioridad.

### Requisitos no funcionales
La navegación debe tener textos comprensibles.
Un id inexistente debe mostrar un mensaje en vez de cerrar la app.

### Contrato de API que necesitaremos
GET /tasks        listar tareas
GET /tasks/:id    consultar detalle
POST /tasks       crear tarea
PATCH /tasks/:id  actualizar tarea
DELETE /tasks/:id eliminar tarea

---

## API de tareas

- **Endpoint base y recurso:** `https://jsonplaceholder.typicode.com/todos`
- **Filtro aplicado (`userId`):** Se envía el parámetro de consulta `?userId=2` para obtener únicamente las tareas asignadas al usuario 2.
- **Campos recibidos desde la API:** `id` (entero), `userId` (entero), `title` (cadena de texto) y `completed` (booleano, mapeado a `isCompleted` en el modelo `Task`).
- **Valores completados por defecto en TaskFlow:** Como JSONPlaceholder no provee descripción ni prioridad, `Task.fromJson` asigna `'Sin descripción (API)'` a `description` y `'Sin prioridad (API)'` a `priority`.
- **Persistencia local temporal:** Marcar o desmarcar una tarea como completada ejecuta `save()` sobre una copia en memoria dentro de `RemoteTaskRepository`. JSONPlaceholder es una API de solo lectura para esta práctica, por lo que al reiniciar la aplicación las tareas vuelven a su estado remoto original.

---

## Manejo de Estados Asíncronos (Sesión 8)

La pantalla principal (`TaskListScreen`) gestiona de forma reactiva cuatro estados derivados de `TasksViewModel` mediante `ChangeNotifier`:

1. **Estado de carga (`isLoading == true`):** Se activa automáticamente al iniciar la aplicación o al invocar `loadTasks()` desde el botón de la barra superior o el gesto *pull-to-refresh* (`RefreshIndicator`). Muestra un `CircularProgressIndicator` con mensaje de sincronización.
2. **Estado de éxito (lista poblada):** Se muestra cuando la petición HTTP 200 devuelve elementos válidos. Renderiza un `ListView.builder` con `AlwaysScrollableScrollPhysics()` para permitir deslizar hacia abajo y refrescar incluso si hay pocos elementos.
3. **Estado de error (`errorMessage != null`):** Provocado al desactivar la conexión a internet (Modo Avión) antes de solicitar una actualización. Dio captura la excepción de red y la vista presenta el mensaje de fallo junto al botón **Reintentar**, que permite recuperar los datos al restablecer la red sin reiniciar la aplicación.
4. **Estado vacío (`isEmpty == true`):** Provocado configurando temporalmente `userId = 9999` en `TaskApiService`. El servidor responde con HTTP 200 y un arreglo vacío `[]`; la interfaz diferencia este caso de un error mostrando el icono de bandeja vacía y el botón **Actualizar**.

---

## Formulario de Nueva Tarea (Sesión 9)

Se implementó la pantalla `TaskFormScreen` accesible desde la ruta `/new` mediante el botón flotante **Nueva tarea**:

- **Validación con `Form` y `GlobalKey<FormState>`:** Exige un título no vacío de al menos 3 caracteres y muestra mensajes descriptivos en español ante entradas inválidas.
- **Controladores y estado local:** Gestiona `TextEditingController` para título y descripción (liberados en `dispose()`), un `DropdownButtonFormField` para prioridad (`Alta`, `Media`, `Baja`) y un selector de fecha opcional mediante `showDatePicker`.
- **Retorno de borrador (`TaskDraft`):** Al guardar un formulario válido, `context.pop(draft)` devuelve los datos a `TaskListScreen` para confirmarlos en un `SnackBar` sin simular persistencia remota. El botón **Cancelar** regresa sin emitir mensaje.