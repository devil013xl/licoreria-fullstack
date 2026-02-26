-- =============================================
-- BASE DE DATOS: LICORERIA
-- =============================================
create database Licoreria
use Licoreria

-- =============================================
-- TABLA 1: CATEGORIAS (maestra)
-- =============================================
CREATE TABLE categorias (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(500),
    activo BIT DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE()
);
-- =============================================
-- TABLA 2: PROVEEDORES
-- =============================================
CREATE TABLE proveedores (
    id_proveedor INT IDENTITY(1,1) PRIMARY KEY,
    ruc VARCHAR(20) UNIQUE,
    nombre_empresa VARCHAR(200) NOT NULL,
    contacto_nombre VARCHAR(100),
    contacto_telefono VARCHAR(20),
    email VARCHAR(100),
    direccion VARCHAR(500),
    telefono_principal VARCHAR(20),
    sitio_web VARCHAR(200),
    condiciones_pago VARCHAR(100),
    activo BIT DEFAULT 1,
    fecha_registro DATETIME DEFAULT GETDATE()
);

-- =============================================
-- TABLA 3: PRODUCTOS (versión mejorada)
-- =============================================
CREATE TABLE productos (
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
    codigo_barras VARCHAR(50) UNIQUE,
    nombre VARCHAR(200) NOT NULL,
    descripcion VARCHAR(500),
    id_categoria INT REFERENCES categorias(id_categoria),
    id_proveedor INT REFERENCES proveedores(id_proveedor),
    marca VARCHAR(100),
    tipo_bebida VARCHAR(50), -- 'Cerveza', 'Vino', 'Whisky', 'Ron', etc.
    graduacion_alcoholica DECIMAL(5,2),
    volumen_ml INT, -- 330, 750, 1000, etc.
    pais_origen VARCHAR(100),
    precio_compra DECIMAL(10,2) NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL,
    stock_actual INT DEFAULT 0,
    stock_minimo INT DEFAULT 5,
    stock_maximo INT DEFAULT 500,
    unidad_medida VARCHAR(20), -- 'unidad', 'litro', 'ml'
    activo BIT DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_actualizacion DATETIME,
    
    -- Restricción para que precio_venta sea mayor que precio_compra
    CONSTRAINT chk_precios CHECK (precio_venta > precio_compra)
);

-- =============================================
-- TABLA 4: SUCURSALES
-- =============================================
CREATE TABLE sucursales (
    id_sucursal INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(500),
    ciudad VARCHAR(100),
    provincia VARCHAR(100),
    telefono VARCHAR(20),
    email VARCHAR(100),
    responsable VARCHAR(200),
    fecha_apertura DATE,
    activo BIT DEFAULT 1
);

-- =============================================
-- TABLA 5: EMPLEADOS (versión mejorada)
-- =============================================
CREATE TABLE empleados (
    id_empleado INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100),
    cedula VARCHAR(20) UNIQUE NOT NULL,
    fecha_nacimiento DATE,
    genero CHAR(1),
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(20),
    direccion VARCHAR(500),
    fecha_contratacion DATE DEFAULT GETDATE(),
    cargo VARCHAR(100), -- 'Vendedor', 'Cajero', 'Administrador'
    id_sucursal INT REFERENCES sucursales(id_sucursal),
    salario DECIMAL(10,2),
    activo BIT DEFAULT 1,
    fecha_registro DATETIME DEFAULT GETDATE(),
    
    -- Restricción para género
    CONSTRAINT chk_genero_empleado CHECK (genero IN ('M', 'F', 'O'))
);

-- =============================================
-- TABLA 6: CLIENTES (versión mejorada)
-- =============================================
CREATE TABLE clientes (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    tipo_documento VARCHAR(20) DEFAULT 'CEDULA',
    numero_documento VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(20),
    fecha_nacimiento DATE,
    genero CHAR(1),
    -- Autenticación
    password_hash VARCHAR(255), -- Para guardar contraseñas encriptadas
    -- Metadatos para análisis
    fecha_registro DATETIME DEFAULT GETDATE(),
    ultima_compra DATETIME,
    total_compras DECIMAL(10,2) DEFAULT 0,
    frecuencia_compras INT DEFAULT 0,
    activo BIT DEFAULT 1,
    es_miembro BIT DEFAULT 0,
    puntos_acumulados INT DEFAULT 0,
    
    CONSTRAINT chk_genero_cliente CHECK (genero IN ('M', 'F', 'O'))
);

