-- Modelo dimensional: Video Games Sales (esquema estrella)
-- Granularidad: una fila de fact_ventas = un videojuego lanzado en una plataforma en un año.

CREATE TABLE IF NOT EXISTS dim_plataforma (
    id_plataforma     INTEGER PRIMARY KEY,
    nombre_plataforma TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_publisher (
    id_publisher     INTEGER PRIMARY KEY,
    nombre_publisher TEXT
);

CREATE TABLE IF NOT EXISTS dim_tiempo (
    id_tiempo INTEGER PRIMARY KEY,
    anio      INTEGER,
    decada    TEXT
);

CREATE TABLE IF NOT EXISTS dim_videojuego (
    id_juego  INTEGER PRIMARY KEY,
    nombre    TEXT NOT NULL,
    genero    TEXT,
    developer TEXT,
    rating    TEXT
);

CREATE TABLE IF NOT EXISTS fact_ventas (
    id_venta      INTEGER PRIMARY KEY,
    id_juego      INTEGER NOT NULL REFERENCES dim_videojuego(id_juego),
    id_plataforma INTEGER NOT NULL REFERENCES dim_plataforma(id_plataforma),
    id_publisher  INTEGER NOT NULL REFERENCES dim_publisher(id_publisher),
    id_tiempo     INTEGER NOT NULL REFERENCES dim_tiempo(id_tiempo),
    na_sales      NUMERIC,
    eu_sales      NUMERIC,
    jp_sales      NUMERIC,
    other_sales   NUMERIC,
    critic_score  INTEGER,
    critic_count  INTEGER,
    user_score    NUMERIC,
    user_count    INTEGER
);