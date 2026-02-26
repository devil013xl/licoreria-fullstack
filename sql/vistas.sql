-- =============================================
-- VISTAS PARA ANÁLISIS DE DATOS
-- =============================================

-- Vista 1: Ventas por producto
CREATE VIEW vw_ventas_por_producto AS
SELECT 
    p.nombre AS producto,
    c.nombre AS categoria,
    SUM(df.cantidad) AS total_unidades_vendidas,
    SUM(df.subtotal) AS total_ventas,
    AVG(df.precio_unitario) AS precio_promedio
FROM detalle_factura df
INNER JOIN productos p ON df.id_producto = p.id_producto
INNER JOIN categorias c ON p.id_categoria = c.id_categoria
GROUP BY p.nombre, c.nombre;

-- Vista 2: Ventas por hora del día
CREATE VIEW vw_ventas_por_hora AS
SELECT 
    DATEPART(HOUR, fecha_factura) AS hora,
    COUNT(*) AS numero_ventas,
    SUM(total) AS total_vendido
FROM facturas
GROUP BY DATEPART(HOUR, fecha_factura);

-- Vista 3: Clientes frecuentes
CREATE VIEW vw_clientes_frecuentes AS
SELECT 
    CONCAT(c.nombre, ' ', c.apellido) AS cliente,
    c.email,
    c.telefono,
    COUNT(f.id_factura) AS compras_realizadas,
    SUM(f.total) AS total_gastado,
    MAX(f.fecha_factura) AS ultima_compra
FROM clientes c
LEFT JOIN facturas f ON c.id_cliente = f.id_cliente
GROUP BY c.nombre, c.apellido, c.email, c.telefono
HAVING COUNT(f.id_factura) > 0;

-- Vista 4: Rentabilidad por producto
CREATE VIEW vw_rentabilidad_productos AS
SELECT 
    p.nombre,
    p.marca,
    p.precio_compra,
    p.precio_venta,
    (p.precio_venta - p.precio_compra) AS margen_unitario,
    ((p.precio_venta - p.precio_compra) / p.precio_compra * 100) AS margen_porcentaje,
    p.stock_actual
FROM productos p
WHERE p.activo = 1;

PRINT 'Base de datos creada exitosamente. Tablas: 12, Vistas: 4';
GO

--------------------
-- =============================================
-- VISTAS PARA CONTROL DE ACCESO
-- =============================================

-- Vista 5: Permisos por usuario (útil para el backend)
CREATE VIEW vw_permisos_usuario AS
SELECT 
    u.id_usuario,
    u.username,
    u.email,
    r.nombre AS rol,
    r.nivel_acceso,
    p.nombre AS permiso,
    p.modulo
FROM usuarios u
INNER JOIN roles r ON u.id_rol = r.id_rol
INNER JOIN roles_permisos rp ON r.id_rol = rp.id_rol
INNER JOIN permisos p ON rp.id_permiso = p.id_permiso
WHERE u.activo = 1;
GO

-- Vista 6: Carritos abandonados (para análisis)
CREATE VIEW vw_carritos_abandonados AS
SELECT 
    u.username,
    u.email,
    c.fecha_creacion,
    DATEDIFF(HOUR, c.fecha_creacion, GETDATE()) AS horas_abandonado,
    c.total_items,
    c.subtotal,
    STRING_AGG(p.nombre, ', ') AS productos
FROM carrito_compras c
INNER JOIN usuarios u ON c.id_usuario = u.id_usuario
INNER JOIN detalle_carrito dc ON c.id_carrito = dc.id_carrito
INNER JOIN productos p ON dc.id_producto = p.id_producto
WHERE c.estado = 'activo' 
  AND DATEDIFF(DAY, c.fecha_actualizacion, GETDATE()) > 1
GROUP BY u.username, u.email, c.fecha_creacion, c.total_items, c.subtotal;
GO

-- Vista 7: Dashboard de ventas para gerente
CREATE VIEW vw_dashboard_ventas AS
SELECT 
    FORMAT(f.fecha_factura, 'yyyy-MM') AS mes,
    COUNT(DISTINCT f.id_factura) AS total_ventas,
    SUM(f.total) AS ingresos_totales,
    AVG(f.total) AS ticket_promedio,
    COUNT(DISTINCT f.id_cliente) AS clientes_unicos,
    SUM(CASE WHEN f.metodo_pago = 'tarjeta' THEN f.total ELSE 0 END) AS ventas_tarjeta,
    SUM(CASE WHEN f.metodo_pago = 'efectivo' THEN f.total ELSE 0 END) AS ventas_efectivo
FROM facturas f
WHERE f.estado_pago = 'pagado'
GROUP BY FORMAT(f.fecha_factura, 'yyyy-MM');
GO