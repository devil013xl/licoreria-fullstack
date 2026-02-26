-- =============================================
-- DATOS DE EJEMPLO PARA EMPEZAR
-- =============================================

-- Insertar categorías
INSERT INTO categorias (nombre, descripcion) VALUES 
('Cervezas', 'Cervezas nacionales e importadas'),
('Whiskys', 'Whiskys de malta y blend'),
('Rones', 'Rones añejos y premium'),
('Vodkas', 'Vodkas nacionales e importados'),
('Vinos', 'Vinos tintos, blancos y espumantes'),
('Piscos', 'Pisco peruano y chileno'),
('Tequilas', 'Tequilas 100% agave'),
('Licores', 'Licores de crema, hierbas, etc.'),
('Sin alcohol', 'Bebidas sin alcohol para coctelería');

-- Insertar sucursal principal
INSERT INTO sucursales (nombre, direccion, ciudad, telefono, responsable) VALUES 
('Sucursal Valle', 'Av. Principal 123', 'Valle', '02-1234567', 'Emily Fernandez');

-- Insertar empleado
INSERT INTO empleados (nombre, apellido, cedula, email, telefono, cargo, id_sucursal) VALUES 
('Emily', 'Fernandez', '1756324895', 'emily.fernandez@licoreria.com', '0999999999', 'Administradora', 1);

-- Insertar cliente de ejemplo
INSERT INTO clientes (tipo_documento, numero_documento, nombre, apellido, email, telefono) VALUES 
('CEDULA', '1753866456', 'Isaac', 'Castro', 'isaac39@hotmail.com', '0962540196');

-- Insertar dirección del cliente
INSERT INTO direcciones_cliente (id_cliente, tipo_direccion, direccion, ciudad, codigo_postal) VALUES 
(1, 'casa', 'La Armenia', 'Quito', '170803');

-- Insertar producto de ejemplo
INSERT INTO productos (nombre, codigo_barras, id_categoria, precio_compra, precio_venta, stock_actual, marca, tipo_bebida, volumen_ml, graduacion_alcoholica, pais_origen) VALUES 
('Pilsener Litro', '7891234567890', 1, 1.50, 2.75, 40, 'Pilsener', 'Cerveza', 1000, 4.5, 'Ecuador');