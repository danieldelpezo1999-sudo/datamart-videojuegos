CREATE TABLE dim_videojuego (
    id_juego   SERIAL PRIMARY KEY,
    nombre     TEXT NOT NULL,
    genero     TEXT,
    developer  TEXT,
    rating     TEXT
);

CREATE TABLE dim_plataforma (
    id_plataforma     SERIAL PRIMARY KEY,
    nombre_plataforma TEXT NOT NULL UNIQUE
);

CREATE TABLE dim_publisher (
    id_publisher     SERIAL PRIMARY KEY,
    nombre_publisher TEXT NOT NULL UNIQUE
);

CREATE TABLE dim_tiempo (
    id_tiempo SERIAL PRIMARY KEY,
    anio      INT UNIQUE,
    decada    TEXT NOT NULL
);

CREATE TABLE fact_ventas (
    id_venta      SERIAL PRIMARY KEY,
    id_juego      INT NOT NULL REFERENCES dim_videojuego(id_juego),
    id_plataforma INT NOT NULL REFERENCES dim_plataforma(id_plataforma),
    id_publisher  INT NOT NULL REFERENCES dim_publisher(id_publisher),
    id_tiempo     INT NOT NULL REFERENCES dim_tiempo(id_tiempo),
    na_sales      NUMERIC(6,2) NOT NULL,
    eu_sales      NUMERIC(6,2) NOT NULL,
    jp_sales      NUMERIC(6,2) NOT NULL,
    other_sales   NUMERIC(6,2) NOT NULL,
    critic_score  INT,
    critic_count  INT,
    user_score    NUMERIC(3,1),
    user_count    INT
);

--consulta para verficacion de tablas
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;