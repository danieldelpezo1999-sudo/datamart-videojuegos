\# Entregable 3 - Mi primer dashboard (Business Intelligence)



Dashboard de ventas de videojuegos con PostgreSQL, Python y Streamlit.



\## Dataset

\- Nombre: Video Games Sales with Ratings (Kaggle, ventas de VGChartz + puntuaciones de Metacritic)

\- Aprox. 16.716 registros tras la limpieza, años 1980-2016

\- Una fila de la tabla de hechos representa: un videojuego lanzado en una plataforma en un año determinado.



\## Modelo dimensional

\- Hechos: fact\_ventas (ventas por región, critic\_score, critic\_count, user\_score, user\_count)

\- Dimensiones: dim\_videojuego, dim\_plataforma, dim\_publisher, dim\_tiempo

\- Vistas SQL para la app: vw\_detalle\_ventas, vw\_ventas\_resumen



\## Requisitos

\- Docker Desktop

\- Python 3.10 o superior



\## Cómo ejecutar

1\. Levantar PostgreSQL:

&#x20;  docker compose up -d

&#x20;  (puerto 5433, base bi\_database, usuario bi\_user; la contraseña está en docker-compose.yml)

2\. Cargar datos y crear las vistas con los scripts de la carpeta sql/ (en orden).

3\. Instalar dependencias:

&#x20;  pip install -r requirements.txt

4\. En app.py, verificar que la contraseña del diccionario DB coincida con docker-compose.yml.

5\. Ejecutar la app:

&#x20;  python -m streamlit run app.py

6\. Abrir http://localhost:8501



\## Notas

\- La app consulta solo PostgreSQL; nunca lee el CSV original.

\- Los 269 juegos sin año de lanzamiento (98,92 millones en ventas) no aparecen al filtrar por rango de años.

