# docker-eossdk

Copy stubs and cross-compilter to deps

```
copy /path/to/EosSdk-stubs-2.11.0.tar.gz deps/
```

### Build HelloWorld

```
docker build -t eossdk .
docker run --rm -it -v $(pwd)/examples:/project eossdk
make
```