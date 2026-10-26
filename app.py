import streamlit as st
import psycopg2
import pandas as pd
import plotly.express as px

st.set_page_config(page_title="Dashboard Videojuegos", layout="wide")

# ---- CONEXIÓN A POSTGRESQL ----
DB = dict(host="localhost", port=5433, dbname="bi_database",
          user="bi_user", password="bi_password")

@st.cache_data(ttl=300)
def consulta(sql, params=None):
    conn = psycopg2.connect(**DB)
    try:
        cur = conn.cursor()
        cur.execute(sql, params)
        cols = [c[0] for c in cur.description]
        datos = cur.fetchall()
        cur.close()
    finally:
        conn.close()
    return pd.DataFrame(datos, columns=cols)

st.title("🎮 Dashboard de Ventas de Videojuegos")

# ---- FILTROS (barra lateral) ----
st.sidebar.header("Filtros")
rango = consulta("SELECT MIN(anio) AS a, MAX(anio) AS b FROM vw_detalle_ventas")
anio_min, anio_max = int(rango["a"][0]), int(rango["b"][0])
anios = st.sidebar.slider("Rango de años", anio_min, anio_max, (anio_min, anio_max))

lista_plat = consulta("SELECT DISTINCT plataforma FROM vw_detalle_ventas ORDER BY 1")["plataforma"].tolist()
plats = st.sidebar.multiselect("Plataforma", lista_plat, default=lista_plat)

lista_gen = consulta("SELECT DISTINCT genero FROM vw_detalle_ventas ORDER BY 1")["genero"].tolist()
gens = st.sidebar.multiselect("Género", lista_gen, default=lista_gen)

if not plats or not gens:
    st.warning("Selecciona al menos una plataforma y un género.")
    st.stop()

WHERE = "WHERE anio BETWEEN %s AND %s AND plataforma = ANY(%s) AND genero = ANY(%s)"
P = (anios[0], anios[1], plats, gens)

pagina = st.sidebar.radio("Sección", ["Resumen general", "Plataformas y publishers"])

# ================= SECCIÓN 1 =================
if pagina == "Resumen general":
    k = consulta(f"""
        SELECT SUM(ventas_globales) AS total,
               AVG(ventas_globales) AS promedio,
               SUM(critic_score * ventas_globales) /
               NULLIF(SUM(CASE WHEN critic_score IS NOT NULL THEN ventas_globales END), 0) AS score
        FROM vw_detalle_ventas {WHERE}""", P)
    c1, c2, c3 = st.columns(3)
    c1.metric("Ventas globales (millones)", f"{(k['total'][0] or 0):,.2f}")
    c2.metric("Promedio de ventas por título (millones)", f"{(k['promedio'][0] or 0):,.3f}")
    c3.metric("Score de críticos ponderado por ventas", f"{(k['score'][0] or 0):,.1f}")

    g1, g2 = st.columns(2)
    por_anio = consulta(f"""SELECT anio, SUM(ventas_globales) AS ventas
                            FROM vw_detalle_ventas {WHERE} GROUP BY anio ORDER BY anio""", P)
    g1.plotly_chart(px.line(por_anio, x="anio", y="ventas", markers=True,
                            title="Ventas globales por año (millones)"), use_container_width=True)

    reg = consulta(f"""SELECT SUM(ventas_na) AS "Norteamérica", SUM(ventas_eu) AS "Europa",
                              SUM(ventas_jp) AS "Japón", SUM(ventas_otras) AS "Otras"
                       FROM vw_detalle_ventas {WHERE}""", P)
    reg = reg.T.reset_index()
    reg.columns = ["Región", "Ventas"]
    g2.plotly_chart(px.bar(reg, x="Región", y="Ventas",
                           title="Ventas por región (millones)"), use_container_width=True)

    st.subheader("Top 15 videojuegos más vendidos")
    top = consulta(f"""SELECT videojuego, plataforma, publisher, anio, ventas_globales, critic_score
                       FROM vw_detalle_ventas {WHERE}
                       ORDER BY ventas_globales DESC LIMIT 15""", P)
    st.dataframe(top, use_container_width=True)

# ================= SECCIÓN 2 =================
else:
    g1, g2 = st.columns(2)
    plat = consulta(f"""SELECT plataforma, SUM(ventas_globales) AS ventas
                        FROM vw_ventas_resumen {WHERE}
                        GROUP BY plataforma ORDER BY ventas DESC LIMIT 10""", P)
    g1.plotly_chart(px.bar(plat, x="plataforma", y="ventas",
                           title="Top 10 plataformas por ventas (millones)"), use_container_width=True)

    gen = consulta(f"""SELECT genero, SUM(ventas_globales) AS ventas
                       FROM vw_ventas_resumen {WHERE}
                       GROUP BY genero ORDER BY ventas DESC""", P)
    g2.plotly_chart(px.bar(gen, x="genero", y="ventas",
                           title="Ventas por género (millones)"), use_container_width=True)

    st.subheader("Top 20 publishers: ventas y promedio por título")
    pub = consulta(f"""SELECT publisher,
                              SUM(num_juegos) AS juegos,
                              ROUND(SUM(ventas_globales)::numeric, 2) AS ventas_globales,
                              ROUND((SUM(ventas_globales) / SUM(num_juegos))::numeric, 3) AS promedio_por_titulo
                       FROM vw_ventas_resumen {WHERE}
                       GROUP BY publisher ORDER BY ventas_globales DESC LIMIT 20""", P)
    st.dataframe(pub, use_container_width=True)