package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(writer http.ResponseWriter, request *http.Request) {
		fmt.Fprint(writer, "Welcome to readmore.snowdreams1006.cn! \n")
	})
	http.ListenAndServe(":80",nil)
}