-- =============================================
-- TABLA 7: DIRECCIONES_CLIENTE (normalizada)
-- =============================================
CREATE TABLE direcciones_cliente (
    id_direccion INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT REFERENCES clientes(id_cliente),
    tipo_direccion VARCHAR(50), -- 'casa', 'trabajo', 'otro'
    direccion VARCHAR(500) NOT NULL,
    ciudad VARCHAR(100),
    provincia VARCHAR(100),
    codigo_postal VARCHAR(20),
    pais VARCHAR(100) DEFAULT 'Ecuador',
    es_principal BIT DEFAULT 0
);

-- =============================================
-- TABLA 8: FACTURAS (cabecera)
-- =============================================
CREATE TABLE facturas (
    id_factura INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT REFERENCES clientes(id_cliente),
    id_empleado INT REFERENCES empleados(id_empleado),
    id_sucursal INT REFERENCES sucursales(id_sucursal),
    fecha_factura DATETIME DEFAULT GETDATE(),
    tipo_comprobante VARCHAR(20), -- 'factura', 'boleta'
    numero_comprobante VARCHAR(50) UNIQUE,
    -- Totales
    subtotal DECIMAL(10,2) NOT NULL,
    iva DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2) NOT NULL,
    -- Pago
    metodo_pago VARCHAR(50), -- 'efectivo', 'tarjeta', 'transferencia'
    estado_pago VARCHAR(20) DEFAULT 'pagado', -- 'pagado', 'pendiente', 'anulado'
    -- Metadatos
    observaciones VARCHAR(500),
    fecha_anulacion DATETIME,
    motivo_anulacion VARCHAR(500)
);

-- =============================================
-- TABLA 9: DETALLE_FACTURA
-- =============================================
CREATE TABLE detalle_factura (
    id_detalle INT IDENTITY(1,1) PRIMARY KEY,
    id_factura INT REFERENCES facturas(id_factura),
    id_producto INT REFERENCES productos(id_producto),
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    descuento DECIMAL(10,2) DEFAULT 0,
    subtotal AS (cantidad * precio_unitario - descuento) PERSISTED,
    
    CONSTRAINT chk_cantidad CHECK (cantidad > 0),
    CONSTRAINT chk_descuento CHECK (descuento >= 0)
);

-- =============================================
-- TABLA 10: COMPRAS (a proveedores)
-- =============================================
CREATE TABLE compras (
    id_compra INT IDENTITY(1,1) PRIMARY KEY,
    id_proveedor INT REFERENCES proveedores(id_proveedor),
    fecha_compra DATE NOT NULL,
    fecha_recepcion DATE,
    numero_factura VARCHAR(50) UNIQUE,
    subtotal DECIMAL(10,2),
    iva DECIMAL(10,2),
    total DECIMAL(10,2),
    estado VARCHAR(20) DEFAULT 'pendiente' -- 'pendiente', 'recibida', 'anulada'
);

-- =============================================
-- TABLA 11: DETALLE_COMPRA
-- =============================================
CREATE TABLE detalle_compra (
    id_detalle_compra INT IDENTITY(1,1) PRIMARY KEY,
    id_compra INT REFERENCES compras(id_compra),
    id_producto INT REFERENCES productos(id_producto),
    cantidad INT NOT NULL,
    costo_unitario DECIMAL(10,2) NOT NULL,
    subtotal AS (cantidad * costo_unitario) PERSISTED,
    
    CONSTRAINT chk_cantidad_compra CHECK (cantidad > 0)
);

-- =============================================
-- TABLA 12: MOVIMIENTOS_INVENTARIO (auditoría)
-- =============================================
CREATE TABLE movimientos_inventario (
    id_movimiento INT IDENTITY(1,1) PRIMARY KEY,
    id_producto INT REFERENCES productos(id_producto),
    id_sucursal INT REFERENCES sucursales(id_sucursal),
    tipo_movimiento VARCHAR(20), -- 'entrada', 'salida', 'ajuste'
    cantidad INT NOT NULL,
    stock_anterior INT,
    stock_nuevo INT,
    fecha_movimiento DATETIME DEFAULT GETDATE(),
    motivo VARCHAR(100), -- 'venta', 'compra', 'perdida', 'inventario_inicial'
    id_referencia INT, -- id_factura o id_compra
    id_usuario INT REFERENCES empleados(id_empleado),
    
    CONSTRAINT chk_tipo_movimiento CHECK (tipo_movimiento IN ('entrada', 'salida', 'ajuste'))
);
-- =============================================
-- TABLA 13: ROLES (para permisos)
-- =============================================
CREATE TABLE roles (
    id_rol INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(200),
    nivel_acceso INT, -- 1: más bajo, 5: más alto
    activo BIT DEFAULT 1
);

