CREATE OR REPLACE VIEW vw_detalle_ventas AS
SELECT f.id_venta,
       v.nombre AS videojuego,
       COALESCE(v.genero, 'Sin dato') AS genero,
       p.nombre_plataforma AS plataforma,
       COALESCE(pu.nombre_publisher, 'Sin dato') AS publisher,
       t.anio,
       t.decada,
       f.na_sales::float AS ventas_na,
       f.eu_sales::float AS ventas_eu,
       f.jp_sales::float AS ventas_jp,
       f.other_sales::float AS ventas_otras,
       (f.na_sales + f.eu_sales + f.jp_sales + f.other_sales)::float AS ventas_globales,
       f.critic_score,
       f.user_score::float AS user_score
FROM fact_ventas f
JOIN dim_videojuego v ON f.id_juego = v.id_juego
JOIN dim_plataforma p ON f.id_plataforma = p.id_plataforma
JOIN dim_publisher pu ON f.id_publisher = pu.id_publisher
JOIN dim_tiempo t     ON f.id_tiempo = t.id_tiempo;

CREATE OR REPLACE VIEW vw_ventas_resumen AS
SELECT anio, plataforma, genero, publisher,
       COUNT(*) AS num_juegos,
       SUM(ventas_na) AS ventas_na,
       SUM(ventas_eu) AS ventas_eu,
       SUM(ventas_jp) AS ventas_jp,
       SUM(ventas_otras) AS ventas_otras,
       SUM(ventas_globales) AS ventas_globales
FROM vw_detalle_ventas
GROUP BY anio, plataforma, genero, publisher;