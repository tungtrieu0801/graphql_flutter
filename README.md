dart version: 3.2.4
graphql_flutter: ^5.1.0
http: 0.13.4
api: https://rickandmortyapi.com/graphql
Notice: use CircularProgressIndicator for waiting load data from api.
All step: 
1. Install plugin graphql_flutter and http.
2. Write function fetchData (use asynce await).
3. Write body app(using Lisview.builder)
=> data will be stored in cache (use HiveStore to get the best performance)
