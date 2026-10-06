--creacion de funcion
CREATE OR REPLACE FUNCTION fn_promedio_ventas_publisher(
    p_genero            TEXT DEFAULT NULL,
    p_plataforma        TEXT DEFAULT NULL,
    p_anio_desde        INT  DEFAULT NULL,
    p_anio_hasta        INT  DEFAULT NULL,
    p_min_lanzamientos  INT  DEFAULT 1
)
RETURNS TABLE (
    publisher            TEXT,
    lanzamientos         BIGINT,
    ventas_totales       NUMERIC,
    promedio_por_titulo  NUMERIC
)
LANGUAGE sql
AS $$
    SELECT v.publisher,
           COUNT(*),
           SUM(v.global_sales),
           ROUND(SUM(v.global_sales) / COUNT(*), 2)
    FROM vw_ventas_detalle v
    WHERE (p_genero     IS NULL OR v.genero     = p_genero)
      AND (p_plataforma IS NULL OR v.plataforma = p_plataforma)
      AND (p_anio_desde IS NULL OR v.anio >= p_anio_desde)
      AND (p_anio_hasta IS NULL OR v.anio <= p_anio_hasta)
    GROUP BY v.publisher
    HAVING COUNT(*) >= p_min_lanzamientos
    ORDER BY 4 DESC;
$$;

--consulta a la funcion
SELECT * FROM fn_promedio_ventas_publisher(p_min_lanzamientos => 50) LIMIT 3;

--ventas por genero y region
CREATE OR REPLACE FUNCTION fn_ventas_genero_region(
    p_genero      TEXT DEFAULT NULL,
    p_plataforma  TEXT DEFAULT NULL,
    p_anio_desde  INT  DEFAULT NULL,
    p_anio_hasta  INT  DEFAULT NULL
)
RETURNS TABLE (
    genero        TEXT,
    norteamerica  NUMERIC,
    europa        NUMERIC,
    japon         NUMERIC,
    otros         NUMERIC,
    total         NUMERIC
)
LANGUAGE sql
AS $$
    SELECT v.genero,
           SUM(v.na_sales),
           SUM(v.eu_sales),
           SUM(v.jp_sales),
           SUM(v.other_sales),
           SUM(v.global_sales)
    FROM vw_ventas_detalle v
    WHERE (p_genero     IS NULL OR v.genero     = p_genero)
      AND (p_plataforma IS NULL OR v.plataforma = p_plataforma)
      AND (p_anio_desde IS NULL OR v.anio >= p_anio_desde)
      AND (p_anio_hasta IS NULL OR v.anio <= p_anio_hasta)
    GROUP BY v.genero
    ORDER BY 6 DESC;
$$;

--consulta a la venta y region
SELECT * FROM fn_ventas_genero_region() LIMIT 3;