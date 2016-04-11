package main

import (
	"github.com/garyburd/redigo/redis"
	"log"
)

func main() {
	c, err := redis.Dial("tcp", ":6379")
	if err != nil {
		log.Fatal(err)
	}

	pubsub := redis.PubSubConn{c}
	pubsub.Subscribe("events")
	for {
		switch n := pubsub.Receive().(type) {
		case redis.Message:
			log.Printf("Message: %s %s\n", n.Channel, n.Data)
		case error:
			log.Println(n)
			return
		}
	}
}
