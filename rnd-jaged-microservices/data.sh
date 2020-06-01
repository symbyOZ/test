curl -L -O https://github.com/golang-migrate/migrate/releases/download/v4.8.0/migrate.linux-amd64.tar.gz
echo "c92ff8b5085b0de4c027c8c3069529c5e097b02e45effc7c21c46d5952bbf509  migrate.linux-amd64.tar.gz" | sha256sum -c - 
tar xzf migrate.linux-amd64.tar.gz
mv migrate.linux-amd64 /usr/local/bin/migrate
rm -f migrate.linux-amd64.tar.gz
