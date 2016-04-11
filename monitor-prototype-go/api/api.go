package main

import (
	"github.com/garyburd/redigo/redis"
	"io/ioutil"
	"log"
	"net/http"
)

func main() {
	c, err := redis.Dial("tcp", ":6379")
	if err != nil {
		log.Fatal(err)
	}
	defer c.Close()
	router := http.NewServeMux()
	router.HandleFunc("/events/", createEvent(c))
	log.Fatal(http.ListenAndServe(":4000", router))
}

func createEvent(c redis.Conn) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			read, err := ioutil.ReadAll(r.Body)
			if err != nil {
				log.Println(err)
				return
			}
			log.Println("Received", string(read))
			err = c.Send("PUBLISH", "events", string(read))
			err = c.Flush()
			if err != nil {
				log.Println(err)
				return
			}
		}
	}
}
