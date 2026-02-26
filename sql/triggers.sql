-- =============================================
-- TRIGGERS AUTOMÁTICOS
-- =============================================

-- Trigger para actualizar total_items y subtotal en carrito
CREATE TRIGGER trg_actualizar_carrito
ON detalle_carrito
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @id_carrito INT;
    
    SELECT @id_carrito = COALESCE(
        (SELECT id_carrito FROM inserted),
        (SELECT id_carrito FROM deleted)
    );
    
    UPDATE carrito_compras
    SET 
        total_items = (SELECT SUM(cantidad) FROM detalle_carrito WHERE id_carrito = @id_carrito),
        subtotal = (SELECT SUM(cantidad * precio_unitario) FROM detalle_carrito WHERE id_carrito = @id_carrito),
        fecha_actualizacion = GETDATE()
    WHERE id_carrito = @id_carrito;
END;
GO

-- Trigger para auditoría de ventas
CREATE TRIGGER trg_auditoria_ventas
ON facturas
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO auditoria_acciones (id_usuario, accion, tabla_afectada, id_registro, datos_anteriores, datos_nuevos)
    SELECT 
        1, -- Temporal, deberías obtener el usuario actual de la sesión
        CASE 
            WHEN EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) THEN 'UPDATE'
            WHEN EXISTS (SELECT * FROM inserted) THEN 'INSERT'
            ELSE 'DELETE'
        END,
        'facturas',
        COALESCE(i.id_factura, d.id_factura),
        (SELECT * FROM deleted d FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
        (SELECT * FROM inserted i FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.id_factura = d.id_factura;
END;
GO

PRINT 'Tablas de usuarios, roles y carrito creadas exitosamente. Total tablas: 22';
GO