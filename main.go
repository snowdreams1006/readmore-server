package main

import (
	"fmt"
	"log"
	"net/http"
	"time"
)

func main() {
	go func() {
		for {
			time.Sleep(time.Second)
			log.Println("Checking if started ...")
			resp, err := http.Get("http://localhost:8080")
			if err != nil {
				log.Println("Failed: ", err)
				continue
			}
			resp.Body.Close()
			if resp.StatusCode != http.StatusOK {
				log.Println("Not OK:", resp.StatusCode)
				continue
			}
			break
		}
		log.Println("Server is up and running , http://localhost:8080")
	}()

	log.Println("Starting server ...")

	http.HandleFunc("/", func(writer http.ResponseWriter, request *http.Request) {
		fmt.Fprint(writer, "Welcome to readmore.snowdreams1006.cn! \n")
	})
	http.HandleFunc("/ping", func(writer http.ResponseWriter, request *http.Request) {
		fmt.Fprint(writer, "Pong \n")
	})
	http.HandleFunc("/test", func(writer http.ResponseWriter, request *http.Request) {
		fmt.Fprint(writer, "Received your test request! \n")
	})
	http.HandleFunc("/readme", func(writer http.ResponseWriter, request *http.Request) {
		fmt.Fprint(writer, "Update to v0.0.4 \n")
	})

	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal("readmore-server started failed: ", err)
	}
}
