--1. CANTIDAD DE REGISTROS CARGADOS
SELECT 'fact_ventas' AS tabla, COUNT(*) AS filas FROM fact_ventas
UNION ALL SELECT 'dim_videojuego', COUNT(*) FROM dim_videojuego
UNION ALL SELECT 'dim_plataforma', COUNT(*) FROM dim_plataforma
UNION ALL SELECT 'dim_publisher',  COUNT(*) FROM dim_publisher
UNION ALL SELECT 'dim_tiempo',     COUNT(*) FROM dim_tiempo;

--2. INTEGRIDAD DE LAS RELACIONES
SELECT
    COUNT(*) FILTER (WHERE j.id_juego      IS NULL) AS sin_juego,
    COUNT(*) FILTER (WHERE p.id_plataforma IS NULL) AS sin_plataforma,
    COUNT(*) FILTER (WHERE pu.id_publisher IS NULL) AS sin_publisher,
    COUNT(*) FILTER (WHERE t.id_tiempo     IS NULL) AS sin_tiempo
FROM fact_ventas f
LEFT JOIN dim_videojuego j  ON j.id_juego      = f.id_juego
LEFT JOIN dim_plataforma p  ON p.id_plataforma = f.id_plataforma
LEFT JOIN dim_publisher  pu ON pu.id_publisher = f.id_publisher
LEFT JOIN dim_tiempo     t  ON t.id_tiempo     = f.id_tiempo;

--3. VALORES NULOS RELEVANTES
SELECT
    COUNT(*) FILTER (WHERE f.critic_score IS NULL) AS sin_critic_score,
    COUNT(*) FILTER (WHERE f.user_score   IS NULL) AS sin_user_score,
    COUNT(*) FILTER (WHERE t.anio         IS NULL) AS sin_anio
FROM fact_ventas f
JOIN dim_tiempo t ON t.id_tiempo = f.id_tiempo;

--4. TOTALES O MEDIDAS PRINCIPALES
SELECT
    SUM(na_sales)    AS na,
    SUM(eu_sales)    AS eu,
    SUM(jp_sales)    AS jp,
    SUM(other_sales) AS otras,
    SUM(na_sales + eu_sales + jp_sales + other_sales) AS global_calculado
FROM fact_ventas;