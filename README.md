# docker-eossdk



### Build HelloWorld

```
docker build -t eossdk .
docker run --rm -it -v $(pwd)/examples:/project eossdk
make

```