-- Insertar roles básicos
INSERT INTO roles (nombre, descripcion, nivel_acceso) VALUES 
('CLIENTE', 'Usuario comprador en tienda online', 1),
('CAJERO', 'Puede registrar ventas, no ver reportes', 2),
('VENDEDOR', 'Atención al cliente, registrar ventas', 2),
('ALMACENERO', 'Gestión de inventario, compras', 3),
('SUPERVISOR', 'Puede ver reportes básicos', 4),
('GERENTE', 'Acceso a reportes y análisis', 5),
('ADMIN', 'Acceso total al sistema', 5);
GO

-- =============================================
-- TABLA 14: USUARIOS (unificada para empleados y clientes web)
-- =============================================
CREATE TABLE usuarios (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    id_rol INT REFERENCES roles(id_rol) NOT NULL,
    
    -- Relación con empleado (si aplica)
    id_empleado INT REFERENCES empleados(id_empleado) NULL,
    -- Relación con cliente (si aplica)
    id_cliente INT REFERENCES clientes(id_cliente) NULL,
    
    -- Control de acceso
    ultimo_acceso DATETIME,
    intentos_fallidos INT DEFAULT 0,
    bloqueado BIT DEFAULT 0,
    fecha_bloqueo DATETIME,
    
    -- Metadatos
    activo BIT DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_actualizacion DATETIME,
    
    -- Restricción: debe estar relacionado con empleado O cliente, no ambos
    CONSTRAINT chk_tipo_usuario CHECK (
        (id_empleado IS NOT NULL AND id_cliente IS NULL) OR
        (id_empleado IS NULL AND id_cliente IS NOT NULL) OR
        (id_empleado IS NULL AND id_cliente IS NULL AND id_rol IN (1)) -- Solo para clientes web sin cuenta física
    )
);
GO

-- =============================================
-- TABLA 15: PERMISOS (para control granular)
-- =============================================
CREATE TABLE permisos (
    id_permiso INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    descripcion VARCHAR(200),
    modulo VARCHAR(50) -- 'ventas', 'inventario', 'clientes', 'reportes', 'usuarios'
);

-- Insertar permisos básicos
INSERT INTO permisos (nombre, descripcion, modulo) VALUES
('VER_VENTAS', 'Ver lista de ventas', 'ventas'),
('CREAR_VENTA', 'Registrar nueva venta', 'ventas'),
('ANULAR_VENTA', 'Anular ventas existentes', 'ventas'),
('VER_INVENTARIO', 'Ver productos y stock', 'inventario'),
('EDITAR_PRODUCTO', 'Modificar productos', 'inventario'),
('AJUSTAR_STOCK', 'Realizar ajustes de inventario', 'inventario'),
('VER_CLIENTES', 'Ver información de clientes', 'clientes'),
('EDITAR_CLIENTES', 'Modificar datos de clientes', 'clientes'),
('VER_REPORTES', 'Acceder a reportes y análisis', 'reportes'),
('EXPORTAR_DATOS', 'Exportar datos a Excel/CSV', 'reportes'),
('VER_EMPLEADOS', 'Ver información de empleados', 'usuarios'),
('GESTIONAR_USUARIOS', 'Crear/modificar usuarios', 'usuarios'),
('VER_METRICAS', 'Ver dashboard y KPIs', 'reportes');
GO

-- =============================================
-- TABLA 16: ROLES_PERMISOS (relación muchos a muchos)
-- =============================================
CREATE TABLE roles_permisos (
    id_rol INT REFERENCES roles(id_rol),
    id_permiso INT REFERENCES permisos(id_permiso),
    fecha_asignacion DATETIME DEFAULT GETDATE(),
    asignado_por INT REFERENCES usuarios(id_usuario),
    PRIMARY KEY (id_rol, id_permiso)
);
GO

-- Asignar permisos por defecto a roles
-- GERENTE (id_rol = 6) tiene todos los permisos
INSERT INTO roles_permisos (id_rol, id_permiso)
SELECT 6, id_permiso FROM permisos;

-- CAJERO (id_rol = 2) tiene permisos básicos de ventas
INSERT INTO roles_permisos (id_rol, id_permiso)
SELECT 2, id_permiso FROM permisos 
WHERE nombre IN ('VER_VENTAS', 'CREAR_VENTA', 'VER_CLIENTES');

-- ALMACENERO (id_rol = 4) tiene permisos de inventario
INSERT INTO roles_permisos (id_rol, id_permiso)
SELECT 4, id_permiso FROM permisos 
WHERE nombre IN ('VER_INVENTARIO', 'EDITAR_PRODUCTO', 'AJUSTAR_STOCK');

-- SUPERVISOR (id_rol = 5) puede ver ventas e inventario
INSERT INTO roles_permisos (id_rol, id_permiso)
SELECT 5, id_permiso FROM permisos 
WHERE nombre IN ('VER_VENTAS', 'VER_INVENTARIO', 'VER_CLIENTES', 'VER_REPORTES');
GO

