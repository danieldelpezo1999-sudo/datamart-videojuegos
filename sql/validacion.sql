-- 1. Conteo de registros por tabla
SELECT 'fact_ventas' AS tabla, COUNT(*) AS filas FROM fact_ventas
UNION ALL SELECT 'dim_videojuego', COUNT(*) FROM dim_videojuego
UNION ALL SELECT 'dim_plataforma', COUNT(*) FROM dim_plataforma
UNION ALL SELECT 'dim_publisher', COUNT(*) FROM dim_publisher
UNION ALL SELECT 'dim_tiempo', COUNT(*) FROM dim_tiempo;

-- 2. Integridad de claves: todos deben dar 0
SELECT
 (SELECT COUNT(*) FROM fact_ventas f LEFT JOIN dim_videojuego d ON f.id_juego=d.id_juego WHERE d.id_juego IS NULL) AS huerfanos_juego,
 (SELECT COUNT(*) FROM fact_ventas f LEFT JOIN dim_plataforma d ON f.id_plataforma=d.id_plataforma WHERE d.id_plataforma IS NULL) AS huerfanos_plataforma,
 (SELECT COUNT(*) FROM fact_ventas f LEFT JOIN dim_publisher d ON f.id_publisher=d.id_publisher WHERE d.id_publisher IS NULL) AS huerfanos_publisher,
 (SELECT COUNT(*) FROM fact_ventas f LEFT JOIN dim_tiempo d ON f.id_tiempo=d.id_tiempo WHERE d.id_tiempo IS NULL) AS huerfanos_tiempo;

-- 3. Valores nulos relevantes
SELECT COUNT(*) FILTER (WHERE na_sales IS NULL) AS nulos_na,
       COUNT(*) FILTER (WHERE eu_sales IS NULL) AS nulos_eu,
       COUNT(*) FILTER (WHERE jp_sales IS NULL) AS nulos_jp,
       COUNT(*) FILTER (WHERE other_sales IS NULL) AS nulos_otras,
       COUNT(*) FILTER (WHERE critic_score IS NULL) AS sin_critic_score
FROM fact_ventas;

-- 4. Totales principales (deben coincidir con el KPI de la app: 8,814.71 sin filtros)
SELECT ROUND(SUM(na_sales),2) AS na, ROUND(SUM(eu_sales),2) AS eu,
       ROUND(SUM(jp_sales),2) AS jp, ROUND(SUM(other_sales),2) AS otras,
       ROUND(SUM(na_sales+eu_sales+jp_sales+other_sales),2) AS global
FROM fact_ventas;

-- 5. Coherencia con los datos limpios (el total debe ser igual al anterior)
SELECT ROUND(SUM(na_sales+eu_sales+jp_sales+other_sales)::numeric,2) AS global_limpio
FROM videojuegos_limpio;