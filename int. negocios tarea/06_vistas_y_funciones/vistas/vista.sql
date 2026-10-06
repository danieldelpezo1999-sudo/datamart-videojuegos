--vista detalle de ventas
CREATE VIEW vw_ventas_detalle AS
SELECT
    f.id_venta,
    j.nombre,
    j.genero,
    j.developer,
    j.rating,
    p.nombre_plataforma  AS plataforma,
    pu.nombre_publisher  AS publisher,
    t.anio,
    t.decada,
    f.na_sales,
    f.eu_sales,
    f.jp_sales,
    f.other_sales,
    (f.na_sales + f.eu_sales + f.jp_sales + f.other_sales) AS global_sales,
    f.critic_score,
    f.critic_count,
    f.user_score,
    f.user_count
FROM fact_ventas f
JOIN dim_videojuego j  ON j.id_juego      = f.id_juego
JOIN dim_plataforma p  ON p.id_plataforma = f.id_plataforma
JOIN dim_publisher  pu ON pu.id_publisher = f.id_publisher
JOIN dim_tiempo     t  ON t.id_tiempo     = f.id_tiempo;

--consulta de la vista creada
SELECT COUNT(*) AS filas, ROUND(SUM(global_sales), 2) AS total
FROM vw_ventas_detalle;

SELECT nombre, plataforma, global_sales
FROM vw_ventas_detalle
ORDER BY global_sales DESC
LIMIT 3;
