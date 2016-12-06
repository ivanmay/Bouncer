echo "Stop praetorian_db"
docker stop praetorian_db

echo "Remove Image"
docker rm praetorian_db

echo "Run Praetorian db"
docker run --name "praetorian_db" -d -p 5433:5432 praetorian_db:latest