-- =============================================
-- TABLA 17: SESIONES (para control de acceso)
-- =============================================
CREATE TABLE sesiones (
    id_sesion INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT REFERENCES usuarios(id_usuario),
    token VARCHAR(255) UNIQUE NOT NULL,
    fecha_inicio DATETIME DEFAULT GETDATE(),
    fecha_expiracion DATETIME,
    ip_address VARCHAR(45),
    user_agent VARCHAR(500),
    activa BIT DEFAULT 1
);
GO

-- =============================================
-- TABLA 18: CARRITO_COMPRAS (cabecera del carrito)
-- =============================================
CREATE TABLE carrito_compras (
    id_carrito INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT REFERENCES usuarios(id_usuario) UNIQUE, -- Un carrito por usuario
    id_sucursal INT REFERENCES sucursales(id_sucursal), -- Para saber dónde comprará
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_actualizacion DATETIME,
    estado VARCHAR(20) DEFAULT 'activo', -- 'activo', 'convertido', 'abandonado'
    total_items INT DEFAULT 0,
    subtotal DECIMAL(10,2) DEFAULT 0
);
GO

-- =============================================
-- TABLA 19: DETALLE_CARRITO (productos en carrito)
-- =============================================
CREATE TABLE detalle_carrito (
    id_detalle_carrito INT IDENTITY(1,1) PRIMARY KEY,
    id_carrito INT REFERENCES carrito_compras(id_carrito),
    id_producto INT REFERENCES productos(id_producto),
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL, -- Precio al momento de agregar
    fecha_agregado DATETIME DEFAULT GETDATE(),
    -- Restricción única para no duplicar productos en el mismo carrito
    CONSTRAINT uq_carrito_producto UNIQUE (id_carrito, id_producto),
    CONSTRAINT chk_cantidad_carrito CHECK (cantidad > 0)
);
GO

-- =============================================
-- TABLA 20: HISTORIAL_CARRITOS (para análisis de abandono)
-- =============================================
CREATE TABLE historial_carritos (
    id_historial INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT REFERENCES usuarios(id_usuario),
    id_carrito INT REFERENCES carrito_compras(id_carrito),
    id_factura INT REFERENCES facturas(id_factura) NULL, -- Si se concretó
    fecha_creacion DATETIME,
    fecha_conversion DATETIME NULL,
    estado_final VARCHAR(20), -- 'convertido', 'abandonado', 'limpiado'
    valor_total DECIMAL(10,2),
    tiempo_minutos INT -- Tiempo desde creación hasta conversión/abandono
);
GO

-- =============================================
-- TABLA 21: NOTIFICACIONES (para sistema interno)
-- =============================================
CREATE TABLE notificaciones (
    id_notificacion INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario_destino INT REFERENCES usuarios(id_usuario),
    titulo VARCHAR(200),
    mensaje VARCHAR(500),
    tipo VARCHAR(50), -- 'info', 'warning', 'success', 'error'
    modulo VARCHAR(50), -- 'ventas', 'inventario', 'sistema'
    id_referencia INT, -- ID de factura, producto, etc.
    leida BIT DEFAULT 0,
    fecha_envio DATETIME DEFAULT GETDATE(),
    fecha_lectura DATETIME NULL
);
GO

-- =============================================
-- TABLA 22: AUDITORIA_ACCIONES (para tracking)
-- =============================================
CREATE TABLE auditoria_acciones (
    id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT REFERENCES usuarios(id_usuario),
    accion VARCHAR(100), -- 'INSERT', 'UPDATE', 'DELETE', 'LOGIN', 'LOGOUT'
    tabla_afectada VARCHAR(50),
    id_registro INT,
    datos_anteriores VARCHAR(MAX), -- JSON con datos antes del cambio
    datos_nuevos VARCHAR(MAX), -- JSON con datos después del cambio
    ip_address VARCHAR(45),
    fecha_accion DATETIME DEFAULT GETDATE()
);
GO

-- =============================================
-- ÍNDICES ADICIONALES
-- =============================================
CREATE INDEX idx_usuarios_rol ON usuarios(id_rol);
CREATE INDEX idx_usuarios_username ON usuarios(username);
CREATE INDEX idx_sesiones_token ON sesiones(token);
CREATE INDEX idx_sesiones_usuario ON sesiones(id_usuario);
CREATE INDEX idx_carrito_usuario ON carrito_compras(id_usuario);
CREATE INDEX idx_carrito_estado ON carrito_compras(estado);
CREATE INDEX idx_notificaciones_usuario ON notificaciones(id_usuario_destino, leida);
CREATE INDEX idx_auditoria_usuario ON auditoria_acciones(id_usuario);
CREATE INDEX idx_auditoria_fecha ON auditoria_acciones(fecha_accion);
GO